# envelope

A command line tool for manipulating the `Envelope` data type.

## Overview of the Commands

### Help

Help is available for the tool and its subcommands.

```
$ envelope help
OVERVIEW: A tool for manipulating the Envelope data type.

USAGE: envelope <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  format (default)        Print the envelope in Envelope Notation.
  subject                 Create an envelope with the given subject.
  extract                 Extract the subject of the input envelope.
  assertion               Work with the envelope's assertions.
  digest                  Print the envelope's digest.
  elide                   Elide a subset of elements.
  generate                Utilities to generate and convert various objects.
  encrypt                 Encrypt the envelope's subject using the provided key.
  decrypt                 Decrypt the envelope's subject using the provided key.
  sign                    Sign the envelope with the provided private key base.
  validate                Validate a signature on the envelope using the provided public key base.
  sskr                    Sharded Secret Key Reconstruction (SSKR).

  See 'envelope help <subcommand>' for detailed help.
```

Here is an example envelope we'll use in many of the examples below. The `envelope` tool expects input and produces output for a number of types it uses in UR format.

```
$ ALICE_KNOWS_BOB=ur:envelope/lftpsptpuoihfpjziniaihtpsptputlftpsptpuoihjejtjlktjktpsptpuoiafwjlidrdpdiesk
```

### Format

The `format` command is the default. This means that you can just feed an envelope in UR format into the tool and it will print out its formatted contents in Envelope Notation.

```
$ envelope $ALICE_KNOWS_BOB    # Equivalent to `envelope format $ALICE_KNOWS_BOB`
"Alice" [
    "knows": "Bob"
]
```

### Subject

The `subject` command creates a new envelope with the given subject. You can specify the data type of the subject; `string` is the default.

```
$ envelope subject "Hello."    # Equivalent to `envelope subject --string "Hello."`
ur:envelope/tpuoiyfdihjzjzjldmgsgontio
```

When we feed this envelope back into the default `format` comand, we get the envelope printed in Envelope Notation. This is why `"Hello."` is printed with quotes around it:

```
$ envelope ur:envelope/tpuoiyfdihjzjzjldmgsgontio
"Hello."
```

### Extract

To extract the actual data of the envelope's subject, use the `extract` command:

```
# Equivalent to `envelope extract --string ur:envelope/tpuoiyfdihjzjzjldmgsgontio`

$ envelope extract ur:envelope/tpuoiyfdihjzjzjldmgsgontio
Hello.
```

In an envelope with assertions, the `extract` command just returns the subject without the assertions:

```
$ envelope extract $ALICE_KNOWS_BOB
Alice
```

If you want the subject returned as an envelope, use the `--envelope` data type:

```
$ envelope extract --envelope $ALICE_KNOWS_BOB
ur:envelope/tpuoihfpjziniaihoxweclfg

$ envelope ur:envelope/tpuoihfpjziniaihoxweclfg
"Alice"
```

### Assertion

To add an assertion to an existing envelope, use the `assertion` command. In this example, `envelope` is invoked twice, once to create the envelope with its subject, and the second to add an assertion to it:

```
$ envelope subject "Alice" | envelope assertion "knows" "Bob"
ur:envelope/lftpsptpuoihfpjziniaihtpsptputlftpsptpuoihjejtjlktjktpsptpuoiafwjlidrdpdiesk
```

Note that we have just constructed the $ALICE_KNOWS_BOB example envelope from scratch!

The `assertion` command has several subcommands that help us work with assertions:

```
$ envelope help assertion
OVERVIEW: Work with the envelope's assertions.

USAGE: envelope assertion <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  add (default)           Add an assertion to the given envelope.
  count                   Print the count of the envelope's assertions.
  at                      Retrieve the assertion at the given index.
  all                     Retrieve all the envelope's assertions.
  find                    Find all assertions matching the given criteria.

  See 'envelope help assertion <subcommand>' for detailed help.
```

### Digest

Every envelope produces a unique `Digest`, and since every part of an envelope is *itself* an envelope, every part also has its own unique Digest.

This prints the digest of the envelope as a whole:

```
$ envelope digest $ALICE_KNOWS_BOB
ur:crypto-digest/hdcxvwgtjltemnnlgmwttslynblpgamugszmtdlkmnckwkatmelbpdwljnynnehedrmhnnlfmthl
```

While this prints the digest of the *subject* of the envelope:

```
$ envelope extract --envelope $ALICE_KNOWS_BOB | envelope digest
ur:crypto-digest/hdcxdilraxgdgeteptptsagscwecotiofmwycmhthlgmfhlgdrhhyktojntdhtemwnbeoscxeonl
```

Note that the two digests above are different.

Let's print the digest of the example envelope's assertion:

```
$ envelope assertion at 0 $ALICE_KNOWS_BOB | envelope digest
ur:crypto-digest/hdcxgohfbdurambsbgcxcfnsltvsgldttotoytjtyabyuegwesntpydluemwdatitycstattsrre
```

Finally, let's print the digest of the object of the envelope's assertion:

```
$ envelope assertion at 0 $ALICE_KNOWS_BOB |  # Gets the assertion
    envelope extract --object |               # Gets the object of the assertion
    envelope digest                           # Prints the digest
ur:crypto-digest/hdcxnyktchbzfsknehpfesaebyfpfrurmdaezmgtlojosfwnaoplehwdoyihpydaurcybzaaqzko
```

### Elision

Now that we can use digests to specify the parts of an envelope, we can transform it in interesting ways. Elision means to remove various parts of an envelope without changing its digest. The `elide` command and its two subcommands `removing` and `revealing` (the default) provide this service.

Let's start by getting the digest of the subject of our example Envelope:

```
$ SUBJECT_DIGEST=`envelope extract --envelope $ALICE_KNOWS_BOB | envelope digest`

$ echo $SUBJECT_DIGEST
ur:crypto-digest/hdcxdilraxgdgeteptptsagscwecotiofmwycmhthlgmfhlgdrhhyktojntdhtemwnbeoscxeonl
```

Now if we want to produce a version of the envelope with its subject elided, we provide that digest to the `elide removing` command. Here we do the elision then immediately pipe the resulting envelope to the `format` command:

```
$ envelope elide removing $ALICE_KNOWS_BOB $SUBJECT_DIGEST | envelope
ELIDED [
    "knows": "Bob"
]
```

We can provide any number of digests in the "target set" of the `elide` command. If the `elide removing` command is used, then *only* the elements in the set will be elided. If the `elide revealing` command is used, then all *but* the elements in the set will be elided.

Here we provide two digests: the first for the subject as above, and the digest that represents the object of the assertion we produced previously using the `digest` command:

```
$ BOB_DIGEST=ur:crypto-digest/hdcxnyktchbzfsknehpfesaebyfpfrurmdaezmgtlojosfwnaoplehwdoyihpydaurcybzaaqzko

$ envelope elide removing $ALICE_KNOWS_BOB $SUBJECT_DIGEST $BOB_DIGEST | envelope
ELIDED [
    "knows": ELIDED
]
```

Now this is important: the elided version of the envelope we produced has the *same* digest as the original, un-elided envelope. This means that things like cryptographic signatures added to the envelope as assertions, if not themselves elided, will *still validate*.

Let's compare the original envelope's digest to the elided version's digest:

```
$ envelope digest $ALICE_KNOWS_BOB
ur:crypto-digest/hdcxvwgtjltemnnlgmwttslynblpgamugszmtdlkmnckwkatmelbpdwljnynnehedrmhnnlfmthl

$ envelope elide removing $ALICE_KNOWS_BOB $SUBJECT_DIGEST $BOB_DIGEST | envelope digest
ur:crypto-digest/hdcxvwgtjltemnnlgmwttslynblpgamugszmtdlkmnckwkatmelbpdwljnynnehedrmhnnlfmthl
```

So even though the original and elided versions are in fact *different envelopes*, their digests are *exactly the same!*

### Symmetric Key Encryption

The `envelope` tool provides the `encrypt` and `decrypt` commands to perform symmetric key encryption of an envelope's subject. Why not the *whole* envelope? That's easy too, and we'll get to it shortly, but first we need a key. `envelope` has the `generate key` command that generates a new encryption key.

```
$ KEY=`envelope generate key`
$ echo $KEY
ur:crypto-key/hdcxmszmjlfsgssrbzehsslphdlgtbwesofnlpehlftldwotpaiyfwbtzsykwttomsbatnzswlqd
```

Once we have this, we can produce a version of our example envelope that has its subject encrypted:

```
$ ENCRYPTED=`envelope encrypt $ALICE_KNOWS_BOB $KEY`

$ envelope $ENCRYPTED
EncryptedMessage [
    "knows": "Bob"
]
```

Note that encryption uses randomness to help hide what has been encrypted. So each time you perform an encryption, the resulting envelope will be different:

```
$ envelope encrypt $ALICE_KNOWS_BOB $KEY
ur:envelope/lftpsptpsolrgejottrtttrofshdtafddtgsmhhsyaksmtuygwfxvtwlcntsgdgrwksfotbgbejsnsioleprwlfxplcxdlhddktpsbhdcxdilraxgdgeteptptsagscwecotiofmwycmhthlgmfhlgdrhhyktojntdhtemwnbetpsptputlftpsptpuoihjejtjlktjktpsptpuoiafwjlidcktipmwn

$ envelope encrypt $ALICE_KNOWS_BOB $KEY
ur:envelope/lftpsptpsolrgehppfhsgwjodtgesrcewtgsropldieywlzsgabdlodaenqzgdlpcsiskibzvafgdkttdewybnstsrqzdshddktpsbhdcxdilraxgdgeteptptsagscwecotiofmwycmhthlgmfhlgdrhhyktojntdhtemwnbetpsptputlftpsptpuoihjejtjlktjktpsptpuoiafwjlidchnewzad
```

But notice! When you encrypt parts of an envelope, its *digest* remains the same as the unencrypted version:

```
$ envelope digest $ALICE_KNOWS_BOB
ur:crypto-digest/hdcxvwgtjltemnnlgmwttslynblpgamugszmtdlkmnckwkatmelbpdwljnynnehedrmhnnlfmthl

$ envelope encrypt $ALICE_KNOWS_BOB $KEY | envelope digest
ur:crypto-digest/hdcxvwgtjltemnnlgmwttslynblpgamugszmtdlkmnckwkatmelbpdwljnynnehedrmhnnlfmthl
```

If you want the digest to be different each time you encrypt, you can add random salt to the envelope; see below.

So far we've just encrypted the subject of an envelope. But what if we want to encrypt the entire envelope, including its assertions?

For this, you simply wrap the envelope in an outer envelope, and encrypt that!

```
$ WRAPPED=`envelope subject --wrapped $ALICE_KNOWS_BOB`

$ envelope $WRAPPED
{
    "Alice" [
        "knows": "Bob"
    ]
}
```

The outer envelope has just a subject, which is the entire contents of the inner envelope!

What's the advantage in doing things this way? Once you have a wrapped envelope, you can add additional assertions to it, like signatures, that will still validate even if the subject has been encrypted or elided!

Note that since we created a new envelope by doing the wrapping, that this new envelope will *not* have the same digest as its inner envelope:

```
$ envelope digest $ALICE_KNOWS_BOB
ur:crypto-digest/hdcxvwgtjltemnnlgmwttslynblpgamugszmtdlkmnckwkatmelbpdwljnynnehedrmhnnlfmthl

$ envelope digest $WRAPPED
ur:crypto-digest/hdcxdsdacwememuoztpkmsamkbkolbutoxjztagmjymdjsmkdinlrnmokbjtttemdwdigsimfets
```

```
$ WRAPPED_ENCRYPTED=`envelope encrypt $WRAPPED $KEY`

$ envelope $WRAPPED_ENCRYPTED
EncryptedMessage
```

This encrypted envelope still has the same digest as the wrapped but unencrypted version:

```
$ envelope digest $WRAPPED
ur:crypto-digest/hdcxdsdacwememuoztpkmsamkbkolbutoxjztagmjymdjsmkdinlrnmokbjtttemdwdigsimfets

$ envelope digest $WRAPPED_ENCRYPTED
ur:crypto-digest/hdcxdsdacwememuoztpkmsamkbkolbutoxjztagmjymdjsmkdinlrnmokbjtttemdwdigsimfets
```

To recover the original envelope we reverse the steps, first decrypting, then unwrapping:

```
$ envelope decrypt $WRAPPED_ENCRYPTED $KEY |   # Decrypt the envelope
    envelope extract --wrapped |               # Unwrap the inner envelope
    envelope                                   # Show the formatted contents
"Alice" [
    "knows": "Bob"
]
```

### Signatures

Similar to how you can encrypt an envelope's subject, you can also cryptographically sign the subject by adding an assertion. Since signing uses public key cryptography, we first need a private/public key pair known as a PrivateKeyBase. This can be used to sign and decrypt messages encrypted with the corresponding public key

```
$ envelope generate prvkeys
ur:crypto-prvkeys/hdcxbekgntwpenryhdnybzvsltvepdgwtatovtyturylgrossekizezmlttdierfzcaslkgmlrla
```

The above generation is random. If you wish to use a `crypto-seed` as your starting point:

```
$ SEED=`ur:crypto-seed/oyadgdmdeefejoaonnatcycefxjedrfyaspkiakionamgl`
$ PRVKEYS=`envelope generate prvkeys $SEED`
$ echo $PRVKEYS
ur:crypto-prvkeys/gdmdeefejoaonnatcycefxjedrfyaspkiawdioolhs
```

Of course, we'll also want to distribute the public key, so the signature can be verified:

```
$ PUBKEYS=`envelope generate pubkeys $PRVKEYS`

$ echo $PUBKEYS
ur:crypto-pubkeys/lftaaosehdcxbansurpspfeccabtbtjteopdwpwtsfskdretfewyktlssksflspmahpdjefpghwptpvahdcxrtuoiddkgsoxzegughnszmfzgobnvlkpjscyrokesgnnkslumshnrfgtgmsfcnfgbzmdvyvw
```

Now we can sign our envelope:

```
$ SIGNED=`envelope sign $ALICE_KNOWS_BOB $PRVKEYS`
```

Let's see what it looks like when formatted now:

```
$ envelope $SIGNED
"Alice" [
    "knows": "Bob"
    verifiedBy: Signature
]
```

OK... there's a signature there now, but it's a new assertion on the subject of the envelope, "Alice". This means that any of the assertions can still be altered without invalidating the signature on the subject. But what if we want to sign the *whole* envelope, including the fact that she knows Bob?

Wrapping to the rescue again!

```
$ WRAPPED_SIGNED=`envelope subject --wrapped $ALICE_KNOWS_BOB | envelope sign $PRVKEYS`
$ envelope $WRAPPED_SIGNED
{
    "Alice" [
        "knows": "Bob"
    ]
} [
    verifiedBy: Signature
]
```

Now the entire contents of the envelope are signed, and if we send it to someone who has our public key, they can validate the signature:

```
$ envelope validate $WRAPPED_SIGNED $PUBKEYS
```

The `validate` command produces no output if the validation is successful, and exits with an error condition if it is unsuccessful. Lets produce some incorrect public keys and try this:

```
$ BAD_PUBKEYS=`envelope generate prvkeys | envelope generate pubkeys`

$ envelope validate $WRAPPED_SIGNED $BAD_PUBKEYS
Error: invalidSignature
```

Note that like encryption, signing uses randomness. So even if you sign the same envelope twice with the same private key, the two resulting envelopes will not be the same although both signatures will validate against the same public key.

### SSKR

SSKR lets you split ("shard") an envelope into several shares, a threshold of which is necessary to recover the original message. If we shard our example envelope into 3 shares, we get:

```
$ envelope sskr split -g 2-of-3 $ALICE_KNOWS_BOB
ur:envelope/lftpsptpsolrhddkoemtimttadbyntmozsvshlcfurjnbbgyrtrdpdhlhgmhfpjovsdkhtcwgttscadedatprkkkgsinoybkwkwzcwwtsavddtgubagdfddwkofdyalthpsfdejpqdgrtspfvlimhddktpsbhdcxdsdacwememuoztpkmsamkbkolbutoxjztagmjymdjsmkdinlrnmokbjtttemdwditpsptputlftpsptpuramtpsptpuotaadechddactsraeadaejkrnwnbypauekkcstshymsbsptvthtpfeoylcfcpfrpsnthffpgsdtcxhtlufzzclunteode
ur:envelope/lftpsptpsolrhddkoemtimttadbyntmozsvshlcfurjnbbgyrtrdpdhlhgmhfpjovsdkhtcwgttscadedatprkkkgsinoybkwkwzcwwtsavddtgubagdfddwkofdyalthpsfdejpqdgrtspfvlimhddktpsbhdcxdsdacwememuoztpkmsamkbkolbutoxjztagmjymdjsmkdinlrnmokbjtttemdwditpsptputlftpsptpuramtpsptpuotaadechddactsraeadadgwfzkeaotatkmtaeoywmosqzjowtdntlsocfbgfgcmzccabyktluzooxvwfwioayspssongs
ur:envelope/lftpsptpsolrhddkoemtimttadbyntmozsvshlcfurjnbbgyrtrdpdhlhgmhfpjovsdkhtcwgttscadedatprkkkgsinoybkwkwzcwwtsavddtgubagdfddwkofdyalthpsfdejpqdgrtspfvlimhddktpsbhdcxdsdacwememuoztpkmsamkbkolbutoxjztagmjymdjsmkdinlrnmokbjtttemdwditpsptputlftpsptpuramtpsptpuotaadechddactsraeadaobdhkwtemhsztrfdefrdlylidaertroknuodybswdhsbalntpdptamteofhaobabnwfltdsvs
```

Assume we've processed that output and have assigned them to SHARE_0, SHARE_1, and SHARE_2. If we format the first of those shares, we see that the subject is a symmetrically encrypted message, and its assertion is an SSKR share, which is one of the shares needed to decrypt the subject.

```
$ envelope $SHARE_0
EncryptedMessage [
    sskrShare: SSKRShare
]
```

Taking the first and third of those shares, we can recover the original envelope:

```
$ RECOVERED=`envelope sskr join $SHARE_0 $SHARE_2`
$ envelope $RECOVERED
"Alice" [
    "knows": "Bob"
]
```

But just one of the shares is insufficient:

```
$ envelope sskr join $SHARE_1
Error: invalidShares
```
