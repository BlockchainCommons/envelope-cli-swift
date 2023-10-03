import ArgumentParser
import BCFoundation
import WolfBase

struct GenerateNonceCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "nonce", abstract: "Generate a Number Used Once (Nonce).")

    @Option(help: "Raw hex data for the nonce.")
    var hex: HexData?
    
    mutating func run() throws {
        resetOutput()
        let nonce: Nonce
        if let hex {
            if let c = Nonce(hex.data) {
                nonce = c
            } else {
                throw EnvelopeToolError.invalidType(expectedType: "32 bytes of hex")
            }
        } else {
            nonce = Nonce()
        }
        printOut(nonce.ur)
    }
}
