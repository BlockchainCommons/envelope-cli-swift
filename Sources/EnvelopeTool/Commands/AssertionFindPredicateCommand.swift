import ArgumentParser
import BCFoundation

struct AssertionFindPredicateCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "predicate",
        abstract: "Find all assertions having the given criteria."
    )

    @OptionGroup
    var arguments: SubjectArguments

    @Argument
    var envelope: Envelope?
    
    mutating func fill() throws {
        try arguments.fill()
        if envelope == nil {
            envelope = try readIn(Envelope.self)
        }
    }

    mutating func run() throws {
        resetOutput()
        try fill()
        guard let envelope else {
            throw EnvelopeToolError.missingArgument("envelope")
        }

        let predicate = try arguments.envelope
        
        let result = envelope.assertions.filter { $0.predicate?.subject == predicate }
        
        for assertion in result {
            printOut(assertion.ur)
        }
    }
}
