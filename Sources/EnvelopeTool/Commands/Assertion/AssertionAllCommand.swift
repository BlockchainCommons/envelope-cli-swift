import ArgumentParser
import BCFoundation

struct AssertionAllCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "all",
        abstract: "Retrieve all the envelope's assertions."
    )
    
    @Argument var envelope: Envelope?
    
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
        printOut(envelope.assertions.map { $0.ur.string }.joined(separator: "\n"))
    }
}
