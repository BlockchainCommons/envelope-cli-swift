import ArgumentParser
import BCFoundation

struct VerifyCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "verify",
        abstract: "Verify a signature on the envelope using the provided public key base.",
        usage: "On success, print the original envelope so it can be piped to the next operation. On failure, exit with an error condition."
    )

    @Option(help: "The minimum number of valid signatures.")
    var threshold: Int?
    
    @Argument var envelope: Envelope?
    @Option var pubkeys: [PublicKeyBase] = []
    @Flag(help: "Don't output the envelope's UR on success.") var silent: Bool = false
    
    mutating func fill() throws {
        if envelope == nil {
            envelope = try readIn(Envelope.self)
        }
        if pubkeys.isEmpty {
            var result: [PublicKeyBase] = []
            while let k = try readIn(PublicKeyBase.self) {
                result.append(k)
            }
            pubkeys = result
        }
    }

    mutating func run() throws {
        setupCommand()
        try fill()
        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        guard !pubkeys.isEmpty else {
            throw EnvelopeToolError.missingArgument("pubkeys")
        }
        try envelope.verifySignatures(from: pubkeys, threshold: threshold)
        if !silent {
            printOut(envelope.ur)
        }
    }
}
