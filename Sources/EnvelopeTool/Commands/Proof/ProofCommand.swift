import ArgumentParser
import BCFoundation

struct ProofCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "proof",
        abstract: "Work with inclusion proofs.",
        subcommands: [
            ProofCreateCommand.self,
            ProofConfirmCommand.self
        ],
        defaultSubcommand: ProofCreateCommand.self
    )
}
