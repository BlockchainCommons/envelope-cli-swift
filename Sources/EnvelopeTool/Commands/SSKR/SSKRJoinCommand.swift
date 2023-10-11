import ArgumentParser
import BCFoundation

struct SSKRJoinCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "join",
        abstract: "Join a set of SSKR shares back into the original envelope."
    )

    @Argument
    var envelopes: [Envelope] = []
    
    mutating func fill() throws {
        if envelopes.isEmpty {
            var result: [Envelope] = []
            while let line = readIn() {
                if line.isEmpty {
                    continue
                }
                let envelope = try Envelope(urString: line)
                result.append(envelope)
            }
            envelopes = result
        }
    }
    
    mutating func run() throws {
        resetOutput()
        try fill()
        guard !envelopes.isEmpty else {
            throw EnvelopeToolError.missingArgument("envelopes")
        }
        printOut(try Envelope(shares: envelopes).unwrap().ur)
    }
}
