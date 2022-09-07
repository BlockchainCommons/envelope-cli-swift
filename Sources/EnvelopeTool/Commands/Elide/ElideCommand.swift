import ArgumentParser
import BCFoundation

struct ElideCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "elide",
        abstract: "Elide a subset of elements.",
        subcommands: [
            ElideRevealingCommand.self,
            ElideRemovingCommand.self
        ],
        defaultSubcommand: ElideRevealingCommand.self
    )
}
