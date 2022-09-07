import ArgumentParser
import BCFoundation

struct ValidateCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "validate", abstract: "Validate a signature on the envelope using the provided public key base.")

    @Argument var envelope: Envelope?
    @Argument var pubkeys: PublicKeyBase?
    
    mutating func fill() throws {
        if envelope == nil {
            envelope = try readIn(Envelope.self)
        }
        if pubkeys == nil {
            pubkeys = try readIn(PublicKeyBase.self)
        }
    }

    mutating func run() throws {
        resetOutput()
        try fill()
        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        guard let pubkeys else {
            throw EnvelopeToolError.missingArgument("pubkeys")
        }
        try envelope.validateSignature(from: pubkeys)
    }
}
