import ArgumentParser
import BCFoundation

struct AttachmentFindCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "find",
        abstract: "Retrieve attachments having the specified attributes.",
        discussion: "If no attributes are specified, all attachments are returned."
    )

    @Option var vendor: String?
    @Option var conformsTo: String?
    
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
        let attachments = try envelope.attachments(withVendor: vendor, conformingTo: conformsTo)
        printOut(attachments.map { $0.ur.string }.joined(separator: "\n"))
    }
}
