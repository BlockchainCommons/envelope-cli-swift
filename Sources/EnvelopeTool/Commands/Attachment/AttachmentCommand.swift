import ArgumentParser
import BCFoundation
import Foundation

struct AttachmentCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "attachment",
        abstract: "Work with the envelope's attachments.",
        subcommands: [
            AttachmentAddCommand.self,
            AttachmentAllCommand.self,
            AttachmentAtCommand.self,
            AttachmentConformsToCommand.self,
            AttachmentCountCommand.self,
            AttachmentCreateCommand.self,
            AttachmentFindCommand.self,
            AttachmentPayloadCommand.self,
            AttachmentVendorCommand.self,
        ],
        defaultSubcommand: AttachmentAddCommand.self
    )
}
