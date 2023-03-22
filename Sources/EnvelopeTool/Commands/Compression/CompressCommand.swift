import ArgumentParser
import BCFoundation

struct CompressCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "compress", abstract: "Compress the envelope or its subject.")
    
    @Argument var envelope: Envelope?
    @Flag(help: "Compress only the envelope's subject.") var subject: Bool = false
    
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
            e = try envelope.compressSubject()
        } else {
            e = try envelope.compress()
        }
        printOut(e.ur)
    }
}
