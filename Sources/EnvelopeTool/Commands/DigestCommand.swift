import ArgumentParser
import BCFoundation

struct DigestCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "digest", abstract: "Print the envelope's digest.")
    
    @Argument(help: "The envelope to retrieve the digest from.")
    var envelope: Envelope?
    
    enum Depth: String, EnumerableFlag {
        case top, shallow, deep
    }
    
    @Flag(exclusivity: .exclusive, help: "Whether to return just the envelope's top digest (top), just the digests needed to reveal the subject (shallow), or the digests needed to reveal the entire contents of the envelope (deep).")
    var depth: Depth = .top
    
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
        switch depth {
        case .top:
            printOut(envelope.digest.ur)
        case .shallow:
            printOut(envelope.shallowDigests.map { $0.ur.string }.joined(separator: " "))
        case .deep:
            printOut(envelope.deepDigests.map { $0.ur.string }.joined(separator: " "))
        }
    }
}
