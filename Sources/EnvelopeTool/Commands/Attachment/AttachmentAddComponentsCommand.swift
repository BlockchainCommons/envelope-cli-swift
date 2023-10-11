import ArgumentParser
import BCFoundation

struct AttachmentAddComponentsCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "components",
        abstract: "Add an attachment to the given envelope.",
        discussion: "The components of the attachment are provided as separate arguments.")
    
    @Argument
    var vendor: String
    
    @Option
    var conformsTo: String?

    @Argument
    var payload: Envelope

    @Argument
    var subject: Envelope?
    
    mutating func fill() throws {
        if subject == nil {
            subject = try readIn(Envelope.self)
        }
    }
    
    mutating func run() throws {
        resetOutput()
        try fill()
        guard let subject else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        let attachment = Envelope(payload: payload, vendor: vendor, conformsTo: conformsTo)
        try attachment.validateAttachment()
        printOut(try subject.addAssertion(attachment).ur)
    }
}
