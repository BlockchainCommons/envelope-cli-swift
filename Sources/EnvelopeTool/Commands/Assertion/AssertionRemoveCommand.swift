import ArgumentParser
import BCFoundation

struct AssertionRemoveCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "remove",
        abstract: "Remove an assertion from the given envelope.",
        subcommands: [
            AssertionRemovePredicateObjectCommand.self,
            AssertionRemoveEnvelopeCommand.self,
        ],
        defaultSubcommand: AssertionRemovePredicateObjectCommand.self
    )
}

struct AssertionRemovePredicateObjectCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "predicate-object", abstract: "Remove an assertion with the given predicate and object from the given envelope.")

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
        let result = try envelope.removeAssertion(arguments.assertion)
        printOut(result.ur)
    }
}

struct AssertionRemoveEnvelopeCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "envelope", abstract: "Add an assertion to the given envelope. The assertion must be a single envelope containing the entire assertion.")
    
    @Argument
    var assertion: Envelope
    
    @Argument
    var envelope: Envelope?
    
    @Flag(help: "Add salt to the assertion.")
    var salted: Bool = false
    
    mutating func fill() throws {
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
        printOut(envelope.removeAssertion(assertion).ur)
    }
}
