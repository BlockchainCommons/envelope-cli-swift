import ArgumentParser
import BCFoundation

struct Extract: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Extract the subject of the input envelope.")
    @Flag(help: "The data type of the subject.")
    var type: DataType = .string
    
    @Argument(help: "The input envelope.")
    var envelope: Envelope
    
    func run() throws {
        resetOutput()
        
        switch type {
        case .cbor:
            if let cbor = envelope.leaf {
                printOut(cbor.hex)
            } else if envelope.isWrapped {
                printOut(try envelope.unwrap().cbor.hex)
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
        case .string:
            printOut(try envelope.extractSubject(String.self))
        case .uuid:
            printOut(try envelope.extractSubject(UUID.self))
        }
    }
}
