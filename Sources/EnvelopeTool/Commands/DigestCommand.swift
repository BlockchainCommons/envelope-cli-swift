import ArgumentParser
import BCFoundation

struct DigestCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "digest",
        abstract: "Print the envelope's digest."
    )
    
    @Argument(help: "The envelope to retrieve the digest from.")
    var envelope: Envelope?
    
    enum Depth: String, EnumerableFlag {
        case top, shallow, deep
    }
    
    @Flag(exclusivity: .exclusive, help: "Whether to return just the envelope's top digest (top), just the digests needed to reveal the subject (shallow), or the digests needed to reveal the entire contents of the envelope (deep).")
    var depth: Depth = .top
    
    @Flag(name: [.customShort("x"), .customLong("hex")])
    var isHex: Bool = false
    
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
        let digests: Set<Digest>
        switch depth {
        case .top:
            digests = [envelope.digest]
        case .shallow:
            digests = envelope.shallowDigests
        case .deep:
            digests = envelope.deepDigests
        }
        printOut(digests.sorted().map { isHex ? $0.hex : $0.ur.string }.joined(separator: " "))
    }
}
