import ArgumentParser
import BCFoundation

struct Subject: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Create an envelope with the given subject.")
    @Flag(help: "The data type of the subject.")
    var type: DataType = .string
    
    @Argument(help: "The value for the Envelope's subject")
    var value: String
    
    func run() throws {
        resetOutput()
        let envelope: Envelope
        switch type {
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
        case .int:
            guard let n = Int(value) else {
                throw EnvelopeToolError.invalidType(expectedType: "integer")
            }
            envelope = Envelope(n)
        case .string:
            envelope = Envelope(value)
        case .uuid:
            guard let uuid = UUID(uuidString: value) else {
                throw EnvelopeToolError.invalidType(expectedType: "UUID")
            }
            envelope = Envelope(uuid)
        }
        printOut(envelope.ur)
    }
}
