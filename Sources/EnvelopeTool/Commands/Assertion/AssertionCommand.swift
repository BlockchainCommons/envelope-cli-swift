import ArgumentParser
import BCFoundation

struct AssertionCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "assertion",
        abstract: "Work with the envelope's assertions.",
        subcommands: [
            AssertionAddCommand.self,
            AssertionCreateCommand.self,
            AssertionRemoveCommand.self,
            AssertionCountCommand.self,
            AssertionAtCommand.self,
            AssertionAllCommand.self,
            AssertionFindCommand.self,
        ],
        defaultSubcommand: AssertionAddCommand.self
    )
}
