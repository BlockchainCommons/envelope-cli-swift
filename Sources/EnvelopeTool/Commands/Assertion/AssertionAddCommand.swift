import ArgumentParser
import BCFoundation


struct AssertionAddCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "add",
        abstract: "Add an assertion to the given envelope.",
        subcommands: [
            AssertionAddPredicateObjectCommand.self,
            AssertionAddEnvelopeCommand.self,
        ],
        defaultSubcommand: AssertionAddPredicateObjectCommand.self
    )
}

struct AssertionAddPredicateObjectCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "predicate-object", abstract: "Add an assertion with the given predicate and object to the given envelope.")

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
        resetOutput()
        try fill()
        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        printOut(try envelope.addAssertion(arguments.assertion, salted: salted).ur)
    }
}

struct AssertionAddEnvelopeCommand: ParsableCommand {
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
        printOut(try envelope.addAssertion(assertion, salted: salted).ur)
    }
}
