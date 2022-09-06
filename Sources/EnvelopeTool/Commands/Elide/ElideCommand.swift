import ArgumentParser
import BCFoundation

struct ElideCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "elide",
        subcommands: [
            ElideRevealingCommand.self,
            ElideRemovingCommand.self
        ],
        defaultSubcommand: ElideRevealingCommand.self
    )
}
