import ArgumentParser
import BCFoundation

struct AttachmentCreateCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "create",
        abstract: "Create an attachment."
    )
    
    @Argument(help: "The vendor that adds this attachment. Usually a reverse domain name.")
    var vendor: String
    
    @Option(help: "The spec to which this attachment conforms. Usually a URI.")
    var conformsTo: String?

    @Argument(help: "The payload of the attachment. Entirely specified by the vendor.")
    var payload: Envelope?

    mutating func fill() throws {
        if payload == nil {
            payload = try readIn(Envelope.self)
        }
    }
    
    mutating func run() throws {
        resetOutput()
        try fill()
        guard let payload else {
            throw EnvelopeToolError.missingArgument("payload")
        }
        printOut(Assertion(payload: payload, vendor: vendor, conformsTo: conformsTo).envelope.ur)
    }
}
