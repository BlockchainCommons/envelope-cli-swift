# envelope - Verifiable Credential Example

In this example we build a permanent resident card, which the holder then redacts to reveal only selected information necessary to prove his identity.

Envelopes can also be built to support verifiable credentials, supporting the core functionality of DIDs.

John Smith's identifier:

```bash
👉
JOHN_CID=`envelope generate cid --hex 78bc30004776a3905bccb9b8a032cf722ceaf0bbfb1a49eaf3185fab5808cadc`
```

A photo of John Smith:

```bash
👉
JOHN_IMAGE=`envelope subject "John Smith Smiling" | \
envelope assertion --known-predicate note "This is an image of John Smith." | \
envelope assertion --known-predicate dereferenceVia --uri https://exampleledger.com/digest/36be30726befb65ca13b136ae29d8081f64792c2702415eb60ad1c56ed33c999`
```

```
👈
Digest(36be30726befb65ca13b136ae29d8081f64792c2702415eb60ad1c56ed33c999) [
    dereferenceVia: URI(https://exampleledger.com/digest/36be30726befb65ca13b136ae29d8081f64792c2702415eb60ad1c56ed33c999)
    note: "This is an image of John Smith."
]
```

John Smith's Permanent Resident Card issued by the State of Example:

```bash
👉
ISSUER=`envelope subject --ur $STATE_CID | \
    envelope assertion --known-predicate note "Issued by the State of Example" | \
    envelope assertion --known-predicate dereferenceVia --uri https://exampleledger.com/cid/04363d5ff99733bc0f1577baba440af1cf344ad9e454fad9d128c00fef6505e8`

BIRTH_COUNTRY=`envelope subject bs | \
    envelope assertion --known-predicate note "The Bahamas"`

HOLDER=`envelope subject --ur $JOHN_CID | \
    envelope assertion --known-predicate isA Person | \
    envelope assertion --known-predicate isA "Permanent Resident" | \
    envelope assertion givenName JOHN | \
    envelope assertion familyName SMITH | \
    envelope assertion sex MALE | \
    envelope assertion --string birthDate --date 1974-02-18 | \
    envelope assertion --string image --envelope $JOHN_IMAGE | \
    envelope assertion lprCategory C09 | \
    envelope assertion --string birthCountry --envelope $BIRTH_COUNTRY | \
    envelope assertion --string residentSince --date 2018-01-07`

JOHN_RESIDENT_CARD=`envelope subject --ur $JOHN_CID | \
    envelope assertion --known-predicate isA "credential" | \
    envelope assertion --string "dateIssued" --date 2022-04-27 | \
    envelope assertion --known-predicate issuer --envelope $ISSUER | \
    envelope assertion --known-predicate holder --envelope $HOLDER | \
    envelope assertion --known-predicate note "The State of Example recognizes JOHN SMITH as a Permanent Resident." | \
    envelope subject --wrapped | \
    envelope sign --prvkeys $STATE_PRVKEYS --note "Made by the State of Example."`

envelope $JOHN_RESIDENT_CARD
```

```
👈
{
    CID(78bc30004776a3905bccb9b8a032cf722ceaf0bbfb1a49eaf3185fab5808cadc) [
        "dateIssued": 2022-04-27
        holder: CID(78bc30004776a3905bccb9b8a032cf722ceaf0bbfb1a49eaf3185fab5808cadc) [
            "birthCountry": "bs" [
                note: "The Bahamas"
            ]
            "birthDate": 1974-02-18
            "familyName": "SMITH"
            "givenName": "JOHN"
            "image": "John Smith Smiling" [
                dereferenceVia: URI(https://exampleledger.com/digest/36be30726befb65ca13b136ae29d8081f64792c2702415eb60ad1c56ed33c999)
                note: "This is an image of John Smith."
            ]
            "lprCategory": "C09"
            "residentSince": 2018-01-07
            "sex": "MALE"
            isA: "Permanent Resident"
            isA: "Person"
        ]
        isA: "credential"
        issuer: CID(04363d5ff99733bc0f1577baba440af1cf344ad9e454fad9d128c00fef6505e8) [
            dereferenceVia: URI(https://exampleledger.com/cid/04363d5ff99733bc0f1577baba440af1cf344ad9e454fad9d128c00fef6505e8)
            note: "Issued by the State of Example"
        ]
        note: "The State of Example recognizes JOHN SMITH as a Permanent Resident."
    ]
} [
    verifiedBy: Signature [
        note: "Made by the State of Example."
    ]
]
```

John wishes to identify himself to a third party using his government-issued credential, but does not wish to reveal more than his name, his photo, and the fact that the state has verified his identity.

Redaction is performed by building a set of digests that will be revealed. All digests not present in the reveal-set will be replaced with elision markers containing only the hash of what has been elided, thus preserving the hash tree including revealed signatures. If a higher-level object is elided, then everything it contains will also be elided, so if a deeper object is to be revealed, all of its parent objects also need to be revealed, even though not everything *about* the parent objects must be revealed.

```bash
👉
# Start a target set.
TARGET=()

# Reveal the card. Without this, everything about the card would be elided.
TARGET+=(`envelope digest $JOHN_RESIDENT_CARD`)

# Reveal everything about the state's signature on the card
TARGET+=(`envelope assertion find --known-predicate verifiedBy $JOHN_RESIDENT_CARD | envelope digest --deep`)

# Reveal the top level of the card.
TARGET+=(`envelope digest $JOHN_RESIDENT_CARD --shallow`)
CARD=`envelope extract --wrapped $JOHN_RESIDENT_CARD`
TARGET+=(`envelope digest $CARD`)
TARGET+=(`envelope extract $CARD --envelope | envelope digest`)

# Reveal everything about the `isA` and `issuer` assertions at the top level of the card.
TARGET+=(`envelope assertion find --known-predicate isA $CARD | envelope digest --deep`)
TARGET+=(`envelope assertion find --known-predicate issuer $CARD | envelope digest --deep`)

# Reveal the `holder` assertion on the card, but not any of its sub-assertions.
HOLDER=`envelope assertion find --known-predicate holder $CARD`
TARGET+=(`envelope digest --shallow $HOLDER`)

# Within the `holder` assertion, reveal everything about just the `givenName`, `familyName`, and `image` assertions.
HOLDER_OBJECT=`envelope extract --object $HOLDER`
TARGET+=(`envelope assertion find givenName $HOLDER_OBJECT | envelope digest --deep`)
TARGET+=(`envelope assertion find familyName $HOLDER_OBJECT | envelope digest --deep`)
TARGET+=(`envelope assertion find image $HOLDER_OBJECT | envelope digest --deep`)

# Perform the elision
ELIDED_CARD=`envelope elide revealing $JOHN_RESIDENT_CARD $TARGET`

# Show the elided card
envelope $ELIDED_CARD
```

```
👈
{
    CID(78bc30004776a3905bccb9b8a032cf722ceaf0bbfb1a49eaf3185fab5808cadc) [
        holder: CID(78bc30004776a3905bccb9b8a032cf722ceaf0bbfb1a49eaf3185fab5808cadc) [
            "familyName": "SMITH"
            "givenName": "JOHN"
            "image": "John Smith Smiling" [
                dereferenceVia: URI(https://exampleledger.com/digest/36be30726befb65ca13b136ae29d8081f64792c2702415eb60ad1c56ed33c999)
                note: "This is an image of John Smith."
            ]
            ELIDED (7)
        ]
        isA: "credential"
        issuer: CID(04363d5ff99733bc0f1577baba440af1cf344ad9e454fad9d128c00fef6505e8) [
            dereferenceVia: URI(https://exampleledger.com/cid/04363d5ff99733bc0f1577baba440af1cf344ad9e454fad9d128c00fef6505e8)
            note: "Issued by the State of Example"
        ]
        ELIDED (2)
    ]
} [
    verifiedBy: Signature [
        note: "Made by the State of Example."
    ]
]
```

Print the number of digests in the target set.

```bash
👉
echo ${#TARGET[@]}
```

```
👈
46
```

Remove duplicates to get the number of unique digests in the target. Duplicates don't harm anything, but they might point to opportunities for optimization.

```bash
👉
UNIQUE_DIGESTS=( `for i in ${TARGET[@]}; do echo $i; done | sort -u` )
echo ${#UNIQUE_DIGESTS[@]}
```

```
👈
40
```

Note that the original card and the elided card have the same digest.

```bash
👉
envelope digest $JOHN_RESIDENT_CARD; envelope digest $ELIDED_CARD
```

```
👈
ur:crypto-digest/hdcxkilbmyntethdcpmntddrwfnnbdnbhynbqdbdgwnlylaoonmoleoyztfsnbasdyclmkpeoxgr
ur:crypto-digest/hdcxkilbmyntethdcpmntddrwfnnbdnbhynbqdbdgwnlylaoonmoleoyztfsnbasdyclmkpeoxgr
```

Note that the state's signature on the elided card still verifies.

```bash
👉
envelope verify --silent $ELIDED_CARD --pubkeys $STATE_PUBKEYS
```
