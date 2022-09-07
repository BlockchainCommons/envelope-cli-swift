import ArgumentParser
import BCFoundation

fileprivate var resultEnvelope: Envelope? = nil
fileprivate var resultPrvkeys: PrivateKeyBase? = nil

struct SignCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "sign", abstract: "Sign the envelope with the provided private key base.")

    @Argument
    var envelope: String?
    
    @Argument
    var prvkeys: String?

    mutating func parse(_ arg: String?) throws {
        guard let arg else { return }
        let ur = try UR(urString: arg)
        switch ur.type {
        case "envelope":
            resultEnvelope = try Envelope(ur: ur)
        case "crypto-prvkeys":
            resultPrvkeys = try PrivateKeyBase(ur: ur)
        default:
            throw EnvelopeToolError.urTypeMismatch
        }
    }
    
    mutating func fill() throws {
        try parse(envelope)
        try parse(prvkeys)
        if resultEnvelope == nil {
            resultEnvelope = try readIn(Envelope.self)
        }
        if resultPrvkeys == nil {
            resultPrvkeys = try readIn(PrivateKeyBase.self)
        }
    }

    mutating func run() throws {
        resetOutput()
        try fill()
        guard let envelope = resultEnvelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }
        guard let prvkeys = resultPrvkeys else {
            throw EnvelopeToolError.missingArgument("prvkeys")
        }
        printOut(envelope.sign(with: prvkeys).ur)
    }
}
