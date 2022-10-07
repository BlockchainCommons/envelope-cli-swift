import ArgumentParser
import BCFoundation

struct ProofCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "proof",
        abstract: "Work with existence proofs.",
        subcommands: [
            ProofCreateCommand.self,
            ProofConfirmCommand.self
        ],
        defaultSubcommand: ProofCreateCommand.self
    )
}
