import Foundation

enum EnvelopeToolError: Error {
    case invalidType(expectedType: String)
    case notCBOR
    case urTagRequired
    case urTypeRequired
    case urTagMismatch
    case urTypeMismatch
    case unknownPredicate(String)
}
