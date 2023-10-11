import ArgumentParser
import BCFoundation

struct AttachmentVendorCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "vendor",
        abstract: "Get the vendor of the attachment."
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
        printOut(try attachment.attachmentVendor)
    }
}
