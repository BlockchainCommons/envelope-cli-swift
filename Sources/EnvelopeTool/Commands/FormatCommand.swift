import ArgumentParser
import BCFoundation

struct FormatCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "format", abstract: "Print the envelope in Envelope Notation.")

    @Argument(help: "The envelope to format.")
    var envelope: Envelope?
    
    mutating func run() throws {
        resetOutput()
        if envelope == nil {
            envelope = readIn(Envelope.self)
        }
        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        printOut(envelope.format)
    }
}
