import ArgumentParser
import BCFoundation

struct FormatCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "format", abstract: "Print the envelope in Envelope Notation.")

    @Argument var envelope: Envelope?
    
    enum Output: EnumerableFlag {
        case envelope, cbor, diag
    }
    
    @Flag(exclusivity: .exclusive, help: "Whether to output the envelope in envelope notation (envelope), or as tagged CBOR hex (cbor), or as CBOR diagnostic notation (diag).")
    var output: Output = .envelope
    
    mutating func fill() throws {
        if envelope == nil {
            envelope = try readIn(Envelope.self)
        }
    }

    mutating func run() throws {
        addKnownTags()
        resetOutput()
        try fill()
        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        switch output {
        case .envelope:
            printOut(envelope.format)
        case .cbor:
            printOut(envelope.taggedCBOR.hex)
        case .diag:
            printOut(envelope.diagAnnotated)
        }
    }
}
