# import rdstdin
import os
import typetraits
import system
import ./commit

proc main() =
    # try:
    #     var input: seq[string] = readLineFromStdin("Welcome to Nimits: ").split(" ")
    # except IOError, EOFError:
    #     raise
    if dirExists(".git") == false:
        echo "No Git directory found"
        raise NOGIT
    try:
        # var file = "tmp.commit"
        createCommitFile()
        var procs = getCommitProcs()
        for p in procs:
            discard validateCommitProc(p)
    except OSError, IOError:
        raise

main()

# TODO check if the commit contains a non imperative verb at the beginning
# TODO check if the commit contains a pronoun
# TODO allow the user to check all commits
# TODO allow the user to check a range of commits
# TODO nimpretty to pipeline
# TODO add a test suite
# TODO add nimit to the pipeline to check the commit message! Nimit checks nimit!
# TODO change csv columns to enums with a macro
