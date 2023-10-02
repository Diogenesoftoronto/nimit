import parseopt
import strformat

type
    CmdKind = enum
        boolean,
        integer,
        floating,
        str,
        None
    Cmd = object
        short, long, help: string
        required: bool
        case kind: CmdKind
        of boolean: bvalue: bool
        of integer: ivalue: int
        of floating: fvalue: float
        of str: svalue: string
        of None:
            discard

# Command constructor for more generic use in another project in the future
proc createCmd(props: varargs[Cmd]): seq[Cmd] =
    for v in props:
        case v.kind:
        of boolean:
            result.add(Cmd(short: v.short, long: v.long, help: v.help, required: v.required))

        of integer:
            result.add(Cmd(short: v.short, long: v.long, help: v.help, required: v.required))
        of floating:
            result.add(Cmd(short: v.short, long: v.long, help: v.help, required: v.required))
        of str:
            result.add(Cmd(short: v.short, long: v.long, help: v.help, required: v.required))
        else:
            result.add(Cmd(short: v.short, long: v.long, help: v.help, required: v.required))


# Create a help or man out of the command line tool
proc createHelp(props: varargs[Cmd]): string =
    for v in props:
        result.add(fmt"-{v.short}, --{v.long}\t {v.help} {$v.required}\n")

proc parseCmds(input: string) =
    var props = [
    (Cmd(kind: None, short: "h", long: "help", help: "Show this help", required: false)),
    (Cmd(kind: None, short: "v", long: "version", help: "Show version", required: false)),
    (Cmd(kind: None, short: "V", long: "verbose", help: "Verbose output", required: false)),
    (Cmd(kind: str, short: "i", long: "input",  help: "Input file", required: false)),
    (Cmd(kind: str, short: "o", long: "output", help: "Output file", required: true)),
    (Cmd(kind: integer, short: "n", long: "number", help: "Number of commits to process", required: true)),
    ] 
    
    var allCmds = createCmd(props)
    var help = createHelp(allCmds)
    var parser = initOptParser(input)

