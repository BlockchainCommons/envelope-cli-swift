import XCTest
import WolfBase
import BCFoundation
import EnvelopeTool

final class SubjectTests: XCTestCase {
    static override func setUp() {
        setUpTest()
    }

    func testCBORSubject() throws {
        let e = try envelope("subject --cbor \(cborArrayExample)")
        XCTAssertEqual(e, "ur:envelope/tpcslsadaoaxgedmotks")
        XCTAssertEqual(try envelope(e), "[1, 2, 3]")
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "83010203")
        
        let e2 = try envelope("subject --cbor", inputLine: cborArrayExample)
        XCTAssertEqual(e, e2)
    }
    
    func testARIDSubject() throws {
        let e = try envelope("subject --arid \(aridExample)")
        XCTAssertEqual(e, "ur:envelope/tpcstansgshdcxuestvsdemusrdlkngwtosweortdwbasrdrfxhssgfmvlrflthdplatjydmmwahgddrrlvarh")
        XCTAssertEqual(try envelope(e), "ARID(\(aridExample.prefix(8)))")
        XCTAssertEqual(try envelope("extract --arid \(e)"), aridExample)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "d99c4c5820dec7e82893c32f7a4fcec633c02c0ec32a4361ca3ee3bc8758ae07742e940550")
    }
    
    func testWrappedEnvelopeSubject() throws {
        let e = try envelope("subject --wrapped \(helloEnvelopeUR)")
        XCTAssertEqual(e, "ur:envelope/tpsptpcsiyfdihjzjzjldmvysrenfx")
        XCTAssertEqual(try envelope(e),
        """
        {
            "Hello."
        }
        """
        )
        XCTAssertEqual(try envelope("extract --wrapped \(e)"), helloEnvelopeUR)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "d8186648656c6c6f2e")
        XCTAssertEqual(try envelope("extract --ur \(e)"), helloEnvelopeUR)
    }

    func testDataSubject() throws {
        let value = "cafebabe"
        let e = try envelope("subject --data \(value)")
        XCTAssertEqual(e, "ur:envelope/tpcsfysgzerdrntewsiecp")
        XCTAssertEqual(try envelope(e), "Bytes(4)")
        XCTAssertEqual(try envelope("extract --data \(e)"), value)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "44cafebabe")
    }
    
    func testDateSubject() throws {
        let e = try envelope("subject --date \(dateExample)")
        XCTAssertEqual(e, "ur:envelope/tpcssecyiabtrhfrpafdbzdy")
        XCTAssertEqual(try envelope(e), dateExample)
        XCTAssertEqual(try envelope("extract --date \(e)"), dateExample)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "c11a630db93b")
    }
    
    func testDigestSubject() throws {
        let e = try envelope("subject --digest \(digestExample)")
        XCTAssertEqual(e, "ur:envelope/tpcstansfphdcxdplutstarkhelprdiefhadbetlbnreamoyzefxnnkonycpgdehmuwdhnfgrkltylyngdieke")
        XCTAssertEqual(try envelope(e), "Digest(2d8bd7d9)")
        XCTAssertEqual(try envelope("extract --digest \(e)"), digestExample)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "d99c4158202d8bd7d9bb5f85ba643f0110d50cb506a1fe439e769a22503193ea6046bb87f7")
    }

    func testFloatSubject() throws {
        let value = "42.5"
        let e = try envelope("subject --number \(value)")
        XCTAssertEqual(e, "ur:envelope/tpcsytgygdmktysogr")
        XCTAssertEqual(try envelope(e), value)
        XCTAssertEqual(try envelope("extract --number \(e)"), value)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "f95150")
    }

    func testIntSubject() throws {
        let value = "42"
        let e = try envelope("subject --number \(value)")
        XCTAssertEqual(e, "ur:envelope/tpcscsdrldehwedp")
        XCTAssertEqual(try envelope(e), value)
        XCTAssertEqual(try envelope("extract --number \(e)"), value)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "182a")
    }

    func testNegativeIntSubject() throws {
        // https://github.com/apple/swift-argument-parser/issues/31#issuecomment-593563022
        let value = "-42"
        let e = try envelope("subject --number -- \(value)")
        XCTAssertEqual(e, "ur:envelope/tpcsetdtlprfmkec")
        XCTAssertEqual(try envelope(e), value)
        XCTAssertEqual(try envelope("extract --number \(e)"), value)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "3829")
    }
    
    func testKnownValueSubject() throws {
        let value = "note"
        let e = try envelope("subject --known \(value)")
        XCTAssertEqual(e, "ur:envelope/aatljldnmw")
        XCTAssertEqual(try envelope(e), "'note'")
        XCTAssertEqual(try envelope("extract --known \(e)"), "note")
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "d99c4004")
    }

    func testStringSubject() throws {
        XCTAssertEqual(try envelope("subject Hello."), helloEnvelopeUR)
        XCTAssertEqual(try envelope("subject --string Hello."), helloEnvelopeUR)
        XCTAssertEqual(try envelope("extract \(helloEnvelopeUR)"), helloString)
        XCTAssertEqual(try envelope("extract --cbor \(helloEnvelopeUR)"), "6648656c6c6f2e")
        
        XCTAssertEqual(try pipe(["subject", "extract"], inputLine: helloString), helloString)
    }
    
    func testEnvelopeURSubject() throws {
        let e = try envelope("subject --ur \(helloEnvelopeUR)")
        XCTAssertEqual(e, "ur:envelope/tpsptpcsiyfdihjzjzjldmvysrenfx")
        XCTAssertEqual(try envelope(e),
            """
            {
                "Hello."
            }
            """
        )
        XCTAssertEqual(try envelope("extract --ur \(e)"), helloEnvelopeUR)
        XCTAssertEqual(try envelope("extract --wrapped \(e)"), helloEnvelopeUR)
    }
    
    func testKnownURSubject() throws {
        let e = try envelope("subject --ur \(seedURExample)")
        XCTAssertEqual(e, "ur:envelope/tpcstantjzoyadgdaawzwplrbdhdpabgrnvokorolnrtemkscfjpaost")
        XCTAssertEqual(try envelope(e),
            """
            seed(Map)
            """
        )
        XCTAssertEqual(try envelope("extract --ur \(e)"), seedURExample)
    }
    
    func testUnknownURSubject() throws {
        let unknownUR = "ur:unknown/oyadgdjlssmkcklgoskseodnyteofwwfylkiftjzamgrht"
        let e = try envelope("subject --ur \(unknownUR) --tag 555")
        XCTAssertEqual(e, "ur:envelope/tpcstaaodnoyadgdjlssmkcklgoskseodnyteofwwfylkiftnsjphsox")
        XCTAssertEqual(try envelope(e),
            """
            555(Map)
            """
        )
        XCTAssertEqual(try envelope("extract --ur \(e) --type unknown"), unknownUR)
    }

    func testUUIDSubject() throws {
        let e = try envelope("subject --uuid \(uuidExample)")
        XCTAssertEqual(e, "ur:envelope/tpcstpdagdwmemkbihhgjyfpbkrhsbgybdztjkvataspdsylpf")
        XCTAssertEqual(try envelope(e), "UUID(\(uuidExample))")
        XCTAssertEqual(try envelope("extract --uuid \(e)"), uuidExample)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "d82550eb377e655774410ab9cb510bfc73e6d9")
    }
}
