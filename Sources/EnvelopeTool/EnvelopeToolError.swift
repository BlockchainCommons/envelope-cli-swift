import Foundation

enum EnvelopeToolError: Error {
    case invalidType(expectedType: String)
    case notCBOR
}
