import ArgumentParser
import BCFoundation

struct FormatCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "format", abstract: "Print the envelope in Envelope Notation.")
    
    @Argument var envelope: Envelope?
    
    enum Output: EnumerableFlag {
        case envelope, cbor, diag, mermaid
    }
    
    enum Layout: EnumerableFlag {
        case lr
        case tb
        
        var mermaidLayout: EnvelopeMermaidLayoutDirection {
            switch self {
            case .lr:
                return .leftToRight
            case .tb:
                return .topToBottom
            }
        }
    }
    
    @Flag(exclusivity: .exclusive, help: "Whether to output the envelope in envelope notation (envelope), or as tagged CBOR hex (cbor), as CBOR diagnostic notation (diag), or as Mermaid (mermaid).")
    var output: Output = .envelope
    
    @Flag(exclusivity: .exclusive, help: "For Mermaid output, whether the layout should be left-to-right (lr) or top-to-bottom (tb).")
    var layout: Layout = .lr
    
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
        case .mermaid:
            printOut(envelope.mermaidFormat(layoutDirection: layout.mermaidLayout))
        }
    }
}
