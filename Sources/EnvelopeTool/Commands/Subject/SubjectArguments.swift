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
            case .arid:
                envelope = try Self.parseARID(value)
            case .bool:
                envelope = try Self.parseBool(value)
            case .cbor:
                envelope = try Self.parseCBOR(value)
            case .data:
                envelope = try Self.parseData(value)
            case .date:
                envelope = try Self.parseDate(value)
            case .digest:
                envelope = try Self.parseDigest(value)
            case .envelope:
                envelope = try Self.parseEnvelope(value)
            case .known:
                envelope = try Self.parseKnown(value)
            case .number:
                envelope = try Self.parseNumber(value)
            case .string:
                envelope = try Self.parseString(value)
            case .ur:
                envelope = try Self.parseUR(value, tag: tag)
            case .uri:
                envelope = try Self.parseURI(value)
            case .uuid:
                envelope = try Self.parseUUID(value)
            case .wrapped:
                envelope = try Self.parseWrapped(value)
            }
            return envelope
        }
    }
    
    private static func parseARID(_ value: String) throws -> Envelope {
        if
            let data = value.hexData,
            let arid = ARID(data)
        {
            Envelope(arid)
        } else if let arid = try? ARID(urString: value) {
            Envelope(arid)
        } else {
            throw EnvelopeToolError.invalidType(expectedType: "ARID (ur:arid or 32 hex bytes)")
        }
    }

    private static func parseBool(_ value: String) throws -> Envelope {
        guard let b = Bool(value) else {
            throw EnvelopeToolError.invalidType(expectedType: "boolean")
        }
        return Envelope(b)
    }

    private static func parseCBOR(_ value: String) throws -> Envelope {
        guard
            let data = HexData(argument: value)?.data,
            let cbor = try? CBOR(data)
        else {
            throw EnvelopeToolError.invalidType(expectedType: "hex-encoded CBOR")
        }
        return Envelope(cbor)
    }
    
    private static func parseData(_ value: String) throws -> Envelope {
        guard let data = value.hexData else {
            throw EnvelopeToolError.invalidType(expectedType: "hex")
        }
        return Envelope(data)
    }
    
    private static func parseDate(_ value: String) throws -> Envelope {
        guard let date =
                Self.dateTimeFormatter.date(from: value) ??
                Self.dateFormatter.date(from: value)
        else {
            throw EnvelopeToolError.invalidType(expectedType: "date")
        }
        return Envelope(date)
    }
    
    private static func parseDigest(_ value: String) throws -> Envelope {
        Envelope(try Digest(urString: value))
    }
    
    private static func parseEnvelope(_ value: String) throws -> Envelope {
        try Envelope(urString: value)
    }
    
    private static func parseKnown(_ value: String) throws -> Envelope {
        if let n = UInt64(value) {
            let p = KnownValue(n)
            return Envelope(p)
        } else if let p = globalKnownValues.knownValue(named: value) {
            return Envelope(p)
        } else {
            throw EnvelopeToolError.notAKnownValue(value)
        }
    }
    
    private static func parseNumber(_ value: String) throws -> Envelope {
        guard let n = Double(value) else {
            throw EnvelopeToolError.invalidType(expectedType: "number")
        }
        return Envelope(n)
    }
    
    private static func parseString(_ value: String) throws -> Envelope {
        Envelope(value)
    }
    
    private static func parseUR(_ value: String, tag: UInt64?) throws -> Envelope {
        let ur = try UR(urString: value)
        if ur.type == "envelope" {
            return try Envelope(ur: ur)
                .wrap()
        } else {
            var cborTag = globalTags.tag(for: ur.type)
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
            return Envelope(contentCBOR)
        }
    }
    
    private static func parseURI(_ value: String) throws -> Envelope {
        guard let url = URL(string: value) else {
            throw EnvelopeToolError.invalidURL(value)
        }
        return Envelope(url.taggedCBOR)
    }
    
    private static func parseUUID(_ value: String) throws -> Envelope {
        guard let uuid = UUID(uuidString: value) else {
            throw EnvelopeToolError.invalidType(expectedType: "UUID")
        }
        return Envelope(uuid)
    }
    
    private static func parseWrapped(_ value: String) throws -> Envelope {
        try Envelope(urString: value)
            .wrap()
    }
}
