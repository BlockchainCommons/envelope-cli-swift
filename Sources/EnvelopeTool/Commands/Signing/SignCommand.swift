import ArgumentParser
import BCFoundation

struct SignCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "sign", abstract: "Sign the envelope with the provided private key base.")

    @Argument var envelope: Envelope?
    @Option var prvkeys: [PrivateKeyBase] = []
    
    mutating func fill() throws {
        if envelope == nil {
            envelope = try readIn(Envelope.self)
        }
        if prvkeys.isEmpty {
            var result: [PrivateKeyBase] = []
            while let k = try readIn(PrivateKeyBase.self) {
                result.append(k)
            }
            prvkeys = result
        }
    }

    mutating func run() throws {
        resetOutput()
        try fill()
        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        guard !prvkeys.isEmpty else {
            throw EnvelopeToolError.missingArgument("prvkeys")
        }
        printOut(envelope.sign(with: prvkeys).ur)
    }
}
