import ArgumentParser
import Foundation
import BCFoundation
import WolfBase

struct ExtractCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "extract", abstract: "Extract the subject of the input envelope.")
    
    @Flag(help: "The data type of the subject.")
    var type: DataType = .string
    
    @Argument(help: "The input envelope.")
    var envelope: Envelope?
    
    @Option(name: .customLong("type"), help: "The type for an extracted UR.")
    var urType: String?
    
    @Option(name: .customLong("tag"), help: "The expected tag for an extracted UR.")
    var urTag: UInt64?
    
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
        
        let string = switch type {
        case .assertion:
            try Self.extractAssertion(envelope)
        case .predicate:
            try Self.extractPredicate(envelope)
        case .object:
            try Self.extractObject(envelope)
        case .arid:
            try Self.extractARID(envelope)
        case .bool:
            try Self.extractBool(envelope)
        case .cbor:
            try Self.extractCBOR(envelope)
        case .data:
            try Self.extractData(envelope)
        case .date:
            try Self.extractDate(envelope)
        case .digest:
            try Self.extractDigest(envelope)
        case .envelope:
            try Self.extractEnvelope(envelope)
        case .known:
            try Self.extractKnown(envelope)
        case .number:
            try Self.extractNumber(envelope)
        case .string:
            try Self.extractString(envelope)
        case .ur:
            try Self.extractUR(envelope, urType: urType, urTag: urTag)
        case .uri:
            try Self.extractURI(envelope)
        case .uuid:
            try Self.extractUUID(envelope)
        case .wrapped:
            try Self.extractWrapped(envelope)
        }
        
        printOut(string)
    }
    
    private static func extractAssertion(_ envelope: Envelope) throws -> String {
        guard let assertion = envelope.assertion else {
            throw EnvelopeToolError.notAssertion
        }
        return [assertion.predicate, assertion.object].map { $0.ur.string }.joined(separator: "\n")
    }
    
    private static func extractPredicate(_ envelope: Envelope) throws -> String {
        guard let assertion = envelope.assertion else {
            throw EnvelopeToolError.notAssertion
        }
        return assertion.predicate.urString
    }
    
    private static func extractObject(_ envelope: Envelope) throws -> String {
        guard let assertion = envelope.assertion else {
            throw EnvelopeToolError.notAssertion
        }
        return assertion.object.urString
    }
    
    private static func extractARID(_ envelope: Envelope) throws -> String {
        try envelope.extractSubject(ARID.self).hex
    }
    
    private static func extractBool(_ envelope: Envelope) throws -> String {
        try String(envelope.extractSubject(Bool.self))
    }
    
    private static func extractCBOR(_ envelope: Envelope) throws -> String {
        if let cbor = envelope.leaf {
            cbor.hex
        } else if envelope.isWrapped {
            try envelope.unwrap().cbor.hex
        } else if let knownValue = envelope.knownValue {
            knownValue.cbor.hex
        } else {
            throw EnvelopeToolError.notCBOR
        }
    }
    
    private static func extractData(_ envelope: Envelope) throws -> String {
        try envelope.extractSubject(Data.self).hex
    }
    
    private static func extractDate(_ envelope: Envelope) throws -> String {
        let date = try envelope.extractSubject(Date.self)
        return ISO8601DateFormatter().string(from: date)
    }
    
    private static func extractDigest(_ envelope: Envelope) throws -> String {
        try envelope.extractSubject(Digest.self).urString
    }
    
    private static func extractEnvelope(_ envelope: Envelope) throws -> String {
        envelope.subject.urString
    }
    
    private static func extractKnown(_ envelope: Envelope) throws -> String {
        let knownValue = try envelope.extractSubject(KnownValue.self)
        return globalKnownValues.name(for: knownValue)
    }
    
    private static func extractNumber(_ envelope: Envelope) throws -> String {
        let number = try envelope.extractSubject(Double.self)
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        // check if the number has a non-zero fractional part
        formatter.maximumFractionDigits = number.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 1
        formatter.decimalSeparator = "."
        return formatter.string(from: number as NSNumber) ?? "?"
    }
    
    private static func extractString(_ envelope: Envelope) throws -> String {
        try envelope.extractSubject(String.self)
    }
    
    private static func extractUR(_ envelope: Envelope, urType: String?, urTag: UInt64?) throws -> String {
        if let cbor = envelope.leaf {
            guard case CBOR.tagged(let tag, let untaggedCBOR) = cbor else {
                throw EnvelopeToolError.urMissingTag
            }
            let knownTag = globalTags.tag(for: tag.value)
            guard let type = knownTag?.name ?? urType else {
                throw EnvelopeToolError.urTypeRequired
            }
            return try! UR(type: type, cbor: untaggedCBOR).string
        } else if envelope.isWrapped {
            if urType != nil || urTag != nil {
                guard urTag == Tag.envelope.value else {
                    throw EnvelopeToolError.urTagMismatch
                }
                guard urType == Tag.envelope.name else {
                    throw EnvelopeToolError.urTypeMismatch
                }
            }
            return try envelope.unwrap().urString
        } else {
            throw EnvelopeToolError.notCBOR
        }
    }
    
    private static func extractURI(_ envelope: Envelope) throws -> String {
        guard let cbor = envelope.leaf else {
            throw EnvelopeToolError.notCBOR
        }
        return try URL(taggedCBOR: cbor).absoluteString
    }
    
    private static func extractUUID(_ envelope: Envelope) throws -> String {
        try envelope.extractSubject(UUID.self).description.lowercased()
    }
    
    private static func extractWrapped(_ envelope: Envelope) throws -> String {
        try envelope.unwrap().urString
    }
}
