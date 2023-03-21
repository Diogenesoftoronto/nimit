import rdstdin
import strutils
import os
import sequtils
import typetraits
import system

# Exceptions
var
  NOGIT: ref CatchableError
new(NOGIT)
NOGIT.msg = "No git directory is present"

proc main() =
     if dirExists(".git") == false:
          echo "No Git directory found"
          raise NOGIT 
     echo "This is Nimmits"
     try:
          var input: seq[string] = readLineFromStdin("Welcome to Nimits: ").split(" ")
          echo input
     except IOError, EOFError:
          echo "Could not Read File"


main()

# TODO: Check the last git commit of the branch using the git log command
# TODO: Check if it is a valid git commit