import ArgumentParser
import BCFoundation

struct GeneratePrivateKeysCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "prvkeys",
        abstract: "Generate a private key base.",
        discussion: "Generated randomly, or deterministically if a seed is provided."
    )

    @Argument
    var seed: Seed?
    
    mutating func run() throws {
        resetOutput()
        printOut(PrivateKeyBase(seed).ur)
    }
}
