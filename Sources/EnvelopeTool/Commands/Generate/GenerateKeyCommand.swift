import ArgumentParser
import BCFoundation

struct GenerateKeyCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "key",
        abstract: "Generate a symmetric encryption key."
    )

    mutating func run() throws {
        setupCommand()
        printOut(SymmetricKey().ur)
    }
}
