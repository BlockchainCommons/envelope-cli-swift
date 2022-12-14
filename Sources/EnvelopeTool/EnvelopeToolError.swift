import Foundation

enum EnvelopeToolError: Error {
    case invalidType(expectedType: String)
    case notCBOR
    case urMissingTag
    case urTagRequired(String)
    case urTypeRequired
    case urTagMismatch
    case urTypeMismatch
    case notAKnownValue(String)
    case useAssertionCommand
    case notAssertion
    case missingArgument(String)
    case tooManyArguments
    case tooManyTypes
    case unexpectedEOF
    case indexOutOfRange(Range<Int>, Int)
    case sizeOutOfRange(ClosedRange<Int>, Int)
    case missingSearchCriteria
    case invalidGroupThreshold(Int)
    case invalidGroupSpecifier(String)
    case invalidParameters(String)
    case invalidURL(String)
    case invalidProof
}
