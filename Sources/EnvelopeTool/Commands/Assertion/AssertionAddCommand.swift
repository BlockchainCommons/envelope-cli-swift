import ArgumentParser
import BCFoundation

struct AssertionAddCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "add", abstract: "Add an assertion to the given envelope.")

    @OptionGroup
    var arguments: AssertionArguments

    @Argument
    var envelope: Envelope?
    
    mutating func fill() throws {
        try arguments.fill()
        if envelope == nil {
            envelope = try readIn(Envelope.self)
        }
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
