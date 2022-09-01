import ArgumentParser
import BCFoundation

struct SubjectAssertionCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "assertion", abstract: "Create an envelope with the given assertion (predicate and object).")
    
    @Flag(help: "The data types of the assertion's predicate and object.")
    var types: [DataType] = [.string, .string]
    
    @Argument(help: "The values for the assertion's predicate and object.")
    var values: [String]
    
    @Option(help: "The integer tag for the predicate provided as an enclosed UR.")
    var predicateTag: UInt64?
    
    @Option(help: "The integer tag for the object provided as an enclosed UR.")
    var objectTag: UInt64?
    
    mutating func run() throws {
        resetOutput()
        let envelope = try assertionForValues(values, types: types, predicateTag: predicateTag, objectTag: objectTag)
        printOut(envelope.ur)
    }
}
