import XCTest
import WolfBase
import BCFoundation
import EnvelopeTool

final class EnvelopeToolTests: XCTestCase {
    static override func setUp() {
        setUpTest()
    }
    
    func testExtractAssertionSubject() throws {
        let e = Envelope(.note, "This is a note.")
        let ur = e.ur.string

        let predicateEnvelope = "ur:envelope/aatljldnmw"
        let objectEnvelope = "ur:envelope/tpcsjlghisinjkcxinjkcxhscxjtjljyihdmbamnatmn"

        let predObj = try envelope("extract --assertion \(ur)")
        XCTAssertEqual(predObj,
            """
            \(predicateEnvelope)
            \(objectEnvelope)
            """
        )
        
        let parts = predObj.split(separator: "\n").map { String($0) }
        let parts2 = try parts.map { try Envelope(urString: String($0)).ur.string }
        XCTAssertEqual(parts†, parts2†)
        
        let pred = try envelope("extract --predicate \(ur)")
        XCTAssertEqual(pred, predicateEnvelope)
        let obj = try envelope("extract --object \(ur)")
        XCTAssertEqual(obj, objectEnvelope)
    }
}
