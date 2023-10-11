import ArgumentParser
import BCFoundation

struct AttachmentAllCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "all",
        abstract: "Retrieve all the envelope's attachments."
    )
    
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
        try printOut(envelope.attachments().map { $0.ur.string }.joined(separator: "\n"))
    }
}
