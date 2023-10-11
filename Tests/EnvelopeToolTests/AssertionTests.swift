import XCTest
import WolfBase
import BCFoundation
import EnvelopeTool

final class AssertionTests: XCTestCase {
    static override func setUp() {
        setUpTest()
    }

    func testAssertion() throws {
        let e = try envelope("subject assertion Alpha Beta")
        XCTAssertEqual(e, "ur:envelope/oytpcsihfpjzjoishstpcsiefwihjyhsptyngldp")
        XCTAssertEqual(try envelope(e), #""Alpha": "Beta""#)
    }
    
    func testAssertion2() throws {
        let e = try envelope("subject assertion --number 1 --number 2")
        XCTAssertEqual(e, "ur:envelope/oytpcsadtpcsaolpkbrsfs")
        XCTAssertEqual(try envelope(e), "1: 2")
    }
    
    func testAssertion3() throws {
        let e = try envelope("subject assertion --known note ThisIsANote.")
        XCTAssertEqual(e, "ur:envelope/oyaatpcsjzghisinjkgajkfpgljljyihdmsnnbgahp")
        XCTAssertEqual(try envelope(e), #"'note': "ThisIsANote.""#)
    }
    
    func testAssertionAdd() throws {
        let subject = try envelope("subject Alice")
        let e = try envelope("assertion add knows Bob \(subject)")
        XCTAssertEqual(e, aliceKnowsBobExample)
        XCTAssertEqual(try envelope(e),
            """
            "Alice" [
                "knows": "Bob"
            ]
            """
        )
    }
    
    func testAssertionAdd2() throws {
        let subject = try envelope("subject Alice")
        let predicate = try envelope("subject knows")
        let object = try envelope("subject Bob")
        let e = try envelope("assertion --envelope \(predicate) --envelope \(object) \(subject)")
        XCTAssertEqual(try envelope(e),
            """
            "Alice" [
                "knows": "Bob"
            ]
            """
        )
    }
    
    func testAssertionCount() throws {
        let count = try envelope("assertion count \(aliceKnowsBobExample)")
        XCTAssertEqual(count, "1")
    }
    
    func testAssertionCount2() throws {
        let count = try envelope("assertion count \(credentialExample)")
        XCTAssertEqual(count, "2")
    }
    
    func testAssertionCount3() throws {
        let count = try pipe(["extract --wrapped", "assertion count"], inputLine: credentialExample)
        XCTAssertEqual(count, "13")
    }

    func testAssertionAt() throws {
        let e = try envelope("assertion at 0 \(aliceKnowsBobExample)")
        XCTAssertEqual(e, "ur:envelope/oytpcsihjejtjlktjktpcsiafwjlidmhaxgwio")
        XCTAssertEqual(try envelope(e), #""knows": "Bob""#)
    }

    func testAssertionAt2() throws {
        let e = try pipe(["extract --wrapped", "assertion at 12"], inputLine: credentialExample)
        XCTAssertEqual(try envelope(e), #"'issuer': "Example Electrical Engineering Board""#)
    }

    func testAssertionAt3() throws {
        let e = try pipe(["extract --wrapped", "assertion at 12", "extract --object", "extract"], inputLine: credentialExample)
        XCTAssertEqual(e, "Example Electrical Engineering Board")
    }

    func testAssertionAll() throws {
        let assertions = try pipe(["extract --wrapped", "assertion all"], inputLine: credentialExample)
        print(assertions)
        XCTAssertEqual(assertions,
        """
        ur:envelope/oytpcsjsiaihjpjyiniyiniahsjyihglkpjnidihjptpcsjeeheyeodpeeecendpemetesmtskgyzt
        ur:envelope/oytpcsjtihksjoinjphsjyinjljtfyhsjyihtpcssecyjncscxaemupyjkaa
        ur:envelope/oytpcsisjzhsjkjyglhsjnihtpcsiogthsksktihjzjzwshedtst
        ur:envelope/oytpcsininjkjkkpihfyhsjyihtpcssecyhybdvyaeldwtsovs
        ur:envelope/oyadtpcskscffxihjpjyiniyiniahsjyihcxjliycxfxjljnjojzihjyinjljtwdiyftes
        ur:envelope/oytpcsihjoisjljyjltpcsksckghisinjkcxinjkcxgehsjnihjkcxgthsksktihjzjzdijkcxjoisjljyjldmbaghdstp
        ur:envelope/oytpcskscejojpjliyihjkjkinjljthsjzfyihkoihjzjljojnihjtjyfdjlkpjpjktpcsbsbdjyeeby
        ur:envelope/oytpcsiniyinjpjkjyglhsjnihtpcsihgehsjnihjklkpmjngm
        ur:envelope/oytpcsiyjyjljoiniajktpcslfingukpidimihiajycxehingukpidimihiajycxeyhnnegwax
        ur:envelope/oytpcskscsiajljtjyinjtkpinjtiofeiekpiahsjyinjljtgojtinjyjktpcsadbygssbue
        ur:envelope/oyattpcsksdkfekshsjnjojzihcxfejzihiajyjpiniahsjzcxfejtioinjtihihjpinjtiocxfwjlhsjpiedlmdssse
        ur:envelope/oytpcsiojkkpidimihiajytpcskscegmfgcxhsjtiecxgtiniajpjlkthskoihcxfejtioinjtihihjpinjtiotlbdctwd
        ur:envelope/oybttpcsksdkfekshsjnjojzihcxfejzihiajyjpiniahsjzcxfejtioinjtihihjpinjtiocxfwjlhsjpieasqdlbto
        """
        )
    }
    
    func testAssertionPredicateFind1() throws {
        let e = try pipe(["extract --wrapped", "assertion find predicate photo"], inputLine: credentialExample)
        XCTAssertEqual(e, "ur:envelope/oytpcsihjoisjljyjltpcsksckghisinjkcxinjkcxgehsjnihjkcxgthsksktihjzjzdijkcxjoisjljyjldmbaghdstp")
        XCTAssertEqual(try envelope(e), #""photo": "This is James Maxwell's photo.""#)
    }
    
    func testAssertionPredicateFind2() throws {
        let e = try pipe(["extract --wrapped", "assertion find predicate --known isA"], inputLine: credentialExample)
        XCTAssertEqual(e, "ur:envelope/oyadtpcskscffxihjpjyiniyiniahsjyihcxjliycxfxjljnjojzihjyinjljtwdiyftes")
        XCTAssertEqual(try envelope(e), #"'isA': "Certificate of Completion""#)
    }
    
    func testAssertionObjectFind1() throws {
        let e = try pipe(["extract --wrapped", "assertion find object Maxwell"], inputLine: credentialExample)
        XCTAssertEqual(e, "ur:envelope/oytpcsisjzhsjkjyglhsjnihtpcsiogthsksktihjzjzwshedtst")
        XCTAssertEqual(try envelope(e), #""lastName": "Maxwell""#)
    }
}
