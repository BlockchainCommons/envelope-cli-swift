import XCTest
import WolfBase
import BCFoundation
import EnvelopeTool

final class GenerateTests: XCTestCase {
    static override func setUp() {
        setUpTest()
    }

    func testGenerateKey() throws {
        let key1 = try envelope("generate key")
        let key2 = try envelope("generate key")
        XCTAssertNotEqual(key1, key2)
        XCTAssertEqual(try UR(urString: key1).type, "crypto-key")
    }
    
    func testGenerateARID() throws {
        let arid1 = try envelope("generate arid")
        let arid2 = try envelope("generate arid")
        XCTAssertNotEqual(arid1, arid2)
        XCTAssertEqual(try UR(urString: arid1).type, "arid")
        
        let arid3 = try envelope("generate arid --hex d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f")
        XCTAssertEqual(arid3, "ur:arid/hdcxtygshybkzcecfhflpfdlhdonotoentnydmzsidmkindlldjztdmoeyishknybtbswtgwwpdi")
    }
    
    func testGenerateSeed() throws {
        let seed1 = try envelope("generate seed")
        let seed2 = try envelope("generate seed")
        XCTAssertNotEqual(seed1, seed2)
        XCTAssertEqual(try UR(urString: seed1).type, "crypto-seed")
        
        let seed3 = try envelope("generate seed --hex 187a5973c64d359c836eba466a44db7b")
        XCTAssertEqual(seed3, "ur:crypto-seed/oyadgdcsknhkjkswgtecnslsjtrdfgimfyuykglfsfwtso")
    }
    
    func testGenerateDigest() throws {
        let expectedDigest = "ur:digest/hdcxdplutstarkhelprdiefhadbetlbnreamoyzefxnnkonycpgdehmuwdhnfgrkltylrovyeeck"
        
        let e = try envelope("generate digest \(helloString)")
        XCTAssertEqual(e, expectedDigest)
        
        let e2 = try pipe(["generate digest"], inputLine: helloString)
        XCTAssertEqual(e2, expectedDigest)
    }
}
