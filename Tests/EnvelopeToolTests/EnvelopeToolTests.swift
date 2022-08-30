import XCTest
import BCFoundation
@testable import EnvelopeTool

let helloString = "Hello."
let helloEnvelopeUR = "ur:envelope/tpuoiyfdihjzjzjldmgsgontio"
let cborArrayExample = CBOR.array([1, 2, 3]).cborEncode.hex
let uuidExample = "EB377E65-5774-410A-B9CB-510BFC73E6D9"
let cidExample = "dec7e82893c32f7a4fcec633c02c0ec32a4361ca3ee3bc8758ae07742e940550"
let dateExample = "2022-08-30T07:16:11Z"
let digestExample = Digest(helloString).data.hex

final class EnvelopeToolTests: XCTestCase {
    static override func setUp() {
        EnvelopeTool.outputToStdout = false
    }
    
    func testFormat() throws {
        let expectedOutput =
        """
        "Hello."
        """

        XCTAssertEqual(try envelope(helloEnvelopeUR), expectedOutput)
        XCTAssertEqual(try envelope("format \(helloEnvelopeUR)"), expectedOutput)
    }
    
    func testCBORSubject() throws {
        let e = try envelope("subject --cbor \(cborArrayExample)")
        XCTAssertEqual(e, "ur:envelope/tpuolsadaoaxhfrkweia")
        XCTAssertEqual(try envelope(e), "CBOR")
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "83010203")
    }
    
    func testCIDSubject() throws {
        let e = try envelope("subject --cid \(cidExample)")
        XCTAssertEqual(e, "ur:envelope/tpuotpsghdcxuestvsdemusrdlkngwtosweortdwbasrdrfxhssgfmvlrflthdplatjydmmwahgdrytleywm")
        XCTAssertEqual(try envelope(e), "CID(\(cidExample))")
        XCTAssertEqual(try envelope("extract --cid \(e)"), cidExample)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "d8ca5820dec7e82893c32f7a4fcec633c02c0ec32a4361ca3ee3bc8758ae07742e940550")
    }
    
    func testWrappedEnvelopeSubject() throws {
        let e = try envelope("subject --envelope \(helloEnvelopeUR)")
        XCTAssertEqual(e, "ur:envelope/tpvttpuoiyfdihjzjzjldmfxonfnpk")
        XCTAssertEqual(try envelope(e),
        """
        {
            "Hello."
        }
        """
        )
        XCTAssertEqual(try envelope("extract --envelope \(e)"), helloEnvelopeUR)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "d8c8d8dc6648656c6c6f2e")
    }

    func testDataSubject() throws {
        let value = "cafebabe"
        let e = try envelope("subject --data \(value)")
        XCTAssertEqual(e, "ur:envelope/tpuofysgzerdrnhkmtetla")
        XCTAssertEqual(try envelope(e), "Data")
        XCTAssertEqual(try envelope("extract --data \(e)"), value)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "44cafebabe")
    }
    
    func testDateSubject() throws {
        let e = try envelope("subject --date \(dateExample)")
        XCTAssertEqual(e, "ur:envelope/tpuosecyiabtrhfrldcyplpd")
        XCTAssertEqual(try envelope(e), dateExample)
        XCTAssertEqual(try envelope("extract --date \(e)"), dateExample)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "c11a630db93b")
    }
    
    func testDigestSubject() throws {
        let e = try envelope("subject --digest \(digestExample)")
        XCTAssertEqual(e, "ur:envelope/tpuotpsbhdcxfdurmtpygubelooyaowdrpglbakeuodanylrbbesimbnwlkgbywpmksgbbsajnlklalsjkjn")
        XCTAssertEqual(try envelope(e), "Digest(\(digestExample))")
        XCTAssertEqual(try envelope("extract --digest \(e)"), digestExample)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "d8cb582048df96ab531088a102eab64e0e7cdc259a8414396a0ce97b11ec98ca14c26d8c")
    }

    func testIntSubject() throws {
        let value = "42"
        let e = try envelope("subject --int \(value)")
        XCTAssertEqual(e, "ur:envelope/tpuocsdrctmstepa")
        XCTAssertEqual(try envelope(e), value)
        XCTAssertEqual(try envelope("extract --int \(e)"), value)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "182a")
    }

    func testNegativeIntSubject() throws {
        // https://github.com/apple/swift-argument-parser/issues/31#issuecomment-593563022
        let value = "-42"
        let e = try envelope("subject --int -- \(value)")
        XCTAssertEqual(e, "ur:envelope/tpuoetdtbwcyolpt")
        XCTAssertEqual(try envelope(e), value)
        XCTAssertEqual(try envelope("extract --int \(e)"), value)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "3829")
    }

    func testStringSubject() throws {
        XCTAssertEqual(try envelope("subject Hello."), helloEnvelopeUR)
        XCTAssertEqual(try envelope("subject --string Hello."), helloEnvelopeUR)
        XCTAssertEqual(try envelope("extract \(helloEnvelopeUR)"), helloString)
        XCTAssertEqual(try envelope("extract --cbor \(helloEnvelopeUR)"), "6648656c6c6f2e")
    }
    
    func testUUIDSubject() throws {
        let e = try envelope("subject --uuid \(uuidExample)")
        XCTAssertEqual(e, "ur:envelope/tpuotpdagdwmemkbihhgjyfpbkrhsbgybdztjkvatatpsaztte")
        XCTAssertEqual(try envelope(e), "UUID(\(uuidExample))")
        XCTAssertEqual(try envelope("extract --uuid \(e)"), uuidExample)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "d82550eb377e655774410ab9cb510bfc73e6d9")
    }

    func testInvalidCommand() throws {
        XCTAssertThrowsError(try envelope("unknownCommand"))
    }
    
    func testInvalidData() throws {
        XCTAssertThrowsError(try envelope("ur:crypto-seed/oyadgdtokgdpwkrsonfdltvdwttsnddneonbmdbntakkss"))
    }
}

func envelope(_ arguments: [String]) throws -> String {
    var t = try Main.parseAsRoot(arguments)
    try t.run()
    return EnvelopeTool.outputText
}

func envelope(_ argument: String) throws -> String {
    try envelope(argument.split(separator: " ").map { String($0) })
}
