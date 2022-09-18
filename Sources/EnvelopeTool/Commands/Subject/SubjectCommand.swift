import ArgumentParser
import BCFoundation

struct SubjectCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "subject",
        abstract: "Create an envelope with the given subject.",
        subcommands: [
            SubjectSingleCommand.self,
            SubjectAssertionCommand.self,
        ],
        defaultSubcommand: SubjectSingleCommand.self
    )
}
