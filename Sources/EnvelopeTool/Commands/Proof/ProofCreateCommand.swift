import ArgumentParser
import BCFoundation

struct ProofCreateCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "create",
        abstract: "Create a proof that an envelope contains a target digest."
    )
    
    @Argument(help: "The input envelope.")
    var envelope: Envelope?
    
    @Argument(help: "The target set of digests.")
    var target: [Digest] = []
    
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
        guard let proof = envelope.proof(contains: Set(target)) else {
            throw EnvelopeToolError.invalidProof
        }
        printOut(proof.ur)
    }
}
