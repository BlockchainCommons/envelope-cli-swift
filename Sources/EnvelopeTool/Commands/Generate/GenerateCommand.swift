import ArgumentParser
import BCFoundation

struct GenerateCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "generate",
        abstract: "Utilities to generate and convert various objects.",
        subcommands: [
            GenerateARIDCommand.self,
            GenerateDigestCommand.self,
            GenerateKeyCommand.self,
            GenerateNonceCommand.self,
            GeneratePrivateKeysCommand.self,
            GeneratePublicKeysCommand.self,
            GenerateSeedCommand.self,
        ]
    )
}
