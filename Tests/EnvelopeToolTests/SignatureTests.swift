import XCTest
import WolfBase
import BCFoundation
import EnvelopeTool

final class SignatureTests: XCTestCase {
    static override func setUp() {
        setUpTest()
    }
    
    func testSign() throws {
        let prvkeys = "ur:crypto-prvkeys/hdcxhsinuesrennenlhfaopycnrfrkdmfnsrvltowmtbmyfwdafxvwmthersktcpetdwfnbndeah"
        let signed = try envelope("sign \(aliceKnowsBobExample) --prvkeys \(prvkeys)")
        XCTAssertEqual(try envelope(signed),
        """
        "Alice" [
            "knows": "Bob"
            'verifiedBy': Signature
        ]
        """
        )
        
        let pubkeys = try envelope("generate pubkeys \(prvkeys)")

        XCTAssertNoThrow(try envelope("verify \(signed) --pubkeys \(pubkeys)"))

        XCTAssertThrowsError(try envelope("verify \(aliceKnowsBobExample) --pubkeys \(pubkeys)"))

        let badPubkeys = try pipe(["generate prvkeys", "generate pubkeys"])
        XCTAssertThrowsError(try envelope("verify \(signed) --pubkeys \(badPubkeys)"))
    }
    
    func testSign2() throws {
        let prvkeys = "ur:crypto-prvkeys/hdcxhsinuesrennenlhfaopycnrfrkdmfnsrvltowmtbmyfwdafxvwmthersktcpetdwfnbndeah"
        let wrappedSigned = try pipe(["subject --wrapped \(aliceKnowsBobExample)", "sign --prvkeys \(prvkeys)"])
        XCTAssertEqual(try envelope(wrappedSigned),
        """
        {
            "Alice" [
                "knows": "Bob"
            ]
        } [
            'verifiedBy': Signature
        ]
        """
        )

        let pubkeys = try envelope("generate pubkeys \(prvkeys)")
        XCTAssertNoThrow(try envelope("verify \(wrappedSigned) --pubkeys \(pubkeys)"))
    }
    
    func testSign3() throws {
        let e = try pipe(["subject \(helloString)", "sign --prvkeys \(alicePrvkeys) --prvkeys \(carolPrvkeys)"])
        XCTAssertEqual(try envelope(e),
        """
        "Hello." [
            'verifiedBy': Signature
            'verifiedBy': Signature
        ]
        """
        )
    }
}
