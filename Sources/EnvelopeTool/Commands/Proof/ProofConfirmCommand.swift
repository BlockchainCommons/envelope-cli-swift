import ArgumentParser
import BCFoundation

struct ProofConfirmCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "confirm",
        abstract: "Confirm that an elided envelope contains a target digest using a proof.",
        usage: "On success, print the original envelope so it can be piped to the next operation. On failure, exit with an error condition."
    )
        
    @Argument(help: "The elided envelope.")
    var envelope: Envelope?
    
    @Argument(help: "The proof.")
    var proof: Envelope

    @Argument(help: "The target set of digests.")
    var target: [Digest] = []
    
    @Flag(help: "Don't output the envelope's UR on success.")
    var silent: Bool = false

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
        guard envelope.confirm(contains: Set(target), proof: proof) else {
            throw EnvelopeToolError.invalidProof
        }
        if !silent {
            printOut(envelope.ur)
        }
    }
}
