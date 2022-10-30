import ArgumentParser
import BCFoundation

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

        switch type {
        case .assertion:
            guard let assertion = envelope.assertion else {
                throw EnvelopeToolError.notAssertion
            }
            printOut([assertion.predicate, assertion.object].map { $0.ur.string }.joined(separator: "\n"))
        case .predicate:
            guard let assertion = envelope.assertion else {
                throw EnvelopeToolError.notAssertion
            }
            printOut(assertion.predicate.ur)
        case .object:
            guard let assertion = envelope.assertion else {
                throw EnvelopeToolError.notAssertion
            }
            printOut(assertion.object.ur)
        case .cbor:
            if let cbor = envelope.leaf {
                printOut(cbor.hex)
            } else if envelope.isWrapped {
                printOut(try envelope.unwrap().cbor.hex)
            } else if let knownValue = envelope.knownValue {
                printOut(knownValue.cbor.hex)
            } else {
                throw EnvelopeToolError.notCBOR
            }
        case .cid:
            printOut(try envelope.extractSubject(CID.self).hex)
        case .data:
            printOut(try envelope.extractSubject(Data.self).hex)
        case .date:
            let date = try envelope.extractSubject(Date.self)
            let dateString = ISO8601DateFormatter().string(from: date)
            printOut(dateString)
        case .digest:
            printOut(try envelope.extractSubject(Digest.self).ur)
        case .envelope:
            printOut(envelope.subject.ur)
        case .int:
            printOut(try envelope.extractSubject(Int.self))
        case .float:
            printOut(try envelope.extractSubject(Double.self))
        case .known:
            printOut(try envelope.extractSubject(KnownValue.self))
        case .string:
            printOut(try envelope.extractSubject(String.self))
        case .ur:
            addKnownTags()
            if let cbor = envelope.leaf {
                guard case CBOR.tagged(let tag, let untaggedCBOR) = cbor else {
                    throw EnvelopeToolError.urMissingTag
                }
                let knownTag = CBOR.Tag.knownTag(for: tag.rawValue)
                guard let type = knownTag?.name ?? urType else {
                    throw EnvelopeToolError.urTypeRequired
                }
                printOut(try! UR(type: type, cbor: untaggedCBOR))
            } else if envelope.isWrapped {
                if urType != nil || urTag != nil {
                    guard urTag == CBOR.Tag.envelope.rawValue else {
                        throw EnvelopeToolError.urTagMismatch
                    }
                    guard urType == CBOR.Tag.envelope.urType else {
                        throw EnvelopeToolError.urTypeMismatch
                    }
                }
                printOut(try envelope.unwrap().ur)
            } else {
                throw EnvelopeToolError.notCBOR
            }
        case .uri:
            guard let cbor = envelope.leaf else {
                throw EnvelopeToolError.notCBOR
            }
            printOut(try URL(taggedCBOR: cbor).absoluteString)
        case .wrapped:
            printOut(try envelope.unwrap().ur)
        case .uuid:
            printOut(try envelope.extractSubject(UUID.self))
        }
    }
}
