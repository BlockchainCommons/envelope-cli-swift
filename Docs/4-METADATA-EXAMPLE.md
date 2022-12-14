# envelope - Complex Metadata Example

In this example, we use CIDs to represent an author, whose known works may change over time, and a particular novel written by her, the data returned about which may change over time.

Complex, tiered metadata can be added to an envelope.

Assertions made about an CID are considered part of a distributed set. Which assertions are returned depends on who resolves the CID and when it is resolved. In other words, the referent of a CID is mutable.


Start by creating an envelope that represents the author and what is known about her, including where to get more information using the author's CID.

```bash
๐
AUTHOR=`envelope subject --cid 9c747ace78a4c826392510dd6285551e7df4e5164729a1b36198e56e017666c8 | \
    envelope assertion --known dereferenceVia LibraryOfCongress | \
    envelope assertion --known hasName "Ayn Rand"`
envelope $AUTHOR
```

```
๐
CID(9c747ace) [
    dereferenceVia: "LibraryOfCongress"
    hasName: "Ayn Rand"
]
```

Create two envelopes representing the name of the novel in two different languages, annotated with assertions that specify the language.

```bash
๐
NAME_EN=`envelope subject "Atlas Shrugged" | \
    envelope assertion --known language en`
envelope $NAME_EN
```

```
๐
"Atlas Shrugged" [
    language: "en"
]
```

```bash
๐
NAME_ES=`envelope subject "La rebeliรณn de Atlas" | \
    envelope assertion --known language es`
envelope $NAME_ES
```

```
๐
"La rebeliรณn de Atlas" [
    language: "es"
]
```

Create an envelope that specifies known information about the novel. This envelope embeds the previous envelopes we created for the author and the names of the work.

```bash
๐
WORK=`envelope subject --cid 7fb90a9d96c07f39f75ea6acf392d79f241fac4ec0be2120f7c82489711e3e80 | \
    envelope assertion --known isA novel | \
    envelope assertion isbn "9780451191144" | \
    envelope assertion --string author --envelope $AUTHOR | \
    envelope assertion --known dereferenceVia "LibraryOfCongress" | \
    envelope assertion --known hasName --envelope $NAME_EN | \
    envelope assertion --known hasName --envelope $NAME_ES`
envelope $WORK
```

```
๐
CID(7fb90a9d) [
    "author": CID(9c747ace) [
        dereferenceVia: "LibraryOfCongress"
        hasName: "Ayn Rand"
    ]
    "isbn": "9780451191144"
    dereferenceVia: "LibraryOfCongress"
    hasName: "Atlas Shrugged" [
        language: "en"
    ]
    hasName: "La rebeliรณn de Atlas" [
        language: "es"
    ]
    isA: "novel"
]
```

Create an envelope that refers to the digest of a particular digital embodiment of the novel, in EPUB format. Unlike CIDs, which refer to mutable objects, this digest can only refer to exactly one unique digital object.

```bash
๐
BOOK_DATA="This is the entire book โAtlas Shruggedโ in EPUB format."
BOOK_DIGEST=`envelope generate digest $BOOK_DATA`
echo $BOOK_DIGEST
```

```
๐
ur:crypto-digest/hdcxvspkcxcaqzaafpistihpkttsqdiyfdzoknmsuydpfmjpykrdrkptlykkbyondeaslpinjljn
```

Create the final metadata object, which provides information about the object to which it refers, both as a general work and as a specific digital embodiment of that work.

```bash
๐
BOOK_METADATA=`envelope subject --digest $BOOK_DIGEST | \
    envelope assertion --string "work" --envelope $WORK | \
    envelope assertion format EPUB | \
    envelope assertion --known dereferenceVia "IPFS"`
envelope $BOOK_METADATA
```

```
๐
Digest(e8aa201d) [
    "format": "EPUB"
    "work": CID(7fb90a9d) [
        "author": CID(9c747ace) [
            dereferenceVia: "LibraryOfCongress"
            hasName: "Ayn Rand"
        ]
        "isbn": "9780451191144"
        dereferenceVia: "LibraryOfCongress"
        hasName: "Atlas Shrugged" [
            language: "en"
        ]
        hasName: "La rebeliรณn de Atlas" [
            language: "es"
        ]
        isA: "novel"
    ]
    dereferenceVia: "IPFS"
]
```
