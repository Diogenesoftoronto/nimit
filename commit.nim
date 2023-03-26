import strutils
# import os
import re
import strformat
# import sequtils
import typetraits
import system
import osproc
import parsecsv

# Exceptions
var
    NOGIT*: ref CatchableError
new(NOGIT)
NOGIT.msg = "No git directory is present"

# structs
type
    commit* = object
        hash: string
        date: string
        body: string
        author: string
        procedure: string # this is the title of the commit But I called it a procedure
 # because that is the way a commit should be written

# We must get the commit messages and store them for later use
proc createCommitFile*(file: string = "tmp.commit", n: Natural = 1, h: string  = "") {.raises: [Exception].} =
    # consider a database instead of a file at some point
    try:
        var cmd: string
        if h isnot "":
            cmd = fmt"git show {h} > {file}"
        else:
            # here we make a whole bunch of temp files, mark them for deletion except for the user requested output
            cmd = fmt"git log -{$n} > {file}"
        var ok = execCmd(cmd)
        if ok != 0:
            raise new(OSError)
    except ValueError, Exception:
        raise

# We must get all the commits procedures from the git log
proc getCommitProcs*(file: string = "tmp.commit"): seq[string] {.raises: [IOError].} =
    try:
        var f = open(file)
        defer: f.close()
        var lineNumber = 0
        for line in f.lines:
            inc lineNumber
            if lineNumber == 6 and line.len > 0:
                # Check if the subject is separated from the body by a blank line
                quit(1)
            if lineNumber == 5:
                # check if the subject line is over 50 characters
                if line.len > 50:
                    quit(1)
                #  Check if the subject line is capitalized
                if line[0].isLowerAscii:
                    quit(1)
                #  Check if the subject line ends with a period
                if line[^1] == '.':
                    quit(1)
                # Check if the subject line is in the imperative mood
                result.add(line)

    except IOError as e:
        raise e


#  We must validate that the commit message is in the imperative mood
proc validateCommitProc*(commit: string): bool {.raises: [OSError, IOError, Exception].} =
    result = false
    var p: CsvParser
    var q: CsvParser
    p.open("./data/pronouns.csv")
    q.open("./data/verbs.csv")
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
                result = false
                # later output a stack trace of linting errors
                echo "Invalid commit message"
                break
    while q.readRow():
        for col in items(q.headers):
            if col != "Word":
                continue
            var val = q.rowEntry(col)
            # remove empty spaces from a string
            if commit.strip.startsWith(val):
                result = true
                echo "Valid commit message"
                break
    if result == false:
        echo "Invalid commit message"
        result = false
        raise new(OSError)
