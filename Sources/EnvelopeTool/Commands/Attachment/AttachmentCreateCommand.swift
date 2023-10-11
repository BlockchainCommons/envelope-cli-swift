import ArgumentParser
import BCFoundation

struct AttachmentCreateCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "create",
        abstract: "Create an attachment."
    )
    
    @Argument
    var vendor: String
    
    @Option
    var conformsTo: String?

    @Argument
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
