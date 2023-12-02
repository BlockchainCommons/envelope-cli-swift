import ArgumentParser
import BCFoundation

struct AttachmentPayloadCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "payload",
        abstract: "Get the payload of the attachment."
    )

    @Argument
    var attachment: Envelope?
    
    mutating func fill() throws {
        if attachment == nil {
            attachment = try readIn(Envelope.self)
        }
    }

    mutating func run() throws {
        setupCommand()
        try fill()
        guard let attachment else {
            throw EnvelopeToolError.missingArgument("attachment")
        }
        try printOut(attachment.attachmentPayload.ur)
    }
}
