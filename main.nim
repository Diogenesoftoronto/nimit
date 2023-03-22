import rdstdin
import strutils
import os
# import sequtils
import typetraits
import system
import osproc


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
          var commit = readFile("tmp.commit")
          var lineNumber = 0
          for line in commit.lines:
               if lineNumber == 4:
                    result = line
               inc lineNumber
     except IOError:
          raise new(IOError)
     



proc main() =
     try:
          var input: seq[string] = readLineFromStdin("Welcome to Nimits: ").split(" ")
          echo input
     except IOError, EOFError:
          raise
     if dirExists(".git") == false:
          echo "No Git directory found"
          raise NOGIT 
     try: 
          let msg = getLatestCommit()
          echo msg
     except OSError, IOError:  
          raise

main()

# TODO: Check the last git commit of the branch using the git log command
# TODO: Check if it is a valid git commit**
     # check if sentence begins with a verb
     # check that the verb is in its imperative tense
     # if not alert the user
     # if so we are going accept