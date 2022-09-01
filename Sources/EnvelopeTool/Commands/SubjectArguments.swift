import ArgumentParser
import BCFoundation

struct SubjectArguments: ParsableArguments {
    init() { }
    
    @Flag(help: "The data type of the subject.")
    var type: DataType = .string
    
    @Argument(help: "The value for the Envelope's subject.")
    var value: String?
    
    @Option(help: "The integer tag for an enclosed UR.")
    var tag: UInt64?
    
    mutating func validate() throws {
        if value == nil {
            value = readIn()
            guard value != nil else {
                throw EnvelopeToolError.unexpectedEOF
            }
        }
    }
    
    init(type: DataType, value: String?, tag: UInt64?) throws {
        self.type = type
        self.value = value
        self.tag = tag
        try validate()
    }
    
    var envelope: Envelope {
        get throws {
            guard let value else {
                throw EnvelopeToolError.missingArgument("value")
            }
            let envelope: Envelope
            switch type {
            case .assertion:
                throw EnvelopeToolError.useAssertionCommand
            case .cbor:
                guard
                    let data = value.hexData,
                    let cbor = try? CBOR(data)
                else {
                    throw EnvelopeToolError.invalidType(expectedType: "hex-encoded CBOR")
                }
                envelope = Envelope(cbor)
            case .cid:
                guard
                    let data = value.hexData,
                    let cid = CID(data)
                else {
                    throw EnvelopeToolError.invalidType(expectedType: "CID")
                }
                envelope = Envelope(cid)
            case .data:
                guard let data = value.hexData else {
                    throw EnvelopeToolError.invalidType(expectedType: "hex")
                }
                envelope = Envelope(data)
            case .date:
                guard let date = ISO8601DateFormatter().date(from: value) else {
                    throw EnvelopeToolError.invalidType(expectedType: "date")
                }
                envelope = Envelope(date)
            case .digest:
                guard
                    let data = value.hexData,
                    let digest = Digest(rawValue: data)
                else {
                    throw EnvelopeToolError.invalidType(expectedType: "digest")
                }
                envelope = Envelope(digest)
            case .envelope:
                envelope = try Envelope(urString: value)
                    .wrap()
            case .int:
                guard let n = Int(value) else {
                    throw EnvelopeToolError.invalidType(expectedType: "integer")
                }
                envelope = Envelope(n)
            case .knownPredicate:
                if let n = UInt64(value) {
                    let p = KnownPredicate(rawValue: n)
                    envelope = Envelope(p)
                } else if let p = KnownPredicate(name: value) {
                    envelope = Envelope(p)
                } else {
                    throw EnvelopeToolError.unknownPredicate(value)
                }
            case .string:
                envelope = Envelope(value)
            case .ur:
                let ur = try UR(urString: value)
                if ur.type == "envelope" {
                    envelope = try Envelope(ur: ur)
                        .wrap()
                } else {
                    guard let tag else {
                        throw EnvelopeToolError.urTagRequired
                    }
                    let cborTag = CBOR.Tag(rawValue: tag)
                    let cbor = try CBOR(ur.cbor)
                    let contentCBOR = CBOR.tagged(cborTag, cbor)
                    envelope = Envelope(contentCBOR)
                }
            case .uuid:
                guard let uuid = UUID(uuidString: value) else {
                    throw EnvelopeToolError.invalidType(expectedType: "UUID")
                }
                envelope = Envelope(uuid)
            }
            return envelope
        }
    }
}
