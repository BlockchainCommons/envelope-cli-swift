import ArgumentParser
import BCFoundation

struct DecryptCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "decrypt", abstract: "Decrypt the envelope's subject using the provided key.")

    @Argument var envelope: Envelope?
    @Option var key: SymmetricKey?
    @Option var recipient: PrivateKeyBase?
    
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
        if let key {
            printOut(try envelope.decryptSubject(with: key).ur)
        } else if let recipient {
            printOut(try envelope.decrypt(to: recipient).ur)
        } else {
            throw EnvelopeToolError.missingArgument("key or recipient")
        }
    }
}
