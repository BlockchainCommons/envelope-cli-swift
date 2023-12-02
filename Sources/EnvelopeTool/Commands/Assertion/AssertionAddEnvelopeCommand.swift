import ArgumentParser
import BCFoundation

struct AssertionAddEnvelopeCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "envelope",
        abstract: "Add an assertion to the given envelope. The assertion must be a single envelope containing the entire assertion."
    )
    
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
        setupCommand()
        try fill()
        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        printOut(try envelope.addAssertion(assertion, salted: salted).ur)
    }
}
