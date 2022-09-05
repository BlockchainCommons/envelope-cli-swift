import ArgumentParser
import BCFoundation

struct AssertionFindObjectCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "object",
        abstract: "Find all assertions having the given object."
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

        let object = try arguments.envelope
        
        let result = envelope.assertions.filter { $0.object?.subject == object }
        
        for assertion in result {
            printOut(assertion.ur)
        }
    }
}
