import ArgumentParser
import BCFoundation

@main
struct Main: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "envelope",
        abstract: "A tool for manipulating the Envelope data type.",
        shouldDisplay: false,
        subcommands: [
            FormatCommand.self,
            SubjectCommand.self,
            ExtractCommand.self,
            AssertionCommand.self,
            DigestCommand.self,
            ElideCommand.self,
            GenerateCommand.self,
            EncryptCommand.self,
            DecryptCommand.self,
            SignCommand.self,
            VerifyCommand.self,
            SSKRCommand.self,
        ],
        defaultSubcommand: FormatCommand.self
    )
}
