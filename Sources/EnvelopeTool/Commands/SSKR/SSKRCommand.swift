import ArgumentParser
import BCFoundation

struct SSKRCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "sskr",
        abstract: "Sharded Secret Key Reconstruction (SSKR).",
        subcommands: [
            SSKRSplitCommand.self,
            SSKRJoinCommand.self,
        ]
    )
}
