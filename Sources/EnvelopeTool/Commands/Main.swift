import ArgumentParser
import BCFoundation

@main
struct Main: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "envelope",
        abstract: "A tool for manipulating the Gordian Envelope data type.",
        version: "0.13.1",
        shouldDisplay: false,
        subcommands: [
            AssertionCommand.self,
            CompressCommand.self,
            DigestCommand.self,
            DecryptCommand.self,
            ElideCommand.self,
            EncryptCommand.self,
            ExtractCommand.self,
            FormatCommand.self,
            GenerateCommand.self,
            ProofCommand.self,
            DiffCommand.self,
            SaltCommand.self,
            SignCommand.self,
            SSKRCommand.self,
            SubjectCommand.self,
            UncompressCommand.self,
            VerifyCommand.self,
        ],
        defaultSubcommand: FormatCommand.self
    )
}
