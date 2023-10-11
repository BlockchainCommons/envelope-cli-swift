import ArgumentParser
import BCFoundation

struct GeneratePublicKeysCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "pubkeys",
        abstract: "Generate a public key base from a private key base."
    )

    @Argument
    var prvkeys: PrivateKeyBase?
    
    mutating func fill() throws {
        if prvkeys == nil {
            prvkeys = try readIn(PrivateKeyBase.self)
        }
    }

    mutating func run() throws {
        resetOutput()
        try fill()
        guard let prvkeys else {
            throw EnvelopeToolError.missingArgument("prvkeys")
        }
        printOut(prvkeys.publicKeys.ur)
    }
}
