import ArgumentParser
import BCFoundation

struct SubjectSingleCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "single",
        abstract: "Create an envelope with the given subject."
    )

    @OptionGroup
    var arguments: SubjectArguments
    
    mutating func fill() throws {
        try arguments.fill()
    }
    
    mutating func run() throws {
        setupCommand()
        try fill()
        printOut(try arguments.envelope.ur)
    }
}
