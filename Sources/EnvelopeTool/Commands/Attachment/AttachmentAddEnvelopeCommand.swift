import ArgumentParser
import BCFoundation

struct AttachmentAddEnvelopeCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "envelope",
        abstract: "Add an attachment to the given envelope.",
        discussion:"The attachment must be a single envelope containing the entire attachment."
    )
    
    @Argument
    var attachment: Envelope
    
    @Argument
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
        try attachment.validateAttachment()
        printOut(try envelope.addAssertion(attachment).ur)
    }
}
