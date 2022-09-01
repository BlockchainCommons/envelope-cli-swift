import ArgumentParser
import BCFoundation

@main
struct Main: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A tool for manipulating the Envelope data type.",
        subcommands: [
            FormatCommand.self,
            SubjectCommand.self,
            ExtractCommand.self,
            AddAssertionCommand.self
        ],
        defaultSubcommand: FormatCommand.self
    )
}
