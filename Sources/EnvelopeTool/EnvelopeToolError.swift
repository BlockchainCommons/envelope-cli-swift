import Foundation

enum EnvelopeToolError: Error {
    case invalidType(expectedType: String)
    case notCBOR
    case urTagRequired
    case urTypeRequired
    case urTagMismatch
    case urTypeMismatch
    case unknownPredicate(String)
    case useAssertionCommand
    case notAssertion
    case missingArgument(String)
    case tooManyArguments
    case tooManyTypes
    case unexpectedEOF
    case indexOutOfRange(Range<Int>, Int)
}
