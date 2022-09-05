import ArgumentParser
import BCFoundation

struct AssertionFindCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "find",
        abstract: "Find all assertions matching the given criteria.",
        subcommands: [
            AssertionFindPredicateCommand.self,
            AssertionFindObjectCommand.self,
        ],
        defaultSubcommand: AssertionFindPredicateCommand.self
    )
}
