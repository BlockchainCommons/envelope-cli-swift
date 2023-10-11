import ArgumentParser
import BCFoundation

struct AttachmentConformsToCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "conforms-to",
        abstract: "Get the (optional) conformance of the attachment."
    )

    @Argument
    var attachment: Envelope?
    
    mutating func fill() throws {
        if attachment == nil {
            attachment = try readIn(Envelope.self)
        }
    }

    mutating func run() throws {
        resetOutput()
        try fill()
        guard let attachment else {
            throw EnvelopeToolError.missingArgument("attachment")
        }
        if let conformsTo = try attachment.attachmentConformsTo {
            printOut(conformsTo)
        }
    }
}
