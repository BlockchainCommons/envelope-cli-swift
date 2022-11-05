import ArgumentParser
import BCFoundation

@main
struct Main: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "envelope",
        abstract: "A tool for manipulating the Envelope data type.",
        version: "0.1.0",
        shouldDisplay: false,
        subcommands: [
            AssertionCommand.self,
            DigestCommand.self,
            DecryptCommand.self,
            ElideCommand.self,
            EncryptCommand.self,
            ExtractCommand.self,
            FormatCommand.self,
            GenerateCommand.self,
            ProofCommand.self,
            SaltCommand.self,
            SignCommand.self,
            SSKRCommand.self,
            SubjectCommand.self,
            VerifyCommand.self,
        ],
        defaultSubcommand: FormatCommand.self
    )
}
