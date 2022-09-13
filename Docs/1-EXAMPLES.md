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

```bash
# Alice sends a plaintext message to Bob.
$ HELLO_ENVELOPE=`envelope subject $PLAINTEXT_HELLO`
$ echo $HELLO_ENVELOPE
```

```
ur:envelope/tpuoiyfdihjzjzjldmgsgontio
```

Alice ➡️ ☁️ ➡️ Bob

```bash
# Bob receives the envelope and reads the message.
$ envelope extract $HELLO_ENVELOPE
```

```
Hello.
```

## Example 2: Signed Plaintext

This example demonstrates the signature of a plaintext message.

```bash
# Alice sends a signed plaintext message to Bob.
$ SIGNED_ENVELOPE=`envelope subject $PLAINTEXT_HELLO | envelope sign --prvkeys $ALICE_PRVKEYS`
$ echo $SIGNED_ENVELOPE
```

```
ur:envelope/lftpsptpuoiyfdihjzjzjldmtpsptputlftpsptpuraxtpsptpuotpuehdfzsbiyvtkomosbfnrftamhtegmkiwlgwnsmdctrsptmeltdeclkometyfxcmchfmtkchmyueckzepsjefdayayoevotddpatlrehuyvwwphhosehlphnsgwnksnefxsptbgrhtlrmo
```

Alice ➡️ ☁️ ➡️ Bob

```bash
# Bob receives the envelope and examines its contents.
$ envelope $SIGNED_ENVELOPE
```

```
"Hello." [
    verifiedBy: Signature
]
```

```bash
# Bob verifies Alice's signature. Note that no output is generated on success.
$ envelope verify $SIGNED_ENVELOPE --pubkeys $ALICE_PUBKEYS

# Bob extracts the message.
$ envelope extract $SIGNED_ENVELOPE
```

```
Hello.
```

```bash
# Confirm that it wasn't signed by Carol. Note that a failed verification results in an error condition.
$ envelope verify $SIGNED_ENVELOPE --pubkeys $CAROL_PUBKEYS
```

```
Error: invalidSignature
```

```bash
# Confirm that it was signed by Alice OR Carol.
$ envelope verify $SIGNED_ENVELOPE --threshold 1 --pubkeys $ALICE_PUBKEYS --pubkeys $CAROL_PUBKEYS

# Confirm that it was not signed by Alice AND Carol.
$ envelope verify $SIGNED_ENVELOPE --threshold 2 --pubkeys $ALICE_PUBKEYS --pubkeys $CAROL_PUBKEYS
```

```
Error: invalidSignature
```

## Example 3: Multisigned Plaintext

This example demonstrates a plaintext message signed by more than one party.

```bash
# Alice and Carol jointly send a signed plaintext message to Bob.
$ MULTISIGNED_ENVELOPE=`envelope subject $PLAINTEXT_HELLO | envelope sign --prvkeys $ALICE_PRVKEYS --prvkeys $CAROL_PRVKEYS`
$ echo $MULTISIGNED_ENVELOPE
```

```
ur:envelope/lstpsptpuoiyfdihjzjzjldmtpsptputlftpsptpuraxtpsptpuotpuehdfzfrosjsspcprhgwvtzcuofxtskkwppmsgfretrdcshhylfnlssnfgfykssntkihjoltsthhtoatfelpprzthyiywntbbygurtinltlbemhhtspycwwfdiwpplfnfxdkimtpsptputlftpsptpuraxtpsptpuotpuehdfzhpfyetcsbnrljokbvyoyhfbyaskowlbzzmjoykatrftevazsrymtjytkjolndnaalsfzleeennmnemmudsmtaoclhhemotqzskzofhseutjttkwfbtwnihfxzoehhfbntdetsgns
```

Alice & Carol ➡️ ☁️ ➡️ Bob

```bash
# Bob receives the envelope and examines its contents.
$ envelope $MULTISIGNED_ENVELOPE
```

```
"Hello." [
    verifiedBy: Signature
    verifiedBy: Signature
]
```

```bash
# Bob verifies the message was signed by both Alice and Carol.
$ envelope verify $MULTISIGNED_ENVELOPE --pubkeys $ALICE_PUBKEYS --pubkeys $CAROL_PUBKEYS

# Bob extracts the message.
$ envelope extract $MULTISIGNED_ENVELOPE
```

```
Hello.
```

## Example 4: Symmetric Encryption

This examples debuts the idea of an encrypted message, based on a symmetric key shared between two parties.

```bash
# Alice and Bob have agreed to use this key.
$ KEY=`envelope generate key`
$ echo $KEY
```

```
ur:crypto-key/hdcxpldtfesnclpdzodttohtmsdedebezodsosmodpdrhtpfqdnlwkimlbcwtbzmteeezotaengs
```

```bash
# Alice sends a message encrypted with the key to Bob.
$ ENCRYPTED_ENVELOPE=`envelope subject $PLAINTEXT_HELLO | envelope encrypt --key $KEY`
$ echo $ENCRYPTED_ENVELOPE
```

```
ur:envelope/tpsolrgakoidaygmmtoyhggscmgshtfwtlvskirndswzvokslswdgdkorlndeegswdtkehnefsbngtmdykbefdhddktpsbhdcxloimbnlplsdloycftluoftcfguayrsbwghlbctcmplwteyynsawsnlbgsnhkmovwfysesnfl
```

Alice ➡️ ☁️ ➡️ Bob

```bash
# Bob receives the envelope and examines its contents.
$ envelope $ENCRYPTED_ENVELOPE
```

```
EncryptedMessage
```

```bash
# Bob decrypts the message and extracts its subject.
$ DECRYPTED=`envelope decrypt $ENCRYPTED_ENVELOPE --key $KEY`
$ envelope extract $DECRYPTED
```

```
Hello.
```

```bash
# Can't read with incorrect key.
$ envelope decrypt $ENCRYPTED_ENVELOPE --key `envelope generate key`
```

```
Error: invalidKey
```

## Example 5: Sign-Then-Encrypt

This example combines the previous ones, first signing, then encrypting a message with a symmetric key.

```bash
# Alice and Bob have agreed to use this key.
$ KEY=`envelope generate key`
$ echo $KEY
```

```
ur:crypto-key/hdcxpldtfesnclpdzodttohtmsdedebezodsosmodpdrhtpfqdnlwkimlbcwtbzmteeezotaengs
```

```bash
# Alice signs a plaintext message, wraps it so her signature will also be encrypted, then encrypts it.
$ SIGNED_ENCRYPTED=`envelope subject $PLAINTEXT_HELLO | envelope sign --prvkeys $ALICE_PRVKEYS | envelope subject --wrapped | envelope encrypt --key $KEY`
$ echo $SIGNED_ENCRYPTED
ur:envelope/tpsolrhdhngoimhylfqzeyiehfmketmtaetlfydihhknrkntldyanydeehbynsvolfzsgmjemsjpqdssmnsfsolbvllnpkguckhpktisytvlbaftahzsahktlnwpdrottecwihgsttvobwdyyamsremnrydtnbhlcyrlfstidacfdegdksztjlgultdirkrkrlwzvdwtwkgstezsemeniooerngdbbayqdykgdwkisidrogwrnghgrmolypktafdjokgonhddktpsbhdcxwfurtouypmlpbysnbwftrdghbypscwsohhmwcsnncwtyjnuowyfgkeadmdrpbncljypketpk
```

Alice ➡️ ☁️ ➡️ Bob

```bash
# Bob receives the envelope, and examines its contents.
$ envelope $SIGNED_ENCRYPTED
```

```
EncryptedMessage
```

```bash
# Bob decrypts it using the shared key, and then examines the decrypted envelope's contents.
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

```bash
# Bob unwraps the inner envelope, verifies Alice's signature, and then extracts the message.
$ envelope extract --wrapped $DECRYPTED | envelope verify --pubkeys $ALICE_PUBKEYS | envelope extract
```

```
Hello.
```

```bash
# Attempting to verify the wrong key exits with an error.
$ envelope extract --wrapped $DECRYPTED | envelope verify --pubkeys $CAROL_PUBKEYS
Error: invalidSignature
```

## Example 6: Encrypt-Then-Sign

It doesn't actually matter whether the `encrypt` or `sign` command comes first, as the `encrypt` command transforms the subject into its encrypted form, which carries a digest of the plaintext subject, while the `sign` command only adds an assertion with the signature of the hash as the object of the assertion.

Similarly, the `decrypt` method used below can come before or after the `verify` command, as `verify` checks the signature against the subject's digest, which is explicitly present when the subject is in encrypted form and can be calculated when the subject is in plaintext form. The `decrypt` command transforms the subject from its encrypted form to its plaintext form, and also checks that the decrypted plaintext has the same hash as the one associated with the encrypted subject.

The end result is the same: the subject is encrypted and the signature can be checked before or after decryption.

The main difference between this order of operations and the sign-then-encrypt order of operations is that with sign-then-encrypt, the decryption *must* be performed first before the presence of signatures can be known or checked. With this order of operations, the presence of signatures is known before decryption, and may be checked before or after decryption.


```bash
# Alice and Bob have agreed to use this key.
$ KEY=`envelope generate key`
$ echo $KEY
```

```
ur:crypto-key/hdcxpldtfesnclpdzodttohtmsdedebezodsosmodpdrhtpfqdnlwkimlbcwtbzmteeezotaengs
```

```bash
# Alice encrypts a plaintext message, then signs it.
$ ENCRYPTED_SIGNED=`envelope subject $PLAINTEXT_HELLO | envelope encrypt --key $KEY | envelope sign --prvkeys $ALICE_PRVKEYS`
$ echo $ENCRYPTED_SIGNED
ur:envelope/lftpsptpsolrgazeclldzttkhkinjpbzgsdewydyhsgmdihdzezmlgvwrlgdtlemtylekgpywttbssbwwktlgrbsytkbhddktpsbhdcxloimbnlplsdloycftluoftcfguayrsbwghlbctcmplwteyynsawsnlbgsnhkmovwtpsptputlftpsptpuraxtpsptpuotpuehdfznlrkpdsoahgsdmjtltsakgltnbjyjsbajlpyswhnguwlzsfnwmnbvopdeckbamrybtweolpyhlwdjptoethpgaolidkgbzhhuotbyagogubattstjytnehsebsgrnyytnbtpflox
```

Alice ➡️ ☁️ ➡️ Bob

```bash
# Bob receives the envelope and examines its contents.
$ envelope $ENCRYPTED_SIGNED
```

```
EncryptedMessage [
    verifiedBy: Signature
]
```

```bash
# Bob verifies Alice's signature, decrypts the message, then extracts the message.
$ envelope verify $ENCRYPTED_SIGNED --pubkeys $ALICE_PUBKEYS |\
    envelope decrypt --key $KEY |\
    envelope extract
```

```
Hello.
```

## Example 7: Multi-Recipient Encryption

This example demonstrates an encrypted message sent to multiple parties.

```bash
# Alice encrypts a message so that it can only be decrypted by Bob or Carol.
$ ENVELOPE_TO=`envelope subject $PLAINTEXT_HELLO | envelope encrypt --recipient $BOB_PUBKEYS --recipient $CAROL_PUBKEYS`
$ echo $ENVELOPE_TO
```

```
ur:envelope/lstpsptpsolrgafdskfwckcehhfdbakkgsswdkadrldrhnprrnlrhnahcygdcecsskzslttldkvyrpdednbgpsgenyoxhddktpsbhdcxloimbnlplsdloycftluoftcfguayrsbwghlbctcmplwteyynsawsnlbgsnhkmovwtpsptputlftpsptpurahtpsptpuotptklftpsolshddksomdnsksjlktcfplislknstyfmfyvwwfkkvtsoiacffyutihbwcevondjteyenuoftmtjopfgskigdmsmsyaflflntjlrozefdgdfrrelsckbylsylmersqdiacehefdiylstpvahdcxsfldltynjyprvdadrnemdmbwrfkkcnbdluglrlghgyrsmomocsrpmkoymttaeyentpsptputlftpsptpurahtpsptpuotptklftpsolshddkmhndecotaekkchlscsvlfzrlmefdsrvehdgagsisfxgawzrdkgcwrlvdzocfhylewksscyksgsemgohgmsvsiafsspvovogwbtgdhkcpdnrlgltkylaxctwsoydimocnoemttpvahdcxktinfeidjkndgdykylbdnyiosgadknksrduevwiawlfpzctiwkldgwglmywfmwaerooltigo
```

Alice ➡️ ☁️ ➡️ Bob

Alice ➡️ ☁️ ➡️ Carol

```bash
# Bob receives the envelope and examines its structure:
$ envelope $ENVELOPE_TO
```

```
EncryptedMessage [
    hasRecipient: SealedMessage
    hasRecipient: SealedMessage
]
```

```bash
# Bob decrypts and reads the message
$ envelope decrypt $ENVELOPE_TO --recipient $BOB_PRVKEYS | envelope extract
```

```
Hello.
```

```bash
# Carol decrypts and reads the message
$ envelope decrypt $ENVELOPE_TO --recipient $CAROL_PRVKEYS | envelope extract
```

```
Hello.
```

```bash
# Alice didn't encrypt it to herself, so she can't read it.
$ envelope decrypt $ENVELOPE_TO --recipient $ALICE_PRVKEYS
```

```
Error: invalidRecipient
```
