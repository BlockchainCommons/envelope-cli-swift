import ArgumentParser
import Foundation
import BCFoundation
import WolfBase

struct SubjectArguments: ParsableArguments {
    init() { }
    
    @Flag(help: "The data type of the subject.")
    var type: DataType = .string
    
    @Argument(help: "The value for the Envelope's subject.")
    var value: String?
    
    @Option(help: "The integer tag for an enclosed UR.")
    var tag: UInt64?
    
    mutating func fill() throws {
        if value == nil {
            value = readIn()
        }
    }
    
    init(type: DataType, value: String?, tag: UInt64?) throws {
        self.type = type
        self.value = value
        self.tag = tag
        try validate()
    }
    
    static let dateTimeFormatter = ISO8601DateFormatter()
    static let dateFormatter = {
        var formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withFullDate
        return formatter
    }()
    
    var envelope: Envelope {
        get throws {
            guard let value else {
                throw EnvelopeToolError.missingArgument("value")
            }
            let envelope: Envelope
            switch type {
            case .assertion, .predicate, .object:
                throw EnvelopeToolError.useAssertionCommand
            case .cbor:
                guard
                    let data = HexData(argument: value)?.data,
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
                guard let date =
                        Self.dateTimeFormatter.date(from: value) ??
                        Self.dateFormatter.date(from: value)
                else {
                    throw EnvelopeToolError.invalidType(expectedType: "date")
                }
                envelope = Envelope(date)
            case .digest:
                envelope = Envelope(try Digest(urString: value))
            case .envelope:
                envelope = try Envelope(urString: value)
            case .number:
                guard let n = Double(value) else {
                    throw EnvelopeToolError.invalidType(expectedType: "number")
                }
                envelope = Envelope(n)
            case .known:
                if let n = UInt64(value) {
                    let p = KnownValue(n)
                    envelope = Envelope(p)
                } else if let p = knownValues.knownValue(named: value) {
                    envelope = Envelope(p)
                } else {
                    throw EnvelopeToolError.notAKnownValue(value)
                }
            case .string:
                envelope = Envelope(value)
            case .ur:
                let ur = try UR(urString: value)
                if ur.type == "envelope" {
                    envelope = try Envelope(ur: ur)
                        .wrap()
                } else {
                    var cborTag = knownTags.tag(for: ur.type)
                    if
                        cborTag == nil,
                        let tagValue = tag
                    {
                        cborTag = Tag(tagValue)
                    }
                    guard let cborTag else {
                        throw EnvelopeToolError.urTagRequired(ur.type)
                    }
                    let cbor = ur.cbor
                    let contentCBOR = CBOR.tagged(cborTag, cbor)
                    envelope = Envelope(contentCBOR)
                }
            case .uri:
                guard let url = URL(string: value) else {
                    throw EnvelopeToolError.invalidURL(value)
                }
                envelope = Envelope(url.taggedCBOR)
            case .uuid:
                guard let uuid = UUID(uuidString: value) else {
                    throw EnvelopeToolError.invalidType(expectedType: "UUID")
                }
                envelope = Envelope(uuid)
            case .wrapped:
                envelope = try Envelope(urString: value)
                    .wrap()
            }
            return envelope
        }
    }
}
