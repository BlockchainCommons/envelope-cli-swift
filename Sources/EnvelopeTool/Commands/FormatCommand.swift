import ArgumentParser
import BCFoundation

struct FormatCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "format", abstract: "Print the envelope in Envelope Notation.")

    @Argument(help: "The envelope to format.")
    var envelope: Envelope?
    
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
        printOut(envelope.format)
    }
}
