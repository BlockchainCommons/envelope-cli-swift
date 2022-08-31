import ArgumentParser
import BCFoundation

struct Extract: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Extract the subject of the input envelope.")
    @Flag(help: "The data type of the subject.")
    var type: DataType = .string
    
    @Argument(help: "The input envelope.")
    var envelope: Envelope
    
    @Option(name: .customLong("type"), help: "The type for an extracted UR.")
    var urType: String?
    
    @Option(name: .customLong("tag"), help: "The expected tag for an extracted UR.")
    var urTag: UInt64?
    
    func run() throws {
        resetOutput()
        
        switch type {
        case .cbor:
            if let cbor = envelope.leaf {
                printOut(cbor.hex)
            } else if envelope.isWrapped {
                printOut(try envelope.unwrap().cbor.hex)
            } else if let knownPredicate = envelope.knownPredicate {
                printOut(knownPredicate.cbor.hex)
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
            printOut(try envelope.extractSubject(Digest.self).hex)
        case .envelope:
            printOut(try envelope.unwrap().ur)
        case .int:
            printOut(try envelope.extractSubject(Int.self))
        case .knownPredicate:
            printOut(try envelope.extractSubject(KnownPredicate.self))
        case .string:
            printOut(try envelope.extractSubject(String.self))
        case .ur:
            if let cbor = envelope.leaf {
                guard let tag = urTag else {
                    throw EnvelopeToolError.urTagRequired
                }
                guard let type = urType else {
                    throw EnvelopeToolError.urTypeRequired
                }
                guard case CBOR.tagged(CBOR.Tag(rawValue: tag), let untaggedCBOR) = cbor else {
                    throw EnvelopeToolError.urTagMismatch
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
        case .uuid:
            printOut(try envelope.extractSubject(UUID.self))
        }
    }
}
