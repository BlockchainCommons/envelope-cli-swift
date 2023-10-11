import XCTest
import WolfBase
import BCFoundation
import EnvelopeTool

final class SSKRTests: XCTestCase {
    static override func setUp() {
        setUpTest()
    }
    
    func testSSKR1() throws {
        let result = try envelope("sskr split \(aliceKnowsBobExample)")
        XCTAssertEqual(try envelope(result),
        """
        ENCRYPTED [
            'sskrShare': SSKRShare
        ]
        """
        )
        let restored = try envelope("sskr join \(result)")
        XCTAssertEqual(restored, aliceKnowsBobExample)
    }
    
    func testSSKR2() throws {
        let result = try envelope("sskr split -t 2 -g 2-of-3 -g 2-of-3 \(aliceKnowsBobExample)")
        let shares = result.split(separator: " ").compactMap { $0.isEmpty ? nil : $0 }.map { String($0) }
        let indexes = IndexSet([0, 1, 4, 5])
        let recoveredShares = indexes.map { shares[$0] }
        
        let restored1 = try envelope("sskr join \(recoveredShares.joined(separator: " "))")
        XCTAssertEqual(restored1, aliceKnowsBobExample)
        
        let restored2 = try envelope("sskr join", inputLines: recoveredShares)
        XCTAssertEqual(restored2, aliceKnowsBobExample)
    }
}
