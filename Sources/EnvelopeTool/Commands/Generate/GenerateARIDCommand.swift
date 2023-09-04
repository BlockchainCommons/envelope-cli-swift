import ArgumentParser
import BCFoundation
import WolfBase

struct GenerateARIDCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "arid", abstract: "Generate an Apparently Random Identifer (ARID).")

    @Option(help: "Raw hex data for the ARID. If included, must be 32 apparently random bytes.")
    var hex: HexData?
    
    mutating func run() throws {
        resetOutput()
        let arid: ARID
        if let hex {
            if let a = ARID(hex.data) {
                arid = a
            } else {
                throw EnvelopeToolError.invalidType(expectedType: "32 bytes of hex")
            }
        } else {
            arid = ARID()
        }
        printOut(arid.ur)
    }
}
