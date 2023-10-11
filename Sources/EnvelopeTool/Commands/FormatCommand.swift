import ArgumentParser
import BCFoundation

struct FormatCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "format",
        abstract: "Print the envelope in Envelope Notation."
    )
    
    @Argument var envelope: Envelope?
    
    @Flag(help: "For --tree and --mermaid, hides the NODE case, which provides a more semantically readable tree output.") var hideNodes: Bool = false
    
    enum Output: EnumerableFlag {
        case envelope, cbor, diag, tree, mermaid
    }
    
    enum Layout: String, ExpressibleByArgument {
        case lr
        case tb
        
        var mermaidLayout: Envelope.MermaidOptions.LayoutDirection {
            switch self {
            case .lr:
                return .leftToRight
            case .tb:
                return .topToBottom
            }
        }
    }
    
    enum Theme: String, ExpressibleByArgument {
        case color
        case monochrome
        
        var mermaidTheme: Envelope.MermaidOptions.Theme {
            switch self {
            case .color:
                return .color
            case .monochrome:
                return .monochrome
            }
        }
    }
    
    @Flag(exclusivity: .exclusive, help: "Whether to output the envelope in envelope notation (envelope), or as tagged CBOR hex (cbor), as CBOR diagnostic notation (diag), or as Mermaid (mermaid).")
    var output: Output = .envelope
    
    @Option(help: "For Mermaid output, whether the layout should be left-to-right (lr) or top-to-bottom (tb).")
    var layout: Layout = .lr
    
    @Option(help: "For Mermaid output, whether the layout should in color or monochrome.")
    var theme: Theme = .color

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
        addKnownFunctionExtensions()
        let context = FormatContext(tags: globalTags, knownValues: globalKnownValues, functions: globalFunctions, parameters: globalParameters)
        switch output {
        case .envelope:
            printOut(envelope.format(context: context))
        case .cbor:
            printOut(envelope.taggedCBOR.hex)
        case .diag:
            printOut(envelope.diagnostic(annotate: true, context: context))
        case .tree:
            printOut(envelope.treeFormat(hideNodes: hideNodes))
        case .mermaid:
            printOut(envelope.mermaidFormat(hideNodes: hideNodes, layoutDirection: layout.mermaidLayout, theme: theme.mermaidTheme))
        }
    }
}
