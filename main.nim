# import rdstdin
import strutils
import os
# import re
# import strformat
# import sequtils
import typetraits
import system
import osproc
import parsecsv

# Exceptions
var
    NOGIT: ref CatchableError
new(NOGIT)
NOGIT.msg = "No git directory is present"

proc getLatestCommit(): string {.raises: [OSError, IOError].} =
    let cmd = "git log -1 > tmp.commit"
    var ok = execCmd(cmd)
    if ok != 0:
        raise new(OSError)
    try:
        var f = open("./tmp.commit")
        defer: f.close()
        var lineNumber = 0
        for line in f.lines:
            inc lineNumber
            if lineNumber == 5:
                result = line
    except IOError as e:
        raise e

proc validateCommit(commit: string): bool {.raises: [OSError, IOError, Exception].} =
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


proc main() =
    # try:
    #     var input: seq[string] = readLineFromStdin("Welcome to Nimits: ").split(" ")
    # except IOError, EOFError:
    #     raise
    if dirExists(".git") == false:
        echo "No Git directory found"
        raise NOGIT
    try:
        var msg = getLatestCommit()
        validateCommit(msg)
    except OSError, IOError:
        raise

main()

# TODO check if the commit is capitalized
# TODO check if the commit is more than 50 characters
# TODO check if the commit contains a period at the end
# TODO check if the commit contains a non imperative verb at the beginning
# TODO check if the commit contains a pronoun
# TODO allow the user to check all commits 
# TODO allow the user to check a specific commit (commit hash)
# TODO allow the user to check a range of commits
# TODO nimpretty to pipeline
# TODO add a test suite
# TODO add nimit to the pipeline to check the commit message! Nimit checks nimit!