import ArgumentParser
import BCFoundation

struct SignCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "sign",
        abstract: "Sign the envelope with the provided private key base."
    )

    @Argument var envelope: Envelope?
    @Option var prvkeys: [PrivateKeyBase] = []
    @Option var note: String?
    
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
        setupCommand()
        try fill()
        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        guard !prvkeys.isEmpty else {
            throw EnvelopeToolError.missingArgument("prvkeys")
        }
        if let note {
            guard prvkeys.count == 1 else {
                throw EnvelopeToolError.invalidParameters("Can only add a note on a single signature.")
            }
            printOut(envelope.sign(with: prvkeys.first!, note: note).ur)
        } else {
            printOut(envelope.sign(with: prvkeys).ur)
        }
    }
}
