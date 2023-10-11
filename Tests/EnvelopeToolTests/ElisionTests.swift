import XCTest
import WolfBase
import BCFoundation
import EnvelopeTool

final class ElisionTests: XCTestCase {
    static override func setUp() {
        setUpTest()
    }
    
    func testElide1() throws {
        var target: [String] = []
        // Top level
        target.append(try envelope("digest \(aliceKnowsBobExample)"))
        // Subject
        target.append(try pipe(["extract --envelope \(aliceKnowsBobExample)", "digest"]))
        // Assertion
        let assertion = try envelope("assertion at 0 \(aliceKnowsBobExample)")
        target.append(try envelope("digest \(assertion)"))
        // Object
        let object = try envelope("extract --object \(assertion)")
        target.append(try envelope("digest \(object)"))

        let digests = target.joined(separator: " ")
        let elided = try envelope("elide \(aliceKnowsBobExample) \(digests)")
        XCTAssertEqual(elided, "ur:envelope/lftpcsihfpjziniaihoyhdcxuykitdcegyinqzlrlgdrcwsbbkihcemtchsntabdpldtbzjepkwsrkdrlernykrdtpcsiafwjlidcyhydiwe")
        XCTAssertEqual(try envelope(elided),
        """
        "Alice" [
            ELIDED: "Bob"
        ]
        """
        )
    }
    
    func testElide2() throws {
        var target: [String] = []
        target.append(try pipe(["subject knows", "digest"]))
        let digests = target.joined(separator: " ")
        let elided = try envelope("elide removing \(aliceKnowsBobExample) \(digests)")
        XCTAssertEqual(elided, "ur:envelope/lftpcsihfpjziniaihoyhdcxuykitdcegyinqzlrlgdrcwsbbkihcemtchsntabdpldtbzjepkwsrkdrlernykrdtpcsiafwjlidcyhydiwe")
        XCTAssertEqual(try envelope(elided),
        """
        "Alice" [
            ELIDED: "Bob"
        ]
        """
        )
    }
}
