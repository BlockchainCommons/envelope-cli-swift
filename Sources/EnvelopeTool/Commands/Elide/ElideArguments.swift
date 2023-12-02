import ArgumentParser
import BCFoundation

struct ElideArguments: ParsableArguments {
    enum Action: EnumerableFlag {
        case encrypt
        case compress
    }
    
    @Argument(help: "The input envelope.")
    var envelope: Envelope?

    @Flag(help: "The action to take. If omitted, the action is elide.")
    var action: Action?

    @Option(help: "The encryption key to use when action is --encrypt. Ignored otherwise.")
    var key: SymmetricKey?
    
    @Argument(help: "The target set of digests.")
    var target: [Digest] = []
    
    mutating func fill() throws {
        if envelope == nil {
            envelope = try readIn(Envelope.self)
        }
    }
    
    mutating func run(revealing: Bool) throws {
        setupCommand()
        try fill()

        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        
        let obscureAction: ObscureAction
        switch action {
        case .encrypt:
            guard let key else {
                throw EnvelopeToolError.missingArgument("key")
            }
            obscureAction = .encrypt(key)
        case .compress:
            obscureAction = .compress
        case .none:
            obscureAction = .elide
        }

        let targetSet = Set(target)
        let result = revealing ? envelope.elideRevealing(targetSet, action: obscureAction) : envelope.elideRemoving(targetSet, action: obscureAction)
        printOut(result.ur)
    }
}
