import ArgumentParser
import BCFoundation

struct UncompressCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "uncompress", abstract: "Uncompress the envelope or its subject.")
    
    @Argument var envelope: Envelope?
    @Flag(help: "Uncompress only the envelope's subject.") var subject: Bool = false
    
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
        let e: Envelope
        if subject {
            e = try envelope.uncompressSubject()
        } else {
            e = try envelope.uncompress()
        }
        printOut(e.ur)
    }
}
