import ArgumentParser
import BCFoundation

struct GenerateCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "generate",
        abstract: "Utilities to generate various objects.",
        subcommands: [
            GenerateKeyCommand.self,
            GenerateCIDCommand.self,
            GenerateSeedCommand.self,
        ]
    )
}
