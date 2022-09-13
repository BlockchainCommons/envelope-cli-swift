import ArgumentParser
import BCFoundation
import WolfBase

struct GenerateCIDCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "cid", abstract: "Generate a Common Identifer (CID).")

    @Option(help: "Raw hex data for the CID. If included, must be 32 apparently random bytes.")
    var hex: HexData?
    
    mutating func run() throws {
        resetOutput()
        let cid: CID
        if let hex {
            if let c = CID(hex.data) {
                cid = c
            } else {
                throw EnvelopeToolError.invalidType(expectedType: "32 bytes of hex")
            }
        } else {
            cid = CID()
        }
        printOut(cid.ur)
    }
}
