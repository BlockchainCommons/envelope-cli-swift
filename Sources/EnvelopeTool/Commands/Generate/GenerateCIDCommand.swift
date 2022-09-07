import ArgumentParser
import BCFoundation

struct GenerateCIDCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "cid", abstract: "Generate a Common Identifer (CID).")

    mutating func run() throws {
        resetOutput()
        printOut(CID().ur)
    }
}
