import ArgumentParser
import BCFoundation

struct SubjectSingleCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "single", abstract: "Create an envelope with the given subject.")
    @Flag(help: "The data type of the subject.")
    var type: DataType = .string
    
    @Argument(help: "The value for the Envelope's subject")
    var value: String?
    
    @Option(help: "The integer tag for an enclosed UR.")
    var tag: UInt64?
    
    mutating func run() throws {
        resetOutput()
        if value == nil {
            value = readIn()
        }
        guard let value else {
            throw EnvelopeToolError.missingArgument("value")
        }
        let envelope = try envelopeForValue(value, type: type, tag: tag)
        printOut(envelope.ur)
    }
}
