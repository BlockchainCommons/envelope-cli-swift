# envelope - Distributed Identifier Example

This example offers an analogue of a DID document, which identifies an entity. The document itself can be referred to by its CID, while the signed document can be referred to by its digest.

```bash
👉
ALICE_UNSIGNED_DOCUMENT=`envelope subject --ur $ALICE_CID | \
    envelope assertion --known-predicate controller --ur $ALICE_CID | \
    envelope assertion --known-predicate publicKeys --ur $ALICE_PUBKEYS`
ALICE_SIGNED_DOCUMENT=`envelope subject --wrapped $ALICE_UNSIGNED_DOCUMENT | \
    envelope sign --prvkeys $ALICE_PRVKEYS --note "Made by Alice."`
envelope $ALICE_SIGNED_DOCUMENT
```

```
👈
{
    CID(d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f) [
        controller: CID(d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f)
        publicKeys: PublicKeyBase
    ]
} [
    verifiedBy: Signature [
        note: "Made by Alice."
    ]
]
```

➡️ ☁️ ➡️

A registrar checks the signature on Alice's submitted identifier document, performs any other necessary validity checks, and then extracts her CID from it.

```bash
👉
ALICE_UNWRAPPED=`envelope verify $ALICE_SIGNED_DOCUMENT --pubkeys $ALICE_PUBKEYS | \
    envelope extract --wrapped`
ALICE_CID_UR=`envelope extract $ALICE_UNWRAPPED --ur`
ALICE_CID_HEX=`envelope extract $ALICE_UNWRAPPED --cid`
```

The registrar creates its own registration document using Alice's CID as the subject, incorporating Alice's signed document, and adding its own signature.

```bash
👉
ALICE_URI="https://exampleledger.com/cid/$ALICE_CID_HEX"
ALICE_REGISTRATION=`envelope subject --ur $ALICE_CID_UR | \
    envelope assertion --known-predicate entity --envelope $ALICE_SIGNED_DOCUMENT | \
    envelope assertion --known-predicate dereferenceVia --uri $ALICE_URI | \
    envelope subject --wrapped | \
    envelope sign --prvkeys $LEDGER_PRVKEYS --note "Made by ExampleLedger."`
envelope $ALICE_REGISTRATION
```

```
👈
{
    CID(d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f) [
        dereferenceVia: URI(https://exampleledger.com/cid/d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f)
        entity: {
            CID(d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f) [
                controller: CID(d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f)
                publicKeys: PublicKeyBase
            ]
        } [
            verifiedBy: Signature [
                note: "Made by Alice."
            ]
        ]
    ]
} [
    verifiedBy: Signature [
        note: "Made by ExampleLedger."
    ]
]
```

Alice receives the registration document back, verifies its signature, and extracts the URI that now points to her record.

```bash
👉
ALICE_URI=`envelope verify $ALICE_REGISTRATION --pubkeys $LEDGER_PUBKEYS | \
    envelope extract --wrapped | \
    envelope assertion find --known-predicate dereferenceVia | \
    envelope extract --object | \
    envelope extract --uri`
echo $ALICE_URI
```

```
👈
https://exampleledger.com/cid/d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f
```

Alice wants to introduce herself to Bob, so Bob needs to know she controls her identifier. Bob sends a challenge:

```bash
👉
ALICE_CHALLENGE=`envelope generate nonce | \
    envelope subject --ur | \
    envelope assertion --known-predicate note "Challenge to Alice from Bob."`
echo $ALICE_CHALLENGE
```

```
👈
ur:envelope/lftpsptpuotaaosrgsnbfwsbnnoxgtrsotspnyvayntpsptputlftpsptpuraatpsptpuokscefxishsjzjzihjtioihcxjyjlcxfpjziniaihcxiyjpjljncxfwjliddmhfkgiysr
```

```bash
👉
envelope $ALICE_CHALLENGE
```

```
👈
Nonce [
    note: "Challenge to Alice from Bob."
]
```

Alice responds by adding her registered URI to the nonce, and signing it.

```bash
👉
ALICE_RESPONSE=`envelope subject --wrapped $ALICE_CHALLENGE | \
    envelope assertion --known-predicate dereferenceVia --uri $ALICE_URI | \
    envelope subject --wrapped | \
    envelope sign --prvkeys $ALICE_PRVKEYS --note "Made by Alice."`
envelope $ALICE_RESPONSE
```

```
👈
{
    {
        Nonce [
            note: "Challenge to Alice from Bob."
        ]
    } [
        dereferenceVia: URI(https://exampleledger.com/cid/d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f)
    ]
} [
    verifiedBy: Signature [
        note: "Made by Alice."
    ]
]
```

Bob receives Alice's response, and first checks that the nonce is the once he sent.
```bash
👉
ALICE_CHALLENGE_2=`envelope extract --wrapped $ALICE_RESPONSE | \
    envelope extract --wrapped`
echo $ALICE_CHALLENGE_2
```

```
👈
ur:envelope/lftpsptpuotaaosrgsnbfwsbnnoxgtrsotspnyvayntpsptputlftpsptpuraatpsptpuokscefxishsjzjzihjtioihcxjyjlcxfpjziniaihcxiyjpjljncxfwjliddmhfkgiysr
```

`ALICE_CHALLENGE_2` is indeed the same as `ALICE_CHALLENGE`, above. Bob then extracts Alice's registered URI.

```bash
👉
ALICE_URI=`envelope extract --wrapped $ALICE_RESPONSE | \
    envelope assertion find --known-predicate dereferenceVia | \
    envelope extract --object | \
    envelope extract --uri`
echo $ALICE_URI
```

```
👈
https://exampleledger.com/cid/d44c5e0afd353f47b02f58a5a3a29d9a2efa6298692f896cd2923268599a0d0f
```

Bob uses the URI to ask ExampleLedger for Alice's identifier document, then checks ExampleLedgers's signature. Bob trusts ExampleLedger's validation of Alice's original document, so doesn't bother to check it for internal consistency, and instead goes ahead and extracts Alice's public keys from it.

```bash
👉
ALICE_PUBKEYS=`envelope verify $ALICE_REGISTRATION --pubkeys $LEDGER_PUBKEYS | \
    envelope extract --wrapped | \
    envelope assertion find --known-predicate entity | \
    envelope extract --object | \
    envelope extract --wrapped | \
    envelope assertion find --known-predicate publicKeys | \
    envelope extract --object | \
    envelope extract --ur`
```

Finally, Bob uses Alice's public keys to validate the challenge he sent her.

```bash
👉
envelope verify --silent $ALICE_RESPONSE --pubkeys $ALICE_PUBKEYS
```
