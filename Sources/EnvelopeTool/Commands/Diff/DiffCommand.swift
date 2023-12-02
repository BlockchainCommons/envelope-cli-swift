import ArgumentParser
import BCFoundation

struct DiffCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "diff",
        abstract: "Work with envelope diffs.",
        subcommands: [
            DiffCreateCommand.self,
            DiffApplyCommand.self
        ],
        defaultSubcommand: DiffCreateCommand.self
    )
}

struct DiffCreateCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "create", abstract: "Create a diff between source and target envelopes.")
    
    @Argument(help: "The source envelope.")
    var source: Envelope?
    
    @Argument(help: "The target envelope.")
    var target: Envelope?
    
    mutating func fill() throws {
        if source == nil {
            source = try readIn(Envelope.self)
        }
        if target == nil {
            target = try readIn(Envelope.self)
        }
    }
    
    mutating func run() throws {
        setupCommand()
        try fill()
        guard let source else {
            throw EnvelopeToolError.missingArgument("source")
        }
        guard let target else {
            throw EnvelopeToolError.missingArgument("target")
        }
        let diff = source.diff(target: target)
        printOut(diff.ur)
    }
}

struct DiffApplyCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "apply", abstract: "Apply a diff to a source envelope to recreate the target envelope.")
        
    @Argument(help: "The source envelope.")
    var source: Envelope?
    
    @Argument(help: "The diff to apply.")
    var diff: Envelope

    mutating func fill() throws {
        if source == nil {
            source = try readIn(Envelope.self)
        }
    }
    
    mutating func run() throws {
        setupCommand()
        try fill()
        guard let source else {
            throw EnvelopeToolError.missingArgument("source")
        }
        let target = try source.transform(edits: diff)
        printOut(target.ur)
    }
}
