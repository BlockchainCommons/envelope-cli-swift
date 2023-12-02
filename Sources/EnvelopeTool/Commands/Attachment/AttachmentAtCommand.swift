import ArgumentParser
import BCFoundation

struct AttachmentAtCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "at",
        abstract: "Retrieve the attachment at the given index."
    )
    
    @Argument var index: Int
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
        let attachments = try envelope.attachments()
        let range = 0..<attachments.count
        guard range.contains(index) else {
            throw EnvelopeToolError.indexOutOfRange(range, index)
        }
        printOut(attachments[index].ur)
    }
}
