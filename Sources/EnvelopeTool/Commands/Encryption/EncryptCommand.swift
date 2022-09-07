import ArgumentParser
import BCFoundation

struct EncryptCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "encrypt", abstract: "Encrypt the envelope's subject using the provided key.")

    @Argument var envelope: Envelope?
    @Argument var key: SymmetricKey?
    
    mutating func fill() throws {
        if envelope == nil {
            envelope = try readIn(Envelope.self)
        }
        if key == nil {
            key = try readIn(SymmetricKey.self)
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
        printOut(try envelope.encryptSubject(with: key).ur)
    }
}
