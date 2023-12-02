import ArgumentParser
import BCFoundation

struct AttachmentAddComponentsCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "components",
        abstract: "Add an attachment to the given envelope.",
        discussion: "The components of the attachment are provided as separate arguments.")
    
    @Argument(help: "The vendor that adds this attachment. Usually a reverse domain name.")
    var vendor: String
    
    @Option(help: "The spec to which this attachment conforms. Usually a URI.")
    var conformsTo: String?

    @Argument(help: "The payload of the attachment. Entirely specified by the vendor.")
    var payload: Envelope

    @Argument(help: "The envelope to which to add the attachment.")
    var subject: Envelope?
    
    mutating func fill() throws {
        if subject == nil {
            subject = try readIn(Envelope.self)
        }
    }
    
    mutating func run() throws {
        setupCommand()
        try fill()
        guard let subject else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        let attachment = Envelope(payload: payload, vendor: vendor, conformsTo: conformsTo)
        try attachment.validateAttachment()
        printOut(try subject.addAssertion(attachment).ur)
    }
}
