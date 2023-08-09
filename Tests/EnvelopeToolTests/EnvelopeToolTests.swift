import XCTest
import WolfBase
import BCFoundation
import EnvelopeTool

let helloString = "Hello."
let helloEnvelopeUR = "ur:envelope/tpcsiyfdihjzjzjldmprrhtypk"
let cborArrayExample = CBOR.array([1, 2, 3]).cborData.hex
let uuidExample = "EB377E65-5774-410A-B9CB-510BFC73E6D9"
let cidExample = "dec7e82893c32f7a4fcec633c02c0ec32a4361ca3ee3bc8758ae07742e940550"
let dateExample = "2022-08-30T07:16:11Z"
let digestExample = Digest(helloString).ur.string
let seedURExample = "ur:crypto-seed/oyadgdaawzwplrbdhdpabgrnvokorolnrtemksayyadmut"
let aliceKnowsBobExample = "ur:envelope/lftpsptpcsihfpjziniaihtpspoytpsptpcsihjejtjlktjktpsptpcsiafwjlidbdgrvlwk"
let credentialExample = "ur:envelope/lstpsptpspmntpsptpcstansgshdcxfgkoiahtjthnissawsfhzcmyyldsutfzcttefpaxjtmobsbwimcaleykvsdtgajntpspoytpsptpcsjsiaihjpjyiniyiniahsjyihglkpjnidihjptpsptpcsjeeheyeodpeeecendpemetestpspoytpsptpcsjtihksjoinjphsjyinjljtfyhsjyihtpsptpcssecyjncscxaetpspoytpsptpcsisjzhsjkjyglhsjnihtpsptpcsiogthsksktihjzjztpspoytpsptpcsininjkjkkpihfyhsjyihtpsptpcssecyhybdvyaetpspoytpspadtpsptpcskscffxihjpjyiniyiniahsjyihcxjliycxfxjljnjojzihjyinjljttpspoytpsptpcsihjoisjljyjltpsptpcsksckghisinjkcxinjkcxgehsjnihjkcxgthsksktihjzjzdijkcxjoisjljyjldmtpspoytpsptpcskscejojpjliyihjkjkinjljthsjzfyihkoihjzjljojnihjtjyfdjlkpjpjktpsptpcsbstpspoytpsptpcsiniyinjpjkjyglhsjnihtpsptpcsihgehsjnihjktpspoytpsptpcsiyjyjljoiniajktpsptpcslfingukpidimihiajycxehingukpidimihiajycxeytpspoytpsptpcskscsiajljtjyinjtkpinjtiofeiekpiahsjyinjljtgojtinjyjktpsptpcsadtpspoytpspattpsptpcsksdkfekshsjnjojzihcxfejzihiajyjpiniahsjzcxfejtioinjtihihjpinjtiocxfwjlhsjpietpspoytpsptpcsiojkkpidimihiajytpsptpcskscegmfgcxhsjtiecxgtiniajpjlkthskoihcxfejtioinjtihihjpinjtiotpspoytpspbttpsptpcsksdkfekshsjnjojzihcxfejzihiajyjpiniahsjzcxfejtioinjtihihjpinjtiocxfwjlhsjpietpspoytpspaxtpsptpcstansghhdfzdlmunbknwymowslbwfkidawyastikibksfhdosgslulecpwktysphprdheingyckvlrtjlrdhswnkbdereotdryapyhddpmnahcsmymnlsmtpdadsptyptmdbyosdllotpspoytpspaatpsptpcsksdmguiniojtihiecxidkkcxfekshsjnjojzihcxfejzihiajyjpiniahsjzcxfejtioinjtihihjpinjtiocxfwjlhsjpiechvwnykg"
let keyExample = "ur:crypto-key/hdcxmszmjlfsgssrbzehsslphdlgtbwesofnlpehlftldwotpaiyfwbtzsykwttomsbatnzswlqd"

let aliceCID = "ur:crypto-cid/hdcxtygshybkzcecfhflpfdlhdonotoentnydmzsidmkindlldjztdmoeyishknybtbswtgwwpdi"
let aliceSeed = "ur:crypto-seed/oyadgdlfwfdwlphlfsghcphfcsaybekkkbaejkhphdfndy"
let alicePrvkeys = "ur:crypto-prvkeys/gdlfwfdwlphlfsghcphfcsaybekkkbaejksfnynsct"
let alicePubkeys = "ur:crypto-pubkeys/lftaaosehdcxwduymnadmebbgwlolfemsgotgdnlgdcljpntzocwmwolrpimdabgbaqzcscmzopftpvahdcxolgtwyjotsndgeechglgeypmoemtmdsnjzyncaidgrbklegopasbgmchidtdvsctwdpffsee"

let bobCID = "ur:crypto-cid/hdcxdkreprfslewefgdwhtfnaosfgajpehhyrlcyjzheurrtamfsvolnaxwkioplgansesiabtdr"
let bobSeed = "ur:crypto-seed/oyadgdcsknhkjkswgtecnslsjtrdfgimfyuykglfsfwtso"
let bobPrvkeys = "ur:crypto-prvkeys/gdcsknhkjkswgtecnslsjtrdfgimfyuykgbzbagdva"
let bobPubkeys = "ur:crypto-pubkeys/lftaaosehdcxpspsfsglwewlttrplbetmwaelkrkdeolylwsswchfshepycpzowkmojezmlehdentpvahdcxlaaybzfngdsbheeyvlwkrldpgocpgewpykneotlugaieidfplstacejpkgmhaxbkbswtmecm"

let carolCID = "ur:crypto-cid/hdcxamstktdsdlplurgaoxfxdijyjysertlpehwstkwkskmnnsqdpfgwlbsertvatbbtcaryrdta"
let carolSeed = "ur:crypto-seed/oyadgdlpjypepycsvodtihcecwvsyljlzevwcnmepllulo"
let carolPrvkeys = "ur:crypto-prvkeys/gdlpjypepycsvodtihcecwvsyljlzevwcnamjzdnos"
let carolPubkeys = "ur:crypto-pubkeys/lftaaosehdcxptwewyrttbfswnsonswdvweydkfxmwfejsmdlgbajyaymwhstotymyfwrosprhsstpvahdcxnnzeontnuechectylgjytbvlbkfnmsmyeohhvwbzftdwrplrpkptloctdtflwnguoyytemnn"

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
        let e = Envelope(.note, "This is a note.")
        let ur = e.ur.string

        let predicateEnvelope = "ur:envelope/aatljldnmw"
        let objectEnvelope = "ur:envelope/tpcsjlghisinjkcxinjkcxhscxjtjljyihdmbamnatmn"

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
        XCTAssertEqual(e, "ur:envelope/tpcslsadaoaxgedmotks")
        XCTAssertEqual(try envelope(e), "[1, 2, 3]")
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "83010203")
        
        let e2 = try envelope("subject --cbor", inputLine: cborArrayExample)
        XCTAssertEqual(e, e2)
    }
    
    func testCIDSubject() throws {
        let e = try envelope("subject --cid \(cidExample)")
        XCTAssertEqual(e, "ur:envelope/tpcstansgshdcxuestvsdemusrdlkngwtosweortdwbasrdrfxhssgfmvlrflthdplatjydmmwahgddrrlvarh")
        XCTAssertEqual(try envelope(e), "CID(\(cidExample.prefix(8)))")
        XCTAssertEqual(try envelope("extract --cid \(e)"), cidExample)
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
        XCTAssertEqual(try envelope("extract --cbor \(e)"), "d8c8d8186648656c6c6f2e")
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
        XCTAssertEqual(try envelope(e), "note")
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
        XCTAssertEqual(e, "ur:envelope/tpcstaaddwoyadgdaawzwplrbdhdpabgrnvokorolnrtemksidtbcxgu")
        XCTAssertEqual(try envelope(e),
            """
            crypto-seed(Map)
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
    
    func testAssertion() throws {
        let e = try envelope("subject assertion Alpha Beta")
        XCTAssertEqual(e, "ur:envelope/oytpsptpcsihfpjzjoishstpsptpcsiefwihjyhslkbwlswy")
        XCTAssertEqual(try envelope(e), #""Alpha": "Beta""#)
    }
    
    func testAssertion2() throws {
        let e = try envelope("subject assertion --number 1 --number 2")
        XCTAssertEqual(e, "ur:envelope/oytpsptpcsadtpsptpcsaorksbrhnb")
        XCTAssertEqual(try envelope(e), "1: 2")
    }
    
    func testAssertion3() throws {
        let e = try envelope("subject assertion --known note ThisIsANote.")
        XCTAssertEqual(e, "ur:envelope/oytpspaatpsptpcsjzghisinjkgajkfpgljljyihdmhkgtosrp")
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
        XCTAssertEqual(e, "ur:envelope/oytpsptpcsihjejtjlktjktpsptpcsiafwjlidgdzefrpd")
        XCTAssertEqual(try envelope(e), #""knows": "Bob""#)
    }

    func testAssertionAt2() throws {
        let e = try pipe(["extract --wrapped", "assertion at 12"], inputLine: credentialExample)
        XCTAssertEqual(try envelope(e), #"issuer: "Example Electrical Engineering Board""#)
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
        ur:envelope/oytpsptpcsjsiaihjpjyiniyiniahsjyihglkpjnidihjptpsptpcsjeeheyeodpeeecendpemetestlynfxcs
        ur:envelope/oytpsptpcsjtihksjoinjphsjyinjljtfyhsjyihtpsptpcssecyjncscxaekbhfbapf
        ur:envelope/oytpsptpcsisjzhsjkjyglhsjnihtpsptpcsiogthsksktihjzjzievtcplu
        ur:envelope/oytpsptpcsininjkjkkpihfyhsjyihtpsptpcssecyhybdvyaebwfsrnio
        ur:envelope/oytpspadtpsptpcskscffxihjpjyiniyiniahsjyihcxjliycxfxjljnjojzihjyinjljtwkbkdtde
        ur:envelope/oytpsptpcsihjoisjljyjltpsptpcsksckghisinjkcxinjkcxgehsjnihjkcxgthsksktihjzjzdijkcxjoisjljyjldmzofdswhk
        ur:envelope/oytpsptpcskscejojpjliyihjkjkinjljthsjzfyihkoihjzjljojnihjtjyfdjlkpjpjktpsptpcsbsftfgyaim
        ur:envelope/oytpsptpcsiniyinjpjkjyglhsjnihtpsptpcsihgehsjnihjktosrvehg
        ur:envelope/oytpsptpcsiyjyjljoiniajktpsptpcslfingukpidimihiajycxehingukpidimihiajycxeyihgteect
        ur:envelope/oytpsptpcskscsiajljtjyinjtkpinjtiofeiekpiahsjyinjljtgojtinjyjktpsptpcsadrpkekieh
        ur:envelope/oytpspattpsptpcsksdkfekshsjnjojzihcxfejzihiajyjpiniahsjzcxfejtioinjtihihjpinjtiocxfwjlhsjpiebdwlwetb
        ur:envelope/oytpsptpcsiojkkpidimihiajytpsptpcskscegmfgcxhsjtiecxgtiniajpjlkthskoihcxfejtioinjtihihjpinjtionddiqdwp
        ur:envelope/oytpspbttpsptpcsksdkfekshsjnjojzihcxfejzihiajyjpiniahsjzcxfejtioinjtihihjpinjtiocxfwjlhsjpietisaryfr
        """
        )
    }
    
    func testAssertionPredicateFind1() throws {
        let e = try pipe(["extract --wrapped", "assertion find predicate photo"], inputLine: credentialExample)
        XCTAssertEqual(e, "ur:envelope/oytpsptpcsihjoisjljyjltpsptpcsksckghisinjkcxinjkcxgehsjnihjkcxgthsksktihjzjzdijkcxjoisjljyjldmzofdswhk")
        XCTAssertEqual(try envelope(e), #""photo": "This is James Maxwell's photo.""#)
    }
    
    func testAssertionPredicateFind2() throws {
        let e = try pipe(["extract --wrapped", "assertion find predicate --known isA"], inputLine: credentialExample)
        XCTAssertEqual(e, "ur:envelope/oytpspadtpsptpcskscffxihjpjyiniyiniahsjyihcxjliycxfxjljnjojzihjyinjljtwkbkdtde")
        XCTAssertEqual(try envelope(e), #"isA: "Certificate of Completion""#)
    }
    
    func testAssertionObjectFind1() throws {
        let e = try pipe(["extract --wrapped", "assertion find object Maxwell"], inputLine: credentialExample)
        XCTAssertEqual(e, "ur:envelope/oytpsptpcsisjzhsjkjyglhsjnihtpsptpcsiogthsksktihjzjzievtcplu")
        XCTAssertEqual(try envelope(e), #""lastName": "Maxwell""#)
    }

    func testEnvelopeDigest() throws {
        let d = try envelope("digest \(aliceKnowsBobExample)")
        XCTAssertEqual(d, "ur:digest/hdcxldgouyhyadimzmpaeourhfsectvaskspdlotaxidiatbgydejnbwgskbhfrtwlwzneroatds")
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
        XCTAssertEqual(elided, "ur:envelope/lftpsptpcsihfpjziniaihtpspoytpsphdcxuykitdcegyinqzlrlgdrcwsbbkihcemtchsntabdpldtbzjepkwsrkdrlernykrdtpsptpcsiafwjlidlgtptsfr")
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
        XCTAssertEqual(elided, "ur:envelope/lftpsptpcsihfpjziniaihtpspoytpsphdcxuykitdcegyinqzlrlgdrcwsbbkihcemtchsntabdpldtbzjepkwsrkdrlernykrdtpsptpcsiafwjlidlgtptsfr")
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
        XCTAssertEqual(try UR(urString: cid1).type, "cid")
        
        let cid3 = try envelope("generate cid --hex d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f")
        XCTAssertEqual(cid3, "ur:cid/hdcxtygshybkzcecfhflpfdlhdonotoentnydmzsidmkindlldjztdmoeyishknybtbswtgwwpdi")
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
    
    func testSign() throws {
        let prvkeys = "ur:crypto-prvkeys/hdcxhsinuesrennenlhfaopycnrfrkdmfnsrvltowmtbmyfwdafxvwmthersktcpetdwfnbndeah"
        let signed = try envelope("sign \(aliceKnowsBobExample) --prvkeys \(prvkeys)")
        XCTAssertEqual(try envelope(signed),
        """
        "Alice" [
            "knows": "Bob"
            verifiedBy: Signature
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
            verifiedBy: Signature
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
            verifiedBy: Signature
            verifiedBy: Signature
        ]
        """
        )
    }

    func testSSKR1() throws {
        let result = try envelope("sskr split \(aliceKnowsBobExample)")
        XCTAssertEqual(try envelope(result),
        """
        ENCRYPTED [
            sskrShare: SSKRShare
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
