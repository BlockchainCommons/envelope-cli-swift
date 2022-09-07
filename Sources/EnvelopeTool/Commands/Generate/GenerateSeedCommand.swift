import ArgumentParser
import BCFoundation

struct GenerateSeedCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "seed", abstract: "Generate a seed.")

    mutating func run() throws {
        resetOutput()
        printOut(Seed().ur)
    }
}
