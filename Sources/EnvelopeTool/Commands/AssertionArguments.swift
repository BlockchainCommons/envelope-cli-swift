import ArgumentParser
import BCFoundation

struct AssertionArguments: ParsableArguments {
    @Flag(help: "The data types of the assertion's predicate and object.")
    var types: [DataType] = [.string, .string]
    
    @Argument(help: "The values for the assertion's predicate and object.")
    var values: [String]
    
    @Option(help: "The integer tag for the predicate provided as an enclosed UR.")
    var predicateTag: UInt64?
    
    @Option(help: "The integer tag for the object provided as an enclosed UR.")
    var objectTag: UInt64?
    
    var assertion: Envelope {
        get throws {
            switch values.count {
            case 0:
                throw EnvelopeToolError.missingArgument("predicate and object")
            case 1:
                throw EnvelopeToolError.missingArgument("object")
            case 2:
                break
            default:
                throw EnvelopeToolError.tooManyArguments
            }
            
            var types = types
            
            switch types.count {
            case 0:
                types = [.string, .string]
            case 1:
                types.append(.string)
            case 2:
                break
            default:
                throw EnvelopeToolError.tooManyTypes
            }
            
            let predicate = try SubjectArguments(type: types[0], value: values[0], tag: predicateTag).envelope
            let object = try SubjectArguments(type: types[1], value: values[1], tag: objectTag).envelope
            return Envelope(predicate: predicate, object: object)
        }
    }
}
