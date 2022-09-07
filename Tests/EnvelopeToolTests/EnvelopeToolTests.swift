import XCTest
import WolfBase
import BCFoundation
import EnvelopeTool

let helloString = "Hello."
let helloEnvelopeUR = "ur:envelope/tpuoiyfdihjzjzjldmgsgontio"
let cborArrayExample = CBOR.array([1, 2, 3]).cborEncode.hex
let uuidExample = "EB377E65-5774-410A-B9CB-510BFC73E6D9"
let cidExample = "dec7e82893c32f7a4fcec633c02c0ec32a4361ca3ee3bc8758ae07742e940550"
let dateExample = "2022-08-30T07:16:11Z"
let digestExample = Digest(helloString).ur.string
let customURExample = "ur:crypto-seed/oyadgdaawzwplrbdhdpabgrnvokorolnrtemksayyadmut"
let aliceKnowsBobExample = "ur:envelope/lftpsptpuoihfpjziniaihtpsptputlftpsptpuoihjejtjlktjktpsptpuoiafwjlidrdpdiesk"
let credentialExample = "ur:envelope/lstpsptpvtmntpsptpuotpsghdcxfgkoiahtjthnissawsfhzcmyyldsutfzcttefpaxjtmobsbwimcaleykvsdtgajntpsptputlftpsptpuoihjoisjljyjltpsptpuoksckghisinjkcxinjkcxgehsjnihjkcxgthsksktihjzjzdijkcxjoisjljyjldmtpsptputlftpsptpuoisjzhsjkjyglhsjnihtpsptpuoiogthsksktihjzjztpsptputlftpsptpuoininjkjkkpihfyhsjyihtpsptpuosecyhybdvyaetpsptputlftpsptpurattpsptpuoksdkfekshsjnjojzihcxfejzihiajyjpiniahsjzcxfejtioinjtihihjpinjtiocxfwjlhsjpietpsptputlftpsptpuoiyjyjljoiniajktpsptpuolfingukpidimihiajycxehingukpidimihiajycxeytpsptputlftpsptpuraotpsptpuokscffxihjpjyiniyiniahsjyihcxjliycxfxjljnjojzihjyinjljttpsptputlftpsptpuokscsiajljtjyinjtkpinjtiofeiekpiahsjyinjljtgojtinjyjktpsptpuozofhyaaeaeaeaeaeaetpsptputlftpsptpurbttpsptpuoksdkfekshsjnjojzihcxfejzihiajyjpiniahsjzcxfejtioinjtihihjpinjtiocxfwjlhsjpietpsptputlftpsptpuojtihksjoinjphsjyinjljtfyhsjyihtpsptpuosecyjncscxaetpsptputlftpsptpuojsiaihjpjyiniyiniahsjyihglkpjnidihjptpsptpuojeeheyeodpeeecendpemetestpsptputlftpsptpuoiniyinjpjkjyglhsjnihtpsptpuoihgehsjnihjktpsptputlftpsptpuoiojkkpidimihiajytpsptpuokscegmfgcxhsjtiecxgtiniajpjlkthskoihcxfejtioinjtihihjpinjtiotpsptputlftpsptpuokscejojpjliyihjkjkinjljthsjzfyihkoihjzjljojnihjtjyfdjlkpjpjktpsptpuobstpsptputlftpsptpuraxtpsptpuotpuehdfzftuyfsticwgdosgeswtswkbdosrecyesdeplqzjoghiogacedlqdsgtbpewtdroytlmdaavavsspiygmrflfgrkohtinvswykbkbpsyllbmhdyzerpemlsykvapkchbttpsptputlftpsptpuraatpsptpuoksdmguiniojtihiecxidkkcxfekshsjnjojzihcxfejzihiajyjpiniahsjzcxfejtioinjtihihjpinjtiocxfwjlhsjpiejprdstpa"
let keyExample = "ur:crypto-key/hdcxmszmjlfsgssrbzehsslphdlgtbwesofnlpehlftldwotpaiyfwbtzsykwttomsbatnzswlqd"

final class EnvelopeToolTests: XCTestCase {
    static override func setUp() {
        setUpTest()
    }

    func testInvalidCommand() throws {
        XCTAssertThrowsError(try envelope("unknownCommand"))
    }
    
    func testInvalidData() throws {
        XCTAssertThrowsError(try envelope("ur:crypto-seed/oyadgdtokgdpwkrsonfdltvdwttsnddneonbmdbntakkss"))
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
    
    func testExtractAssertionSubject() throws {
        let e = Envelope(predicate: .note, object: "This is a note.")
        let ur = e.ur.string

        let predicateEnvelope = "ur:envelope/tpuraakicmnbgu"
        let objectEnvelope = "ur:envelope/tpuojlghisinjkcxinjkcxhscxjtjljyihdmnygsmnhl"

        let predObj = try envelope("extract --assertion \(ur)")
        XCTAssertEqual(predObj,
            """
            \(predicateEnvelope)
            \(objectEnvelope)
            """
        )
        
        let parts = predObj.split(separator: "\n").map { String($0) }
        let parts2 = try parts.map { try Envelope(urString: String($0)).ur.string }
        XCTAssertEqual(parts†, parts2†)
        
        let pred = try envelope("extract --predicate \(ur)")
        XCTAssertEqual(pred, predicateEnvelope)
        let obj = try envelope("extract --object \(ur)")
        XCTAssertEqual(obj, objectEnvelope)
    }
    
    func testCBORSubject() throws {
        let e = try envelope("subject --cbor \(cborArrayExample)")
        XCTAssertEqual(e, "ur:envelope/tpuolsadaoaxhfrkweia")
        XCTAssertEqual(try envelope(e), "CBOR")
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "83010203")
        
        let e2 = try envelope("subject --cbor", inputLine: cborArrayExample)
        XCTAssertEqual(e, e2)
    }
    
    func testCIDSubject() throws {
        let e = try envelope("subject --cid \(cidExample)")
        XCTAssertEqual(e, "ur:envelope/tpuotpsghdcxuestvsdemusrdlkngwtosweortdwbasrdrfxhssgfmvlrflthdplatjydmmwahgdrytleywm")
        XCTAssertEqual(try envelope(e), "CID(\(cidExample))")
        XCTAssertEqual(try envelope("extract --cid \(e)"), cidExample)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "d8ca5820dec7e82893c32f7a4fcec633c02c0ec32a4361ca3ee3bc8758ae07742e940550")
    }
    
    func testWrappedEnvelopeSubject() throws {
        let e = try envelope("subject --wrapped \(helloEnvelopeUR)")
        XCTAssertEqual(e, "ur:envelope/tpvttpuoiyfdihjzjzjldmfxonfnpk")
        XCTAssertEqual(try envelope(e),
        """
        {
            "Hello."
        }
        """
        )
        XCTAssertEqual(try envelope("extract --wrapped \(e)"), helloEnvelopeUR)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "d8c8d8dc6648656c6c6f2e")
        XCTAssertEqual(try envelope("extract --ur \(e)"), helloEnvelopeUR)
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
        XCTAssertEqual(try envelope(e), "Digest(48df96ab531088a102eab64e0e7cdc259a8414396a0ce97b11ec98ca14c26d8c)")
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
    
    func testKnownPredicateSubject() throws {
        let value = "note"
        let e = try envelope("subject --known-predicate \(value)")
        XCTAssertEqual(e, "ur:envelope/tpuraakicmnbgu")
        XCTAssertEqual(try envelope(e), "note")
        XCTAssertEqual(try envelope("extract --known-predicate \(e)"), "note")
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "d8df04")
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
        XCTAssertEqual(e, "ur:envelope/tpvttpuoiyfdihjzjzjldmfxonfnpk")
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
    
    func testCustomURSubject() throws {
        let e = try envelope("subject --ur \(customURExample) --tag 300")
        XCTAssertEqual(e, "ur:envelope/tpuotaaddwoyadgdaawzwplrbdhdpabgrnvokorolnrtemksjztypkmh")
        XCTAssertEqual(try envelope(e),
            """
            CBOR
            """
        )
        XCTAssertEqual(try envelope("extract --ur \(e) --tag 300 --type crypto-seed"), customURExample)
    }
    
    func testUUIDSubject() throws {
        let e = try envelope("subject --uuid \(uuidExample)")
        XCTAssertEqual(e, "ur:envelope/tpuotpdagdwmemkbihhgjyfpbkrhsbgybdztjkvatatpsaztte")
        XCTAssertEqual(try envelope(e), "UUID(\(uuidExample))")
        XCTAssertEqual(try envelope("extract --uuid \(e)"), uuidExample)
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "d82550eb377e655774410ab9cb510bfc73e6d9")
    }
    
    func testAssertion() throws {
        let e = try envelope("subject assertion Alpha Beta")
        XCTAssertEqual(e, "ur:envelope/tputlftpsptpuoihfpjzjoishstpsptpuoiefwihjyhsaoadzcsn")
        XCTAssertEqual(try envelope(e), #""Alpha": "Beta""#)
    }
    
    func testAssertion2() throws {
        let e = try envelope("subject assertion --int 1 --int 2")
        XCTAssertEqual(e, "ur:envelope/tputlftpsptpuoadtpsptpuoaoiyjpzosr")
        XCTAssertEqual(try envelope(e), "1: 2")
    }
    
    func testAssertion3() throws {
        let e = try envelope("subject assertion --known-predicate note ThisIsANote.")
        XCTAssertEqual(e, "ur:envelope/tputlftpsptpuraatpsptpuojzghisinjkgajkfpgljljyihdmmdqdwsgt")
        XCTAssertEqual(try envelope(e), #"note: "ThisIsANote.""#)
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
        XCTAssertEqual(e, "ur:envelope/tputlftpsptpuoihjejtjlktjktpsptpuoiafwjlidztjlvyec")
        XCTAssertEqual(try envelope(e), #""knows": "Bob""#)
    }

    func testAssertionAt2() throws {
        let e = try pipe(["extract --wrapped", "assertion at 12"], inputLine: credentialExample)
        XCTAssertEqual(try envelope(e), #""professionalDevelopmentHours": 15"#)
    }

    func testAssertionAt3() throws {
        let e = try pipe(["extract --wrapped", "assertion at 12", "extract --predicate", "extract"], inputLine: credentialExample)
        XCTAssertEqual(e, "professionalDevelopmentHours")
    }

    func testAssertionAll() throws {
        let assertions = try pipe(["extract --wrapped", "assertion all"], inputLine: credentialExample)
        XCTAssertEqual(assertions,
        """
        ur:envelope/tputlftpsptpuoihjoisjljyjltpsptpuoksckghisinjkcxinjkcxgehsjnihjkcxgthsksktihjzjzdijkcxjoisjljyjldmmkiohphn
        ur:envelope/tputlftpsptpuoisjzhsjkjyglhsjnihtpsptpuoiogthsksktihjzjzaaaybway
        ur:envelope/tputlftpsptpuoininjkjkkpihfyhsjyihtpsptpuosecyhybdvyaelgfncypm
        ur:envelope/tputlftpsptpurattpsptpuoksdkfekshsjnjojzihcxfejzihiajyjpiniahsjzcxfejtioinjtihihjpinjtiocxfwjlhsjpiemkcwleby
        ur:envelope/tputlftpsptpuoiyjyjljoiniajktpsptpuolfingukpidimihiajycxehingukpidimihiajycxeymwnsylox
        ur:envelope/tputlftpsptpuraotpsptpuokscffxihjpjyiniyiniahsjyihcxjliycxfxjljnjojzihjyinjljtzspfltol
        ur:envelope/tputlftpsptpuokscsiajljtjyinjtkpinjtiofeiekpiahsjyinjljtgojtinjyjktpsptpuozofhyaaeaeaeaeaeaespmeplce
        ur:envelope/tputlftpsptpurbttpsptpuoksdkfekshsjnjojzihcxfejzihiajyjpiniahsjzcxfejtioinjtihihjpinjtiocxfwjlhsjpiefxdytnzt
        ur:envelope/tputlftpsptpuojtihksjoinjphsjyinjljtfyhsjyihtpsptpuosecyjncscxaenybkvwsf
        ur:envelope/tputlftpsptpuojsiaihjpjyiniyiniahsjyihglkpjnidihjptpsptpuojeeheyeodpeeecendpemetesbsmscfcy
        ur:envelope/tputlftpsptpuoiniyinjpjkjyglhsjnihtpsptpuoihgehsjnihjkgdsafznt
        ur:envelope/tputlftpsptpuoiojkkpidimihiajytpsptpuokscegmfgcxhsjtiecxgtiniajpjlkthskoihcxfejtioinjtihihjpinjtionbhfltlr
        ur:envelope/tputlftpsptpuokscejojpjliyihjkjkinjljthsjzfyihkoihjzjljojnihjtjyfdjlkpjpjktpsptpuobsnbidkihy
        """
        )
    }
    
    func testAssertionPredicateFind1() throws {
        let e = try pipe(["extract --wrapped", "assertion find predicate photo"], inputLine: credentialExample)
        XCTAssertEqual(e, "ur:envelope/tputlftpsptpuoihjoisjljyjltpsptpuoksckghisinjkcxinjkcxgehsjnihjkcxgthsksktihjzjzdijkcxjoisjljyjldmmkiohphn")
        XCTAssertEqual(try envelope(e), #""photo": "This is James Maxwell's photo.""#)
    }
    
    func testAssertionPredicateFind2() throws {
        let e = try pipe(["extract --wrapped", "assertion find predicate --known-predicate isA"], inputLine: credentialExample)
        XCTAssertEqual(e, "ur:envelope/tputlftpsptpuraotpsptpuokscffxihjpjyiniyiniahsjyihcxjliycxfxjljnjojzihjyinjljtzspfltol")
        XCTAssertEqual(try envelope(e), #"isA: "Certificate of Completion""#)
    }
    
    func testAssertionObjectFind1() throws {
        let e = try pipe(["extract --wrapped", "assertion find object Maxwell"], inputLine: credentialExample)
        XCTAssertEqual(e, "ur:envelope/tputlftpsptpuoisjzhsjkjyglhsjnihtpsptpuoiogthsksktihjzjzaaaybway")
        XCTAssertEqual(try envelope(e), #""lastName": "Maxwell""#)
    }

    func testEnvelopeDigest() throws {
        let d = try envelope("digest \(aliceKnowsBobExample)")
        XCTAssertEqual(d, "ur:crypto-digest/hdcxvwgtjltemnnlgmwttslynblpgamugszmtdlkmnckwkatmelbpdwljnynnehedrmhnnlfmthl")
    }
    
    func testElide1() throws {
        var target: [String] = []
        // Top level
        target.append(try envelope("digest \(aliceKnowsBobExample)"))
        // Subject
        target.append(try pipe(["extract --envelope \(aliceKnowsBobExample)", "digest"]))
        // Assertion
        let assertion = try envelope("assertion at 0 \(aliceKnowsBobExample)")
        target.append(try envelope("digest \(assertion)"))
        // Object
        let object = try envelope("extract --object \(assertion)")
        target.append(try envelope("digest \(object)"))

        let digests = target.joined(separator: " ")
        let elided = try envelope("elide \(aliceKnowsBobExample) \(digests)")
        XCTAssertEqual(elided, "ur:envelope/lftpsptpuoihfpjziniaihtpsptputlftpsptpsbhdcxjomotbcxaosrtiwfspldahlamovamehppmmhmyaxdsfndpsocwzeolzcmnvadlpytpsptpuoiafwjlidmddagond")
        XCTAssertEqual(try envelope(elided),
        """
        "Alice" [
            ELIDED: "Bob"
        ]
        """
        )
    }
    
    func testElide2() throws {
        var target: [String] = []
        target.append(try pipe(["subject knows", "digest"]))
        let digests = target.joined(separator: " ")
        let elided = try envelope("elide removing \(aliceKnowsBobExample) \(digests)")
        XCTAssertEqual(elided, "ur:envelope/lftpsptpuoihfpjziniaihtpsptputlftpsptpsbhdcxjomotbcxaosrtiwfspldahlamovamehppmmhmyaxdsfndpsocwzeolzcmnvadlpytpsptpuoiafwjlidmddagond")
        XCTAssertEqual(try envelope(elided),
        """
        "Alice" [
            ELIDED: "Bob"
        ]
        """
        )
    }
    
    func testGenerateKey() throws {
        let key1 = try envelope("generate key")
        let key2 = try envelope("generate key")
        XCTAssertNotEqual(key1, key2)
        XCTAssertEqual(try UR(urString: key1).type, "crypto-key")
    }
    
    func testGenerateCID() throws {
        let cid1 = try envelope("generate cid")
        let cid2 = try envelope("generate cid")
        XCTAssertNotEqual(cid1, cid2)
        XCTAssertEqual(try UR(urString: cid1).type, "crypto-cid")
    }
    
    func testGenerateSeed() throws {
        let seed1 = try envelope("generate seed")
        let seed2 = try envelope("generate seed")
        XCTAssertNotEqual(seed1, seed2)
        XCTAssertEqual(try UR(urString: seed1).type, "crypto-seed")
    }

    func testEncrypt() throws {
        let encrypted = try envelope("encrypt \(aliceKnowsBobExample) \(keyExample)")
        XCTAssertEqual(try envelope(encrypted),
        """
        EncryptedMessage [
            "knows": "Bob"
        ]
        """
        )
        let decrypted = try envelope("decrypt \(encrypted) \(keyExample)")
        XCTAssertEqual(decrypted, aliceKnowsBobExample)
    }
}
