import std/rdstdin
import std/strutils

proc main() =
     try:
          let input = readLineFromStdin().split(" ")
     except IOError, EOFError:
          echo "Could not Read File"

     echo "This is Nimmits"
     echo input.join(" ")


main()

# TODO: Check if we are in a git directory if not create an error
# TODO: Check the last git commit of the branch using the git log command
# TODO: Check if it is a valid git commit