import XCTest
import WolfBase
import BCFoundation
import EnvelopeTool

final class FormatTests: XCTestCase {
    static override func setUp() {
        setUpTest()
    }

    func testFormat() throws {
        let expectedOutput =
        """
        "Hello."
        """

        XCTAssertEqual(try envelope(helloEnvelopeUR), expectedOutput)
        XCTAssertEqual(try envelope("", inputLine: helloEnvelopeUR), expectedOutput)
        XCTAssertEqual(try envelope("format \(helloEnvelopeUR)"), expectedOutput)
        XCTAssertEqual(try envelope("format", inputLine: helloEnvelopeUR), expectedOutput)
    }
}
