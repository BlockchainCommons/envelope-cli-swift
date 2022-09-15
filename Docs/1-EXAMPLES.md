# envelope - Examples

## Common structures used by the examples

These examples define a common plaintext, and `CID`s and `PrivateKeyBase` objects for *Alice*, *Bob*, *Carol*, *ExampleLedger*, and *The State of Example*, each with a corresponding `PublicKeyBase`.

```bash
PLAINTEXT_HELLO="Hello."

ALICE_CID="ur:crypto-cid/hdcxtygshybkzcecfhflpfdlhdonotoentnydmzsidmkindlldjztdmoeyishknybtbswtgwwpdi"
ALICE_SEED="ur:crypto-seed/oyadgdlfwfdwlphlfsghcphfcsaybekkkbaejkhphdfndy"
ALICE_PRVKEYS="ur:crypto-prvkeys/gdlfwfdwlphlfsghcphfcsaybekkkbaejksfnynsct"
ALICE_PUBKEYS="ur:crypto-pubkeys/lftaaosehdcxwduymnadmebbgwlolfemsgotgdnlgdcljpntzocwmwolrpimdabgbaqzcscmzopftpvahdcxolgtwyjotsndgeechglgeypmoemtmdsnjzyncaidgrbklegopasbgmchidtdvsctwdpffsee"

BOB_CID="ur:crypto-cid/hdcxdkreprfslewefgdwhtfnaosfgajpehhyrlcyjzheurrtamfsvolnaxwkioplgansesiabtdr"
BOB_SEED="ur:crypto-seed/oyadgdcsknhkjkswgtecnslsjtrdfgimfyuykglfsfwtso"
BOB_PRVKEYS="ur:crypto-prvkeys/gdcsknhkjkswgtecnslsjtrdfgimfyuykgbzbagdva"
BOB_PUBKEYS="ur:crypto-pubkeys/lftaaosehdcxpspsfsglwewlttrplbetmwaelkrkdeolylwsswchfshepycpzowkmojezmlehdentpvahdcxlaaybzfngdsbheeyvlwkrldpgocpgewpykneotlugaieidfplstacejpkgmhaxbkbswtmecm"

CAROL_CID="ur:crypto-cid/hdcxamstktdsdlplurgaoxfxdijyjysertlpehwstkwkskmnnsqdpfgwlbsertvatbbtcaryrdta"
CAROL_SEED="ur:crypto-seed/oyadgdlpjypepycsvodtihcecwvsyljlzevwcnmepllulo"
CAROL_PRVKEYS="ur:crypto-prvkeys/gdlpjypepycsvodtihcecwvsyljlzevwcnamjzdnos"
CAROL_PUBKEYS="ur:crypto-pubkeys/lftaaosehdcxptwewyrttbfswnsonswdvweydkfxmwfejsmdlgbajyaymwhstotymyfwrosprhsstpvahdcxnnzeontnuechectylgjytbvlbkfnmsmyeohhvwbzftdwrplrpkptloctdtflwnguoyytemnn"
```

## Example 1: Plaintext

In this example no signing or encryption is performed.

Alice sends a plaintext message to Bob.

```bash
$ HELLO_ENVELOPE=`envelope subject $PLAINTEXT_HELLO`
$ echo $HELLO_ENVELOPE
```

```
ur:envelope/tpuoiyfdihjzjzjldmgsgontio
```

Alice ➡️ ☁️ ➡️ Bob

Bob receives the envelope and reads the message.

```bash
$ envelope extract $HELLO_ENVELOPE
```

```
Hello.
```

## Example 2: Signed Plaintext

This example demonstrates the signature of a plaintext message.

Alice sends a signed plaintext message to Bob.

```bash
$ SIGNED_ENVELOPE=`envelope subject $PLAINTEXT_HELLO | envelope sign --prvkeys $ALICE_PRVKEYS`
$ echo $SIGNED_ENVELOPE
```

```
ur:envelope/lftpsptpuoiyfdihjzjzjldmtpsptputlftpsptpuraxtpsptpuotpuehdfzsbiyvtkomosbfnrftamhtegmkiwlgwnsmdctrsptmeltdeclkometyfxcmchfmtkchmyueckzepsjefdayayoevotddpatlrehuyvwwphhosehlphnsgwnksnefxsptbgrhtlrmo
```

Alice ➡️ ☁️ ➡️ Bob

Bob receives the envelope and examines its contents.

```bash
$ envelope $SIGNED_ENVELOPE
```

```
"Hello." [
    verifiedBy: Signature
]
```

Bob verifies Alice's signature. Note that no output is generated on success.

```bash
$ envelope verify $SIGNED_ENVELOPE --pubkeys $ALICE_PUBKEYS
```

Bob extracts the message.

```bash
$ envelope extract $SIGNED_ENVELOPE
```

```
Hello.
```

Confirm that it wasn't signed by Carol. Note that a failed verification results in an error condition.

```bash
$ envelope verify $SIGNED_ENVELOPE --pubkeys $CAROL_PUBKEYS
```

```
Error: unverifiedSignature
```

Confirm that it was signed by Alice OR Carol.

```bash
$ envelope verify $SIGNED_ENVELOPE --threshold 1 --pubkeys $ALICE_PUBKEYS --pubkeys $CAROL_PUBKEYS
```

Confirm that it was not signed by Alice AND Carol.

```bash
$ envelope verify $SIGNED_ENVELOPE --threshold 2 --pubkeys $ALICE_PUBKEYS --pubkeys $CAROL_PUBKEYS
```

```
Error: unverifiedSignature
```

## Example 3: Multisigned Plaintext

This example demonstrates a plaintext message signed by more than one party.

Alice and Carol jointly send a signed plaintext message to Bob.

```bash
$ MULTISIGNED_ENVELOPE=`envelope subject $PLAINTEXT_HELLO | envelope sign --prvkeys $ALICE_PRVKEYS --prvkeys $CAROL_PRVKEYS`
$ echo $MULTISIGNED_ENVELOPE
```

```
ur:envelope/lstpsptpuoiyfdihjzjzjldmtpsptputlftpsptpuraxtpsptpuotpuehdfzfrosjsspcprhgwvtzcuofxtskkwppmsgfretrdcshhylfnlssnfgfykssntkihjoltsthhtoatfelpprzthyiywntbbygurtinltlbemhhtspycwwfdiwpplfnfxdkimtpsptputlftpsptpuraxtpsptpuotpuehdfzhpfyetcsbnrljokbvyoyhfbyaskowlbzzmjoykatrftevazsrymtjytkjolndnaalsfzleeennmnemmudsmtaoclhhemotqzskzofhseutjttkwfbtwnihfxzoehhfbntdetsgns
```

Alice & Carol ➡️ ☁️ ➡️ Bob

Bob receives the envelope and examines its contents.

```bash
$ envelope $MULTISIGNED_ENVELOPE
```

```
"Hello." [
    verifiedBy: Signature
    verifiedBy: Signature
]
```

Bob verifies the message was signed by both Alice and Carol.

```bash
$ envelope verify $MULTISIGNED_ENVELOPE --pubkeys $ALICE_PUBKEYS --pubkeys $CAROL_PUBKEYS
```

Bob extracts the message.

```bash
$ envelope extract $MULTISIGNED_ENVELOPE
```

```
Hello.
```

## Example 4: Symmetric Encryption

This examples debuts the idea of an encrypted message, based on a symmetric key shared between two parties.

Alice and Bob have agreed to use this key:

```bash
$ KEY=`envelope generate key`
$ echo $KEY
```

```
ur:crypto-key/hdcxpldtfesnclpdzodttohtmsdedebezodsosmodpdrhtpfqdnlwkimlbcwtbzmteeezotaengs
```

Alice sends a message encrypted with the key to Bob.

```bash
$ ENCRYPTED_ENVELOPE=`envelope subject $PLAINTEXT_HELLO | envelope encrypt --key $KEY`
$ echo $ENCRYPTED_ENVELOPE
```

```
ur:envelope/tpsolrgakoidaygmmtoyhggscmgshtfwtlvskirndswzvokslswdgdkorlndeegswdtkehnefsbngtmdykbefdhddktpsbhdcxloimbnlplsdloycftluoftcfguayrsbwghlbctcmplwteyynsawsnlbgsnhkmovwfysesnfl
```

Alice ➡️ ☁️ ➡️ Bob

Bob receives the envelope and examines its contents.

```bash
$ envelope $ENCRYPTED_ENVELOPE
```

```
EncryptedMessage
```

Bob decrypts the message and extracts its subject.

```bash
$ DECRYPTED=`envelope decrypt $ENCRYPTED_ENVELOPE --key $KEY`
$ envelope extract $DECRYPTED
```

```
Hello.
```

Can't read with incorrect key.

```bash
$ envelope decrypt $ENCRYPTED_ENVELOPE --key `envelope generate key`
```

```
Error: invalidKey
```

## Example 5: Sign-Then-Encrypt

This example combines the previous ones, first signing, then encrypting a message with a symmetric key.

Alice and Bob have agreed to use this key.

```bash
$ KEY=`envelope generate key`
$ echo $KEY
```

```
ur:crypto-key/hdcxpldtfesnclpdzodttohtmsdedebezodsosmodpdrhtpfqdnlwkimlbcwtbzmteeezotaengs
```

Alice signs a plaintext message, wraps it so her signature will also be encrypted, then encrypts it.

```bash
$ SIGNED_ENCRYPTED=`envelope subject $PLAINTEXT_HELLO | envelope sign --prvkeys $ALICE_PRVKEYS | envelope subject --wrapped | envelope encrypt --key $KEY`
$ echo $SIGNED_ENCRYPTED
ur:envelope/tpsolrhdhngoimhylfqzeyiehfmketmtaetlfydihhknrkntldyanydeehbynsvolfzsgmjemsjpqdssmnsfsolbvllnpkguckhpktisytvlbaftahzsahktlnwpdrottecwihgsttvobwdyyamsremnrydtnbhlcyrlfstidacfdegdksztjlgultdirkrkrlwzvdwtwkgstezsemeniooerngdbbayqdykgdwkisidrogwrnghgrmolypktafdjokgonhddktpsbhdcxwfurtouypmlpbysnbwftrdghbypscwsohhmwcsnncwtyjnuowyfgkeadmdrpbncljypketpk
```

Alice ➡️ ☁️ ➡️ Bob

Bob receives the envelope, and examines its contents.

```bash
$ envelope $SIGNED_ENCRYPTED
```

```
EncryptedMessage
```

Bob decrypts it using the shared key, and then examines the decrypted envelope's contents.

```bash
$ DECRYPTED=`envelope decrypt $SIGNED_ENCRYPTED --key $KEY`
$ envelope $DECRYPTED
```

```
{
    "Hello." [
        verifiedBy: Signature
    ]
}
```

Bob unwraps the inner envelope, verifies Alice's signature, and then extracts the message.

```bash
$ envelope extract --wrapped $DECRYPTED | envelope verify --pubkeys $ALICE_PUBKEYS | envelope extract
```

```
Hello.
```

Attempting to verify the wrong key exits with an error.

```bash
$ envelope extract --wrapped $DECRYPTED | envelope verify --pubkeys $CAROL_PUBKEYS
Error: unverifiedSignature
```

## Example 6: Encrypt-Then-Sign

It doesn't actually matter whether the `encrypt` or `sign` command comes first, as the `encrypt` command transforms the subject into its encrypted form, which carries a digest of the plaintext subject, while the `sign` command only adds an assertion with the signature of the hash as the object of the assertion.

Similarly, the `decrypt` method used below can come before or after the `verify` command, as `verify` checks the signature against the subject's digest, which is explicitly present when the subject is in encrypted form and can be calculated when the subject is in plaintext form. The `decrypt` command transforms the subject from its encrypted form to its plaintext form, and also checks that the decrypted plaintext has the same hash as the one associated with the encrypted subject.

The end result is the same: the subject is encrypted and the signature can be checked before or after decryption.

The main difference between this order of operations and the sign-then-encrypt order of operations is that with sign-then-encrypt, the decryption *must* be performed first before the presence of signatures can be known or checked. With this order of operations, the presence of signatures is known before decryption, and may be checked before or after decryption.

Alice and Bob have agreed to use this key.

```bash
$ KEY=`envelope generate key`
$ echo $KEY
```

```
ur:crypto-key/hdcxpldtfesnclpdzodttohtmsdedebezodsosmodpdrhtpfqdnlwkimlbcwtbzmteeezotaengs
```

Alice encrypts a plaintext message, then signs it.

```bash
$ ENCRYPTED_SIGNED=`envelope subject $PLAINTEXT_HELLO | envelope encrypt --key $KEY | envelope sign --prvkeys $ALICE_PRVKEYS`
$ echo $ENCRYPTED_SIGNED
ur:envelope/lftpsptpsolrgazeclldzttkhkinjpbzgsdewydyhsgmdihdzezmlgvwrlgdtlemtylekgpywttbssbwwktlgrbsytkbhddktpsbhdcxloimbnlplsdloycftluoftcfguayrsbwghlbctcmplwteyynsawsnlbgsnhkmovwtpsptputlftpsptpuraxtpsptpuotpuehdfznlrkpdsoahgsdmjtltsakgltnbjyjsbajlpyswhnguwlzsfnwmnbvopdeckbamrybtweolpyhlwdjptoethpgaolidkgbzhhuotbyagogubattstjytnehsebsgrnyytnbtpflox
```

Alice ➡️ ☁️ ➡️ Bob

Bob receives the envelope and examines its contents.

```bash
$ envelope $ENCRYPTED_SIGNED
```

```
EncryptedMessage [
    verifiedBy: Signature
]
```

Bob verifies Alice's signature, decrypts the message, then extracts the message.

```bash
$ envelope verify $ENCRYPTED_SIGNED --pubkeys $ALICE_PUBKEYS |\
    envelope decrypt --key $KEY |\
    envelope extract
```

```
Hello.
```

## Example 7: Multi-Recipient Encryption

This example demonstrates an encrypted message sent to multiple parties.

Alice encrypts a message so that it can only be decrypted by Bob or Carol.

```bash
$ ENVELOPE_TO=`envelope subject $PLAINTEXT_HELLO | envelope encrypt --recipient $BOB_PUBKEYS --recipient $CAROL_PUBKEYS`
$ echo $ENVELOPE_TO
```

```
ur:envelope/lstpsptpsolrgafdskfwckcehhfdbakkgsswdkadrldrhnprrnlrhnahcygdcecsskzslttldkvyrpdednbgpsgenyoxhddktpsbhdcxloimbnlplsdloycftluoftcfguayrsbwghlbctcmplwteyynsawsnlbgsnhkmovwtpsptputlftpsptpurahtpsptpuotptklftpsolshddksomdnsksjlktcfplislknstyfmfyvwwfkkvtsoiacffyutihbwcevondjteyenuoftmtjopfgskigdmsmsyaflflntjlrozefdgdfrrelsckbylsylmersqdiacehefdiylstpvahdcxsfldltynjyprvdadrnemdmbwrfkkcnbdluglrlghgyrsmomocsrpmkoymttaeyentpsptputlftpsptpurahtpsptpuotptklftpsolshddkmhndecotaekkchlscsvlfzrlmefdsrvehdgagsisfxgawzrdkgcwrlvdzocfhylewksscyksgsemgohgmsvsiafsspvovogwbtgdhkcpdnrlgltkylaxctwsoydimocnoemttpvahdcxktinfeidjkndgdykylbdnyiosgadknksrduevwiawlfpzctiwkldgwglmywfmwaerooltigo
```

Alice ➡️ ☁️ ➡️ Bob

Alice ➡️ ☁️ ➡️ Carol

Bob receives the envelope and examines its structure:

```bash
$ envelope $ENVELOPE_TO
```

```
EncryptedMessage [
    hasRecipient: SealedMessage
    hasRecipient: SealedMessage
]
```

Bob decrypts and reads the message.

```bash
$ envelope decrypt $ENVELOPE_TO --recipient $BOB_PRVKEYS | envelope extract
```

```
Hello.
```

Carol decrypts and reads the message.

```bash
$ envelope decrypt $ENVELOPE_TO --recipient $CAROL_PRVKEYS | envelope extract
```

```
Hello.
```

Alice didn't encrypt it to herself, so she can't read it.

```bash
$ envelope decrypt $ENVELOPE_TO --recipient $ALICE_PRVKEYS
```

```
Error: invalidRecipient
```

## Example 8: Signed Multi-Recipient Encryption

This example demonstrates a signed, then encrypted message, sent to multiple parties.

Alice signs a message, and then encrypts it so that it can only be decrypted by Bob or Carol.

```bash
$ ENVELOPE_SIGNED_TO=`envelope subject $PLAINTEXT_HELLO | envelope sign --prvkeys $ALICE_PRVKEYS | envelope encrypt --recipient $BOB_PUBKEYS --recipient $CAROL_PUBKEYS`
$ echo $ENVELOPE_SIGNED_TO
```

```
ur:envelope/lrtpsptpsolrgrjtaodrenvetanskgmsgrvogsfhaecnnbvtjyrepmmsrnfthggdykwntpylvydsztiahnbdcfgtvykkbyimhddktpsbhdcxloimbnlplsdloycftluoftcfguayrsbwghlbctcmplwteyynsawsnlbgsnhkmovwtpsptputlftpsptpuraxtpsptpuotpuehdfzcfmtpyhpdslbltvlursgltaemyglcwjsrhonptsrfxvavefwvoeowmmsnbytbefmttdsiecylthkpkpmjkdypmsenewlltjkbaftlawllyrngtlaltbdrfgaqzztsrkitpsptputlftpsptpurahtpsptpuotptklftpsolshddklgbelgjpbsmuktsolkclehltcyynamenvybdkotdeybwnbskdmrnkegdhywmwnkobgfzcwltgsotcawlclfwidmwjepyztdpbtgdsgmhtbdispptvostaslbtemngsynrltotpvahdcxtdcmonmtbdzsgdhgfhbskgashylnrecastwpvladmkcmfzhyeniylrjpbahshsistpsptputlftpsptpurahtpsptpuotptklftpsolshddkskftrowdgyiohedpadfrayfnlgvsvyfdjtrklyuoamdeceimhfkbrhntbejsfhaybekpzcchgsotuynstepfroahknrtosuomhgdynrlfdfgtdbewpfzbwmnwmfhhhielpdrtpvahdcxaoyawdgtlejzfydettkssodnpksgvwpaztvdprsroetyfpdehdcxlpfmstoemtfrbspmqzlb
```

Alice ➡️ ☁️ ➡️ Bob

Alice ➡️ ☁️ ➡️ Carol

Bob receives the envelope and examines its structure:

```bash
$ envelope $ENVELOPE_SIGNED_TO
```

```
EncryptedMessage [
    hasRecipient: SealedMessage
    hasRecipient: SealedMessage
    verifiedBy: Signature
]
```

Bob verifies Alice's signature, then decrypts and reads the message

```bash
$ envelope verify $ENVELOPE_SIGNED_TO --pubkeys $ALICE_PUBKEYS | envelope decrypt --recipient $BOB_PRVKEYS | envelope extract
```

```
Hello.
```

## Example 9: Sharding a Secret using SSKR

This example demonstrates the use of SSKR to shard a symmetric key that encrypted a message. The shares are then enclosed in individual envelopes and the seed can be recovered from those shares, allowing the future decryption of the message.

Dan has a cryptographic seed he wants to backup using a social recovery scheme. The seed includes metadata he wants to back up also, making it too large to fit into a basic SSKR share.

```bash
$ DAN_SEED=ur:crypto-seed/oxadgdhkwzdtfthptokigtvwnnjsqzcxknsktdaosezofptpbtlnlyjzkefmaxkpfyhsjpjecxgdkpjpjojzihcxfpjskphscxgsjlkoihaakskggsjljpihjncxinjojkkpjncxiejljzjljpcxjkinjycxhsjnihjydwcxiajljtjkihiajyihjykpjpcxhsieinjoinjkiainjtiocxihjzinjydwcxjkihiecxiejlcxihinkpjkjnjliecxjyihjnjojljpcxinjtiainieiniekpjtjycxkpjycxjzhsidjljpihcxihjycxiejljzjljpihcxjnhsiojthscxhsjzinjskphsdmluwmoxny
```

Dan encloses his seed in an envelope.

```bash
$ DAN_ENVELOPE=`envelope subject --ur $DAN_SEED`
$ echo $DAN_ENVELOPE
```

```
ur:envelope/tpuotaaddwoxadgdhkwzdtfthptokigtvwnnjsqzcxknsktdaosezofptpbtlnlyjzkefmaxkpfyhsjpjecxgdkpjpjojzihcxfpjskphscxgsjlkoihaakskggsjljpihjncxinjojkkpjncxiejljzjljpcxjkinjycxhsjnihjydwcxiajljtjkihiajyihjykpjpcxhsieinjoinjkiainjtiocxihjzinjydwcxjkihiecxiejlcxihinkpjkjnjliecxjyihjnjojljpcxinjtiainieiniekpjtjycxkpjycxjzhsidjljpihcxihjycxiejljzjljpihcxjnhsiojthscxhsjzinjskphsdmaygebzlg
```

Dan examines the contents of his envelope.

```bash
$ envelope $DAN_ENVELOPE
```

```
CBOR(crypto-seed)
```

Dan splits the envelope into a single group 2-of-3. The output of the `envelope` tool contains one share envelope per line. He then pipes this output into some Shell magic (zsh in this case) that assigns the lines of output to a shell array.

```bash
$ envelope sskr split -g 2-of-3 $DAN_ENVELOPE | IFS=$'\n' read -r -d '' -A SHARE_ENVELOPES < <( COMMAND && printf '\0' )
```

Dan sends one envelope to each of Alice, Bob, and Carol.

```bash
$ SHARE_ENVELOPE_ALICE=${SHARE_ENVELOPES[1]}
$ SHARE_ENVELOPE_BOB=${SHARE_ENVELOPES[2]}
$ SHARE_ENVELOPE_CAROL=${SHARE_ENVELOPES[3]}
```

Dan ➡️ ☁️ ➡️ Alice, Bob, Carol

Bob examines the contents of his envelope, but can't recover the original seed.

```bash
$ envelope $SHARE_ENVELOPE_BOB
```

```
EncryptedMessage [
    sskrShare: SSKRShare
]
```

By himself, Bob can't recover the seed.

```bash
$ envelope sskr join $SHARE_ENVELOPE_BOB
```

```
Error: invalidShares
```

At some future point, Dan retrieves two of the three envelopes so he can recover his seed.

```bash
$ envelope sskr join $SHARE_ENVELOPE_BOB $SHARE_ENVELOPE_CAROL | envelope extract --ur
```

```
ur:crypto-seed/oxadgdhkwzdtfthptokigtvwnnjsqzcxknsktdaosezofptpbtlnlyjzkefmaxkpfyhsjpjecxgdkpjpjojzihcxfpjskphscxgsjlkoihaakskggsjljpihjncxinjojkkpjncxiejljzjljpcxjkinjycxhsjnihjydwcxiajljtjkihiajyihjykpjpcxhsieinjoinjkiainjtiocxihjzinjydwcxjkihiecxiejlcxihinkpjkjnjliecxjyihjnjojljpcxinjtiainieiniekpjtjycxkpjycxjzhsidjljpihcxihjycxiejljzjljpihcxjnhsiojthscxhsjzinjskphsdmluwmoxny
```

## Example 10: Complex Metadata

Complex, tiered metadata can be added to an envelope.

Assertions made about an CID are considered part of a distributed set. Which assertions are returned depends on who resolves the CID and when it is resolved. In other words, the referent of a CID is mutable.

In this example, we use CIDs to represent an author, whose known works may change over time, and a particular novel written by her, the data returned about which may change over time.

Start by creating an envelope that represents the author and what is known about her, including where to get more information using the author's CID.

```bash
$ AUTHOR=`envelope generate cid --hex 9c747ace78a4c826392510dd6285551e7df4e5164729a1b36198e56e017666c8 | \
    envelope subject --ur | \
    envelope assertion --known-predicate dereferenceVia LibraryOfCongress | \
    envelope assertion --known-predicate hasName "Ayn Rand"`
$ envelope $AUTHOR
```

```
CID(9c747ace78a4c826392510dd6285551e7df4e5164729a1b36198e56e017666c8) [
    dereferenceVia: "LibraryOfCongress"
    hasName: "Ayn Rand"
]
```

Create two envelopes representing the name of the novel in two different languages, annotated with assertions that specify the language.

```bash
$ NAME_EN=`envelope subject "Atlas Shrugged" | \
    envelope assertion --known-predicate language en`
$ envelope $NAME_EN
```

```
"Atlas Shrugged" [
    language: "en"
]
```

```bash
$ NAME_ES=`envelope subject "La rebelión de Atlas" | \
    envelope assertion --known-predicate language es`
$ envelope $NAME_ES
```

```
"La rebelión de Atlas" [
    language: "es"
]
```

Create an envelope that specifies known information about the novel. This envelope embeds the previous envelopes we created for the author and the names of the work.

```bash
$ WORK=`envelope generate cid --hex 7fb90a9d96c07f39f75ea6acf392d79f241fac4ec0be2120f7c82489711e3e80 | \
    envelope subject --ur | \
    envelope assertion --known-predicate isA novel | \
    envelope assertion isbn "9780451191144" | \
    envelope assertion --string author --envelope $AUTHOR | \
    envelope assertion --known-predicate dereferenceVia "LibraryOfCongress" | \
    envelope assertion --known-predicate hasName --envelope $NAME_EN | \
    envelope assertion --known-predicate hasName --envelope $NAME_ES`
$ envelope $WORK
```

```
CID(7fb90a9d96c07f39f75ea6acf392d79f241fac4ec0be2120f7c82489711e3e80) [
    "author": CID(9c747ace78a4c826392510dd6285551e7df4e5164729a1b36198e56e017666c8) [
        dereferenceVia: "LibraryOfCongress"
        hasName: "Ayn Rand"
    ]
    "isbn": "9780451191144"
    dereferenceVia: "LibraryOfCongress"
    hasName: "Atlas Shrugged" [
        language: "en"
    ]
    hasName: "La rebelión de Atlas" [
        language: "es"
    ]
    isA: "novel"
]
```

Create an envelope that refers to the digest of a particular digital embodiment of the novel, in EPUB format. Unlike CIDs, which refer to mutable objects, this digest can only refer to exactly one unique digital object.

```bash
$ BOOK_DATA="This is the entire book “Atlas Shrugged” in EPUB format."
$ BOOK_DIGEST=`envelope generate digest $BOOK_DATA`
$ echo $BOOK_DIGEST
```

```
ur:crypto-digest/hdcxvspkcxcaqzaafpistihpkttsqdiyfdzoknmsuydpfmjpykrdrkptlykkbyondeaslpinjljn
```

Create the final metadata object, which provides information about the object to which it refers, both as a general work and as a specific digital embodiment of that work.

```bash
$ BOOK_METADATA=`envelope subject --digest $BOOK_DIGEST | \
    envelope assertion --string "work" --envelope $WORK | \
    envelope assertion format EPUB | \
    envelope assertion --known-predicate dereferenceVia "IPFS"`
$ envelope $BOOK_METADATA
```

```
Digest(e8aa201db4044168d05b77d7b36648fb7a97db2d3e72f5babba9817911a52809) [
    "format": "EPUB"
    "work": CID(7fb90a9d96c07f39f75ea6acf392d79f241fac4ec0be2120f7c82489711e3e80) [
        "author": CID(9c747ace78a4c826392510dd6285551e7df4e5164729a1b36198e56e017666c8) [
            dereferenceVia: "LibraryOfCongress"
            hasName: "Ayn Rand"
        ]
        "isbn": "9780451191144"
        dereferenceVia: "LibraryOfCongress"
        hasName: "Atlas Shrugged" [
            language: "en"
        ]
        hasName: "La rebelión de Atlas" [
            language: "es"
        ]
        isA: "novel"
    ]
    dereferenceVia: "IPFS"
]
```
