import ArgumentParser
import BCFoundation

@main
struct Main: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A tool for manipulating the Envelope data type.",
        subcommands: [Format.self, Subject.self, Extract.self],
        defaultSubcommand: Format.self
    )
}
