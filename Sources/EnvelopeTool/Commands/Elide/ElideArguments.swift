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
    }
    
    mutating func run(revealing: Bool) throws {
        resetOutput()
        try fill()

        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }

        let targetSet = Set(target)
        let result = try revealing ? envelope.elideRevealing(targetSet) : envelope.elideRemoving(targetSet)
        printOut(result.ur)
    }
}
