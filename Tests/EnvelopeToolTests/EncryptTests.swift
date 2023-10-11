import XCTest
import WolfBase
import BCFoundation
import EnvelopeTool

final class EncryptTests: XCTestCase {
    static override func setUp() {
        setUpTest()
    }

    func testEncrypt() throws {
        let encrypted = try envelope("encrypt \(aliceKnowsBobExample) --key \(keyExample)")
        XCTAssertEqual(try envelope(encrypted),
        """
        ENCRYPTED [
            "knows": "Bob"
        ]
        """
        )
        let decrypted = try envelope("decrypt \(encrypted) --key \(keyExample)")
        XCTAssertEqual(decrypted, aliceKnowsBobExample)
    }
    
    func testGeneratePrivateKeys1() throws {
        let prvkeys = try envelope("generate prvkeys")
        XCTAssertEqual(try UR(urString: prvkeys).type, "crypto-prvkeys")
    }
    
    func testGeneratePrivateKeys2() throws {
        let seed = "ur:crypto-seed/oyadhdcxhsinuesrennenlhfaopycnrfrkdmfnsrvltowmtbmyfwdafxvwmthersktcpetdweocfztrd"
        let prvkeys1 = try envelope("generate prvkeys \(seed)")
        XCTAssertEqual(prvkeys1, "ur:crypto-prvkeys/hdcxhsinuesrennenlhfaopycnrfrkdmfnsrvltowmtbmyfwdafxvwmthersktcpetdwfnbndeah")
        let prvkeys2 = try envelope("generate prvkeys \(seed)")
        XCTAssertEqual(prvkeys1, prvkeys2)
        
        let pubkeys = try envelope("generate pubkeys \(prvkeys1)")
        XCTAssertEqual(pubkeys, "ur:crypto-pubkeys/lftanshfhdcxayvazmflzsfrotemfxvoghtbynbsgywztlheisvapypmidzmaoldisdybkvdlerytansgrhdcxfdgwgacloxsrmupdcybdchfylewsdilrbestjodpwnknndjoztjprfkkjopkdejobebtdlhd")
    }
}
