import ArgumentParser
import BCFoundation

struct AssertionCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "assertion",
        abstract: "Work with the envelope's assertions.",
        subcommands: [
            AssertionAddCommand.self,
            AssertionCountCommand.self,
            AssertionAtCommand.self,
            AssertionAllCommand.self,
        ],
        defaultSubcommand: AssertionAddCommand.self
    )
}
