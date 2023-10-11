import ArgumentParser
import BCFoundation

struct AttachmentAddCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "add",
        abstract: "Add an attachment to the given envelope.",
        subcommands: [
            AttachmentAddComponentsCommand.self,
            AttachmentAddEnvelopeCommand.self,
        ],
        defaultSubcommand: AttachmentAddComponentsCommand.self
    )
}
