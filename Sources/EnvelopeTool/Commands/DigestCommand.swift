import ArgumentParser
import BCFoundation

struct DigestCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "digest", abstract: "Print the envelope's digest.")
    
    @Argument(help: "The envelope to retrieve the digest from.")
    var envelope: Envelope?
    
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
        printOut(envelope.digest.ur)
    }
}
