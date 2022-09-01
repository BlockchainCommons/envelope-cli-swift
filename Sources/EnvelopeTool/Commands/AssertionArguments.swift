import ArgumentParser
import BCFoundation

struct AssertionArguments: ParsableArguments {
    @Flag(help: "The data types of the assertion's predicate and object.")
    var types: [DataType] = [.string, .string]

    @Argument(help: "The value for the assertion's predicate.")
    var predicateValue: String?

    @Argument(help: "The value for the assertion's object.")
    var objectValue: String?
    
    @Option(help: "The integer tag for the predicate provided as an enclosed UR.")
    var predicateTag: UInt64?
    
    @Option(help: "The integer tag for the object provided as an enclosed UR.")
    var objectTag: UInt64?
    
    mutating func fill() throws {
        if predicateValue == nil {
            predicateValue = try readIn()
        }
        
        if objectValue == nil {
            objectValue = try readIn()
        }
    }

    var assertion: Envelope {
        get throws {
            guard let predicateValue else {
                throw EnvelopeToolError.missingArgument("predicate")
            }

            guard let objectValue else {
                throw EnvelopeToolError.missingArgument("object")
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

            let predicate = try SubjectArguments(type: types[0], value: predicateValue, tag: predicateTag).envelope
            let object = try SubjectArguments(type: types[1], value: objectValue, tag: objectTag).envelope

            return Envelope(predicate: predicate, object: object)
        }
    }
}
