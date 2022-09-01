import ArgumentParser
import BCFoundation

struct AddAssertionCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "add", abstract: "Add an assertion to the given envelope")

    @Argument(help: "The envelope to add the assertion to.")
    var envelope: Envelope?

    @OptionGroup
    var arguments: AssertionArguments
    
    mutating func fill() throws {
        if envelope == nil {
            envelope = try readIn(Envelope.self)
        }
        try arguments.fill()
    }

    mutating func run() throws {
        resetOutput()
        try fill()
        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        printOut(try envelope.addAssertion(arguments.assertion).ur)
    }
}
