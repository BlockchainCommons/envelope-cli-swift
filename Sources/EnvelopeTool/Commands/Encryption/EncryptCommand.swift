import ArgumentParser
import BCFoundation

struct EncryptCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "encrypt",
        abstract: "Encrypt the envelope's subject using the provided key."
    )

    @Argument var envelope: Envelope?
    @Option var key: SymmetricKey?
    @Option var recipient: [PublicKeyBase] = []

    mutating func fill() throws {
        if envelope == nil {
            envelope = try readIn(Envelope.self)
        }
        if key == nil && !recipient.isEmpty {
            key = SymmetricKey()
        }
    }

    mutating func run() throws {
        resetOutput()
        try fill()
        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        guard let key else {
            throw EnvelopeToolError.missingArgument("key")
        }
        if recipient.isEmpty {
            printOut(try envelope.encryptSubject(with: key).ur)
        } else {
            var e = try envelope.encryptSubject(with: key)
            for pubkeys in recipient {
                e = e.addRecipient(pubkeys, contentKey: key)
            }
            printOut(e.ur)
        }
    }
}
