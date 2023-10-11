import ArgumentParser
import BCFoundation

struct AssertionAtCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "at",
        abstract: "Retrieve the assertion at the given index."
    )
    
    @Argument var index: Int
    @Argument var envelope: Envelope?
    
    mutating func fill() throws {
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
        let assertions = envelope.assertions
        let range = 0..<assertions.count
        guard range.contains(index) else {
            throw EnvelopeToolError.indexOutOfRange(range, index)
        }
        printOut(assertions[index].ur)
    }
}
