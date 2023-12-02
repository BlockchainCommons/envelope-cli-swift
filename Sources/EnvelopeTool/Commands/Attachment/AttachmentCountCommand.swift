import ArgumentParser
import BCFoundation

struct AttachmentCountCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "count",
        abstract: "Print the count of the envelope's attachments."
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
        try printOut(envelope.attachments().count)
    }
}
