import strutils
import options
import std/enumerate
import os
import re
import strformat
import typetraits
import system
import osproc
import parsecsv

# Exceptions
var
    NoGit*: ref CatchableError
new(NoGit)
NoGit.msg = "No git directory is present"

# structs
type
    commit* = object
        hash: string
        date: string
        body: string
        author: string
        procedure: string # this is the title of the commit But I called it a procedure
 # because that is the way a commit should be written
type
    CommitErr = object
        commit: string
        line: int
        index: int
        hash: string
        issue: string

var pronounDataDefault: string = "./data/pronouns.csv"
var verbDataDefault: string = "./data/verbs.csv"
# We must get the commit messages and store them for later use
proc createCommitFile*(file: string, amount: Natural , all: bool, since: string, until: string, gitHash: string) {.raises: [Exception].} =
    # consider a database instead of a file at some point
    try:
        var cmd: string
        if all:
            cmd = fmt"git log > {$file}"
        elif gitHash != "":
            cmd = fmt"git log {$gitHash} --no-merges -{$amount} > {$file}"
        elif since == "" or until == "":
            cmd = fmt"git log -{$amount} --no-merges > {$file}"
        else:
            # here we make a whole bunch of temp files, mark them for deletion except for the user requested output
            cmd = fmt"git log --since={$since} --until={$until} -{$amount}--no-merges > {$file}"
        var ok = execCmd(cmd)
        if ok != 0:
            raise new(OSError)
    except ValueError, Exception:
        raise

#  We must validate that the commit message is in the imperative mood
proc validateCommit*(commit: string, pronouns: string, verbs: string): Option[string]{.raises: [OSError, IOError, Exception].} =
    var p: CsvParser
    var q: CsvParser
    # TODO: Instead of a csv have an map for comparison. Create a separate program that
    # will process csvs or alternative files given in nimit.toml/config files and
    # out put that map
    p.open(pronouns)
    q.open(verbs)
    defer: p.close()
    defer: q.close()
    # check if sentence begins with a verb
    p.readHeaderRow
    q.readHeaderRow
    # Check if the subject line contains a pronoun
    # Check if the subject line contains a non imperative verb
    while p.readRow():
        for val in items(p.row):
            # match the word in the commit message
            var pronoun = re fmt"\s{val}\s"
            if pronoun in commit:
                result = some "Pronoun"
                # later output a stack trace of linting errors
                break
    while q.readRow():
        for col in items(q.headers):
            if col != "Word":
                continue
            var val = q.rowEntry(col)
            # remove empty spaces from a string
            if commit.strip.startsWith(val):
                result = none string
                break


# We must get all the commits procedures from the git log
proc getCommit*(file: string, pronouns, verbs: string): seq[CommitErr] {.raises: [IOError, Exception].} =
    try:
        var f = open(file)
        defer: f.close()
        var r: CommitErr
        for i, line in enumerate(f.lines):
            if i == 5 and line.len > 0:
                # Check if the subject is separated from the body by a blank line
                r.commit = line.strip
                r.line = i
                r.index = 0
                r.issue = "Seperate by newline"
                result.add(r)
            elif i == 0:
                var start = "commit ".len
                r.hash = line[start..^1]
            elif i == 4:
                # check if the subject line is over 50 characters
                if line.strip.len > 50:
                    r.commit = line.strip
                    r.line = i
                    r.index = line.len - 1
                    r.issue = "Shorten"
                    result.add(r)
                #  Check if the subject line is capitalized
                elif line.strip[0].isLowerAscii:
                    r.commit = line.strip
                    r.line = i
                    r.index = 0
                    r.issue = "Capitalize"
                    result.add(r)
                #  Check if the subject line ends with a period
                elif line.strip[^1] == '.':
                    r.commit = line.strip
                    r.line = i
                    r.index = line.len - 1
                    r.issue = "Remove period"
                    result.add(r)
                
                try:# Check if the subject line is in the imperative mood

                    var msg = validateCommit(line, pronouns, verbs)
                    if msg.isSome:
                        r.commit = line.strip
                        r.line = i
                        r.index = 0
                        r.issue = msg.get 
                        result.add(r)
                except:
                    raise newException(Exception, "validation failure")
    except IOError as e:
        raise e

proc prettyPrintError(error: CommitErr): string =
    result = "Commit " & error.hash & "\n" &
             error.commit & "\n" &
             repeat('\n', (error.line - 4)) &
             repeat(' ', error.index) & "^" & "\n\n" &
             "ERROR: " & error.issue

type 
    DirNotFoundError = object of OSError
    NimitError = object of OSError

proc Nimit*(prettyPrint: bool = false, dir: string = ".", file: string = "tmp.commit", amount: Natural = 1, all: bool = false, since: string = "", until: string = "", gitHash: string  = "", pronouns: string = pronounDataDefault, verbs: string = verbDataDefault) {.raises: [DirNotFoundError, Exception] } =    
    if dirExists(dir) == false:
        raise newException(DirNotFoundError, "The directory does not exist -> "&dir)
    try:
        setCurrentDir(dir)
    except:
        raise
    if dirExists(".git") == false:
        raise NoGit
    try:
        createCommitFile(file, amount, all, since, until, gitHash)
        var errs = getCommit(file, pronouns, verbs)
        for err in errs:
            if prettyPrint:
                echo prettyPrintError(err)
            else:
                echo err
        if errs.len > 0:
            raise newException(NimitError, fmt"Nimit found {errs.len}")
    except OSError, IOError:
        raise newException(Exception, "Create commit or get commit failed")

when isMainModule: 
  import cligen
  dispatch Nimit
