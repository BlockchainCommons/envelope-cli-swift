import ArgumentParser
import BCFoundation

func assertionForValues(_ values: [String], types: [DataType], predicateTag: UInt64?, objectTag: UInt64?) throws -> Envelope {
    switch values.count {
    case 0:
        throw EnvelopeToolError.missingArgument("predicate and object")
    case 1:
        throw EnvelopeToolError.missingArgument("object")
    case 2:
        break
    default:
        throw EnvelopeToolError.tooManyArguments
    }
    
    var types = types
    
    switch types.count {
    case 0:
        types = [.string, .string]
    case 1:
        types.append(.string)
    case 2:
        break
    default:
        throw EnvelopeToolError.tooManyTypes
    }
    
    let predicate = try envelopeForValue(values[0], type: types[0], tag: predicateTag)
    let object = try envelopeForValue(values[1], type: types[1], tag: objectTag)
    return Envelope(predicate: predicate, object: object)
}

func envelopeForValue(_ value: String, type: DataType, tag: UInt64?) throws -> Envelope {
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
