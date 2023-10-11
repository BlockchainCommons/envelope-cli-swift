import ArgumentParser
import BCFoundation

struct AssertionAddCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "add",
        abstract: "Add an assertion to the given envelope.",
        subcommands: [
            AssertionAddPredObjCommand.self,
            AssertionAddEnvelopeCommand.self,
        ],
        defaultSubcommand: AssertionAddPredObjCommand.self
    )
}
