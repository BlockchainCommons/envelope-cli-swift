import ArgumentParser
import BCFoundation

struct ElideArguments: ParsableArguments {
    @Argument(help: "The input envelope.")
    var envelope: Envelope?
    
    @Argument(help: "The target set of digests.")
    var target: [Digest] = []
    
    mutating func fill() throws {
        if envelope == nil {
            envelope = try readIn(Envelope.self)
        }
        if target.isEmpty {
            while let digest = try readIn(Digest.self) {
                target.append(digest)
            }
        }
    }
    
    mutating func run(revealing: Bool) throws {
        resetOutput()
        try fill()

        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }

        let targetSet = Set(target)
        let result = revealing ? envelope.elideRevealing(targetSet) : envelope.elideRemoving(targetSet)
        printOut(result.ur)
    }
}
