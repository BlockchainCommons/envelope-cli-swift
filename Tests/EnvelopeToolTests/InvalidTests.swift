import XCTest
import WolfBase
import BCFoundation
import EnvelopeTool

final class InvalidTests: XCTestCase {
    static override func setUp() {
        setUpTest()
    }

    func testInvalidCommand() throws {
        XCTAssertThrowsError(try envelope("unknownCommand"))
    }
    
    func testInvalidData() throws {
        XCTAssertThrowsError(try envelope("ur:seed/oyadgdtokgdpwkrsonfdltvdwttsnddneonbmdbntakkss"))
    }
}
