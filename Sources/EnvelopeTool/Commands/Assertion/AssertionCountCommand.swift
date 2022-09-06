import ArgumentParser
import BCFoundation

struct AssertionCountCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "count", abstract: "Print the count of the envelope's assertions.")

    @Argument var envelope: Envelope?
    
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
        printOut(envelope.assertions.count)
    }
}
