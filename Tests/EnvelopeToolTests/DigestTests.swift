import XCTest
import WolfBase
import BCFoundation
import EnvelopeTool

final class DigestTests: XCTestCase {
    static override func setUp() {
        setUpTest()
    }

    func testEnvelopeDigest() throws {
        let d = try envelope("digest \(aliceKnowsBobExample)")
        XCTAssertEqual(d, "ur:digest/hdcxldgouyhyadimzmpaeourhfsectvaskspdlotaxidiatbgydejnbwgskbhfrtwlwzneroatds")
    }
}
