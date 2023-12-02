import ArgumentParser
import BCFoundation

struct AssertionAddPredObjCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "pred-obj",
        abstract: "Add an assertion with the given predicate and object to the given envelope."
    )

    @OptionGroup
    var arguments: AssertionArguments

    @Argument
    var envelope: Envelope?
    
    @Flag(help: "Add salt to the assertion.")
    var salted: Bool = false

    mutating func fill() throws {
        try arguments.fill()
        if envelope == nil {
            envelope = try readIn(Envelope.self)
        }
    }

    mutating func run() throws {
        setupCommand()
        try fill()
        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        printOut(try envelope.addAssertion(arguments.assertion, salted: salted).ur)
    }
}
