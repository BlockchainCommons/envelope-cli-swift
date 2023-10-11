import XCTest
import WolfBase
import BCFoundation
import EnvelopeTool

let subject = "this-is-the-subject"
let payloadV1 = "this-is-the-v1-payload"
let payloadV2 = "this-is-the-v2-payload"
let vendor = "com.example"
let conformsToV1 = "https://example.com/v1"
let conformsToV2 = "https://example.com/v2"

final class AttachmentTests: XCTestCase {
    static override func setUp() {
        setUpTest()
    }
    
    var subjectEnvelope: String {
        get throws {
            try envelope("subject \(subject)")
        }
    }
    
    var payloadV1Envelope: String {
        get throws {
            try envelope("subject \(payloadV1)")
        }
    }
    
    var payloadV2Envelope: String {
        get throws {
            try envelope("subject \(payloadV2)")
        }
    }

    var attachmentV1: String {
        get throws {
            try envelope("attachment create \(vendor) --conforms-to \(conformsToV1) \(payloadV1Envelope)")
        }
    }

    var attachmentV2: String {
        get throws {
            try envelope("attachment create \(vendor) --conforms-to \(conformsToV2) \(payloadV2Envelope)")
        }
    }

    var attachmentV1NoConfomance: String {
        get throws {
            try envelope("attachment create \(vendor) \(payloadV1Envelope)")
        }
    }
    
    var envelopeV1V2: String {
        get throws {
            try pipe([
                "attachment add envelope \(attachmentV1)",
                "attachment add envelope \(attachmentV2)"
            ], inputLine: subjectEnvelope)
        }
    }

    func testAttachmentCreate() throws {
        XCTAssertEqual(try envelope(attachmentV1), """
        'attachment': {
            "this-is-the-v1-payload"
        } [
            'conformsTo': "https://example.com/v1"
            'vendor': "com.example"
        ]
        """)
    }

    func testAttachmentCreateNoConformance() throws {
        XCTAssertEqual(try envelope(attachmentV1NoConfomance), """
        'attachment': {
            "this-is-the-v1-payload"
        } [
            'vendor': "com.example"
        ]
        """)
    }

    func testAttachmentQueries() throws {
        XCTAssertEqual(try envelope("attachment payload \(attachmentV1)"), try payloadV1Envelope)
        XCTAssertEqual(try envelope("attachment vendor \(attachmentV1)"), vendor)
        XCTAssertEqual(try envelope("attachment conforms-to \(attachmentV1)"), conformsToV1)
        
        XCTAssertEqual(try envelope("attachment conforms-to \(attachmentV1NoConfomance)"), "")
    }
    
    func testAttachmentAddComponents() throws {
        let result = try pipe([
            "attachment add \(vendor) --conforms-to \(conformsToV1) \(payloadV1Envelope)",
            "attachment add \(vendor) --conforms-to \(conformsToV2) \(payloadV2Envelope)",
            "format"
        ], inputLine: subjectEnvelope)
        XCTAssertEqual(result, """
        "this-is-the-subject" [
            'attachment': {
                "this-is-the-v1-payload"
            } [
                'conformsTo': "https://example.com/v1"
                'vendor': "com.example"
            ]
            'attachment': {
                "this-is-the-v2-payload"
            } [
                'conformsTo': "https://example.com/v2"
                'vendor': "com.example"
            ]
        ]
        """)
    }
    
    func testAttachmentAddEnvelope() throws {
        XCTAssertEqual(try envelope("format \(envelopeV1V2)"), """
        "this-is-the-subject" [
            'attachment': {
                "this-is-the-v1-payload"
            } [
                'conformsTo': "https://example.com/v1"
                'vendor': "com.example"
            ]
            'attachment': {
                "this-is-the-v2-payload"
            } [
                'conformsTo': "https://example.com/v2"
                'vendor': "com.example"
            ]
        ]
        """)
    }
    
    func testAttachmentCount() throws {
        XCTAssertEqual(try envelope("attachment count \(envelopeV1V2)"), "2")
    }
    
    func testAttachmentAll() throws {
        let envelopes = try envelope("attachment all \(envelopeV1V2)").lines
        XCTAssertEqual(envelopes.count, 2)
        XCTAssertEqual(envelopes[0], try attachmentV2)
        XCTAssertEqual(envelopes[1], try attachmentV1)
    }
    
    func testAttachmentAt() throws {
        XCTAssertEqual(
            try envelope("attachment at 0 \(envelopeV1V2)"),
            try attachmentV2
        )
        XCTAssertEqual(
            try envelope("attachment at 1 \(envelopeV1V2)"),
            try attachmentV1
        )
        XCTAssertThrowsError(
            try envelope("attachment at 2 \(envelopeV1V2)")
        )
    }

    func testAttachmentFind() throws {
        XCTAssertEqual(try envelope("attachment find \(envelopeV1V2)").lines.count, 2)
        
        XCTAssertEqual(try envelope("attachment find --vendor \(vendor) \(envelopeV1V2)").lines.count, 2)
        XCTAssertEqual(try envelope("attachment find --vendor bar \(envelopeV1V2)").lines.count, 0)
        
        XCTAssertEqual(try envelope("attachment find --conforms-to \(conformsToV1) \(envelopeV1V2)").lines.count, 1)
        XCTAssertEqual(try envelope("attachment find --conforms-to foo \(envelopeV1V2)").lines.count, 0)
    }
}

extension String {
    var lines: [String] {
        self.split(separator: "\n").map { String($0) }
    }
}
