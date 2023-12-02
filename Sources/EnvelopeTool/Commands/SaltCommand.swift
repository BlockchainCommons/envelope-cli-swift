import ArgumentParser
import BCFoundation

struct SaltCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "salt",
        abstract: "Add random salt to the envelope.",
        discussion: "If the size of the salt is not specified, the amount is random. For small objects, the number of bytes added will generally be from 8...16. For larger objects the number of bytes added will generally be from 5%...25% of the size of the object."
    )

    @Argument var envelope: Envelope?
    @Option var size: Int?
    
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
        if let size {
            printOut(try envelope.addSalt(size).ur)
        } else {
            printOut(envelope.addSalt().ur)
        }
    }
}
