# TRANSCRIPT: Gordian Envelope CLI - 1 - Commands Overview

[![Gordian Envelope CLI - 1 - Commands Overview](https://img.youtube.com/vi/K2gFTyjbiYk/mqdefault.jpg)](https://youtu.be/K2gFTyjbiYk)

_Part of the [Envelope-CLI Playlist](https://www.youtube.com/playlist?list=PLCkrqxOY1FbooYwJ7ZhpJ_QQk8Az1aCnG)._

## Description

Envelopes are a new type of "smart document" allowing for storage and encryption of data and authentication by a variety of means. It's part of the Gordian Architecture led by Blockchain Commons. 

This video offers an overview of the Gordian Envelope-CLI (command line interface) tool, `envelope`, which can be used to create and verify cryptographic envelopes.

* [Brief Overview of These Commands](https://github.com/BlockchainCommons/envelope-cli-swift/blob/master/Docs/1-OVERVIEW.md)

**Other Overview Docs:**

* [Gordian Envelope-CLI — Repo for the CLI program](https://github.com/BlockchainCommons/envelope-cli-swift)
* [Gordian Envelope Docs — Swift Library and Specs](https://github.com/BlockchainCommons/BCSwiftSecureComponents/tree/master/Docs)
* [Gordian Architecture — Overview of Entire Design](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Overview-Architecture.md)

### Chapters

* [00:00](https://youtu.be/K2gFTyjbiYk?t=0) gordian envelope-cli overview
* [00:08](https://youtu.be/K2gFTyjbiYk?t=8) envelope refresher
* [00:40](https://youtu.be/K2gFTyjbiYk?t=40) demo of `envelope` in the terminal in macOS
* [01:13](https://youtu.be/K2gFTyjbiYk?t=73)`envelope help`
* [01:29](https://youtu.be/K2gFTyjbiYk?t=89)`envelope subject` a basic envelope
* [02:20](https://youtu.be/K2gFTyjbiYk?t=150) envelope format` and envelope notation
* [03:31](https://youtu.be/K2gFTyjbiYk?t=211)`envelope extract` the subject
* [03:49](https://youtu.be/K2gFTyjbiYk?t=229) envelope datatypes
* [04:40](https://youtu.be/K2gFTyjbiYk?t=280)`envelope extract —envelope`
* [05:09](https://youtu.be/K2gFTyjbiYk?t=309)`envelope assertion`
* [06:12](https://youtu.be/K2gFTyjbiYk?t=372) `envelope digest` encode a blake3 hash in ur:crypto-digest
* [07:13](https://youtu.be/K2gFTyjbiYk?t=433) extracting digest of an assertion
* [08:03](https://youtu.be/K2gFTyjbiYk?t=483) elision allows removal of parts of an envelope for redaction
* [08:38](https://youtu.be/K2gFTyjbiYk?t=518)`envelope elide removing` redact one or more digests
* [10:13](https://youtu.be/K2gFTyjbiYk?t=613) elided envelopes have same digest as the original
* [10:54](https://youtu.be/K2gFTyjbiYk?t=654) symmetric key encryption
* [11:22](https://youtu.be/K2gFTyjbiYk?t=682) `envelope generate key` create a random encryption key
* [11:38](https://youtu.be/K2gFTyjbiYk?t=698) `envelope encrypt` symmetric encrypt subject of an envelope
* [13:20](https://youtu.be/K2gFTyjbiYk?t=800) wrap an envelope to prepare for symmetric encryption
* [14:28](https://youtu.be/K2gFTyjbiYk?t=868) symmetric encrypt whole envelope
* [14:58](https://youtu.be/K2gFTyjbiYk?t=898) symmetric decrypt and unwrap envelope
* [15:23](https://youtu.be/K2gFTyjbiYk?t=923) signing an envelope
* [15:34](https://youtu.be/K2gFTyjbiYk?t=934) `envelope generate prvkeys` to generate private key encoded as ur:crypto-prvkeys
* [16:12](https://youtu.be/K2gFTyjbiYk?t=972) `envelope generate pubkeys` to generate public key encoded as ur:crypto-pubkeys
* [16:43](https://youtu.be/K2gFTyjbiYk?t=1003) `envelope sign` with —prvkeys adds assertion to subject
* [17:06](https://youtu.be/K2gFTyjbiYk?t=1026) PROBLEM: `envelope sign` signs only the subject, not good enough
* [17:40](https://youtu.be/K2gFTyjbiYk?t=1060) SOLUTION: wrap before signing
* [18:14](https://youtu.be/K2gFTyjbiYk?t=1094) verify a signature
* [18:25](https://youtu.be/K2gFTyjbiYk?t=1105) verify returns original envelope if true so you can pipe otherwise ERROR
* [18:37](https://youtu.be/K2gFTyjbiYk?t=1117) option for verify —silent
* [18:49](https://youtu.be/K2gFTyjbiYk?t=1129) example of bad signature `Error: unverified signature`
* [19:17](https://youtu.be/K2gFTyjbiYk?t=1157) shard an envelope with SSKR (Sharded Secret Key Reconstruction) to create an encrypted share
* [19:49](https://youtu.be/K2gFTyjbiYk?t=1189) `envelope sskr split` to create 3 shares
* [20:30](https://youtu.be/K2gFTyjbiYk?t=1230) separate into array of shares
* [21:00](https://youtu.be/K2gFTyjbiYk?t=1260) inspect an SSKR share's format
* [21:24](https://youtu.be/K2gFTyjbiYk?t=1284) `envelope sskr join` to recover 2 of 3 shares to restore unencrypted envelope
* [22:02](https://youtu.be/K2gFTyjbiYk?t=1322) many flexible SSKR options
* [22:12](https://youtu.be/K2gFTyjbiYk?t=1332) using salts to avoid correlation
* [22:59](https://youtu.be/K2gFTyjbiYk?t=1379) `envelope salt` make envelope hashes different
* [23:29](https://youtu.be/K2gFTyjbiYk?t=1409) Comparing original with salted encrypted envelope

## Edited Transcript

> You can download the source code for `envelope` onto a Mac from https://github.com/BlockchainCommons/envelope-cli-swift and compile it, per the directions there. Doing so requires Xcode 14 and the command line tools. This will allow you to work along with this transcript.

```
$ git clone https://github.com/BlockchainCommons/envelope-cli-swift.git
$ cd envelope-cli-swift/
$ ./build.sh
$ ./link.sh
```

### Introduction

Hi, I'm Wolf McNally. And I'm going to give you an overview of the envelope command line interface tool.

As a quick refresher. The envelope is a recursive structure. So envelopes contain envelopes. It's what we're calling a smart document, and you'll see why as I proceed here. Basically, an envelope consists of a subject, which is also an envelope and a set of zero or more assertions; the assertions themselves consist of a predicate, which is an envelope and an object, which is an envelope. The basic form of an envelope is what would be called a semantic triple, like "Alice knows Bob", which takes the form of subject predicate object.

### The envelope CLI

So we're going to spend most of this talk in the terminal. This is a Mac because the `envelope` command line tool is currently written in Swift and so it runs on Macs. But the envelope structure itself is based on CBOR, which is the common binary object representation. It's like JSON but in binary. Another structure you're going to see a lot is the UR, the Uniform Resource.

If you just type `envelope` from the command line and just press return, it's going to hang because it's waiting to read an envelope from standard in. So generally speaking, you don't type it by itself. But if you type `envelope help` then you get the basic help for the `envelope` tool. 

[**▶️ envelope help:**](https://youtu.be/K2gFTyjbiYk?t=73)
```
$ envelope help
OVERVIEW: A tool for manipulating the Envelope data type.

USAGE: envelope <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  assertion               Work with the envelope's assertions.
  digest                  Print the envelope's digest.
  decrypt                 Decrypt the envelope's subject using the provided key.
  elide                   Elide a subset of elements.
  encrypt                 Encrypt the envelope's subject using the provided key.
  extract                 Extract the subject of the input envelope.
  format (default)        Print the envelope in Envelope Notation.
  generate                Utilities to generate and convert various objects.
  proof                   Work with existence proofs.
  salt                    Add random salt to the envelope.
  sign                    Sign the envelope with the provided private key base.
  sskr                    Sharded Secret Key Reconstruction (SSKR).
  subject                 Create an envelope with the given subject.
  verify                  Verify a signature on the envelope using the provided
                          public key base.

  See 'envelope help <subcommand>' for detailed help.
```

As you can see, it has a variety of sub commands. The basic structure is you enter the command you want and then the other necessary parameters for that command. 

### Creation

The first thing I'm going to show you is how you would create a basic envelope and to do this, I'm just going to type "envelope subject", and then I'm going to type a string, "Hello." 

[**▶️ envelope subject:**](https://youtu.be/K2gFTyjbiYk?t=89)
```
$ envelope subject "Hello."
ur:envelope/tpuoiyfdihjzjzjldmgsgontio
```

As you can see, the output of this is a `ur:`. UR stands for uniform resource. It has a type, and then it has a string of characters after it, which are an ASCII encoded version of the CBOR object. If you just need binary, you can use CBOR directly. However, if you ever want to transmit these things, either in text or as QR codes (because URs are especially optimized for use with QR codes, but they can be used for all kinds of other things, too), then UR is a great format for this because it's human readable. It is also a well-formed URI. You're probably familiar with the most common form of URIs, which are URLs.

So this is probably one of the simplest envelopes, it's just a plain text string encoded. 

I'm going to  create a string variable here, which has a a longer envelope in it. It's called Alice knows Bob. It's another UR, but it's a little bit longer. 

```
ALICE_KNOWS_BOB=ur:envelope/lftpsptpuoihfpjziniaihtpsptputlftpsptpuoihjejtjlktjktpsptpuoiafwjlidrdpdiesk
```

### Displaying
The next thing I'm going to ask the envelope tools to do is to format that. And there's a `format` command, but it's the default command. So I don't really need to enter it pretty much ever. So if I just ask it to format the Alice knows Bob, then I get  an output like this.

[**▶️ envelope format:**](https://youtu.be/K2gFTyjbiYk?t=150)

```
$ envelope format $ALICE_KNOWS_BOB
"Alice" [
    "knows": "Bob"
]

$ envelope $ALICE_KNOWS_BOB
"Alice" [
    "knows": "Bob"
]
```

This is called "envelope notation." And this case you see  this is the subject, the predicate, and the object. Because there can be more than one assertion (and remember an assertion is a predicate and an object together), if there are additional lines here, those are the additional assertions.

Now the first envelope I created up here has no assertions on it: it's just the subject. So if I type envelope and then enter the envelope directly on the command line, I get back just the subject. Hello.

```
$ envelope ur:envelope/tpuoiyfdihjzjzjldmgsgontio
"Hello."
```

So the format you see here is called "envelope notation". In the case, when you just say "envelope" and then an envelope UR, you get back the the entire envelope in a human readable representation. It's not the binary representation, it's not roundtrippable, it's not the full representation of the CBOR, but it's designed so you can get an idea of the overall structure of the envelope very quickly.

### Extraction

But sometimes what you want to do is you want to extract parts of the envelope. The easiest thing to extract in an envelope is it's subject. So if I say "envelope extract" for Alice knows Bob, I get back just the bare string that is the subject. 

[**▶️ envelope extract:**](https://youtu.be/K2gFTyjbiYk?t=211)

```
$ envelope extract $ALICE_KNOWS_BOB
Alice
```


So far, I've been working with strings, but if you ask for help, "envelope help subject (where `subject` is the command we used above to create the first hello string), then we see that it has a couple sub-commands, "single" and "assertion".

```
$ envelope help subject
OVERVIEW: Create an envelope with the given subject.

USAGE: envelope subject <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  single (default)        Create an envelope with the given subject.
  assertion               Create an envelope with the given assertion
                          (predicate and object).

  See 'envelope help subject <subcommand>' for detailed help.
```


So you can  create an assertion, which is a predicate-object pair, or you can create a a new envelope with just the given subject. 

Let's ask for help on that "envelope help subject single". 
```
$ envelope help subject single
OVERVIEW: Create an envelope with the given subject.

USAGE: envelope subject single [<options>] [<value>]

ARGUMENTS:
  <value>                 The value for the Envelope's subject.

OPTIONS:
  --assertion/--cbor/--cid/--data/--date/--digest/--envelope/--float/--int/--known-predicate/--object/--predicate/--string/--ur/--uri/--uuid/--wrapped
                          The data type of the subject. (default: string)
  --tag <tag>             The integer tag for an enclosed UR.
  -h, --help              Show help information.
```

Now we see that there's a whole bunch of data types that are supported by this: "string" is the default, and the one that we've been using, but there are all kinds of other data types — and I'm still adding new ones for integers, dates, and various kinds of data, and, of course, any arbitrary CBOR that you'd like to include. So envelope is a very flexible structure and it's binary at its core, even though I'm going to be working a lot with strings here in this demonstration.

Just like the `subject` command,lets you work with data types, the `extract` command also lets you work with data types. So if I said `envelope extract` and the type `envelope` using the Alice knows Bob example, I get back another envelope.

[**▶️ envelope extract --envelope:**](https://youtu.be/K2gFTyjbiYk?t=280)
```
$ envelope extract --envelope $ALICE_KNOWS_BOB
ur:envelope/tpuoihfpjziniaihoxweclfg
```

This is not the same envelope as I got back before. Let's `format` that envelope and you see it's just the subject: it's Alice and you see it surrounded by quotes. 

```
$ envelope ur:envelope/tpuoihfpjziniaihoxweclfg
"Alice"
```

That means this is envelope notation. If it weren't surrounded by quotes, it would just be the actual bare subject. Again, this will become clear as we continue.

### Creation with Assertions

So how would we create an envelope with an assertion? To do so, we say `envelope subject "Alice"`, and then we're using the the Unix pipe character here. We're  going to to pipe it to another invocation of envelope where we're going to say `assertion`, and then we're going to add an assertion, `"knows" "Bob"`.

[**▶️ envelope assertion:**](https://youtu.be/K2gFTyjbiYk?t=309)
```
$ envelope subject "Alice" | envelope assertion "knows" "Bob"
ur:envelope/lftpsptpuoihfpjziniaihtpsptputlftpsptpuoihjejtjlktjktpsptpuoiafwjlidrdpdiesk
```

So we're going to basically going to recreate that original "Alice knows Bob" envelope. And in fact, if I `echo $ALICE_KNOWS_BOB`, you see it is in fact the exact same envelope that we just recreated.

```
$ echo $ALICE_KNOWS_BOB
ur:envelope/lftpsptpuoihfpjziniaihtpsptputlftpsptpuoihjejtjlktjktpsptpuoiafwjlidrdpdiesk
```

If I copy the `assertion` command (I'll use history here) and then pipe that to `envelope` again (remember that `format` is the default), we get the same envelope notation back.

```
$ envelope subject "Alice" | envelope assertion "knows" "Bob" | envelope
"Alice" [
    "knows": "Bob"
]
```

So `envelope` includes a number of different ways of working with assertions as seen with `envelope help assertion`.
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
It's got `add`, which is what we've already used, as it's the default. It also got: `add`; you can `count` the assertions; you can retrieve the assertion at a particular index; you can return all the assertions; or you can find an assertion matching particular criteria. We'll talk about that a little bit later. 

### Digests

Now let's talk about digests. An envelope, and every part of an envelope, produces a unique digest. So if we type this command `envelope digest` for Alice knows Bob, we get back a different kind of UR, a UR crypto digest. this is the encoded BLAKE3 hash of the entire envelope.

[**▶️ envelope digest:**](https://youtu.be/K2gFTyjbiYk?t=372)
```
$ envelope digest $ALICE_KNOWS_BOB
ur:crypto-digest/hdcxvwgtjltemnnlgmwttslynblpgamugszmtdlkmnckwkatmelbpdwljnynnehedrmhnnlfmthl
```

You may recall that when we ran `envelope extract --envelope` for Alice knows Bob, we got back just the subject of the envelope as an envelope. If we pipe that to the same command we used above, `envelope digest`, we get back a different digest. 

```
$ envelope extract --envelope $ALICE_KNOWS_BOB | envelope digest
ur:crypto-digest/hdcxdilraxgdgeteptptsagscwecotiofmwycmhthlgmfhlgdrhhyktojntdhtemwnbeoscxeonl
```

When you're comparing crypto digests, the first few characters will be the same because that's CBOR header information. But the last eight characters will always be different because they are a CRC-32. So if you quickly look at the end of a crypto digest, you'll always be able to tell whether the two are the same. In this case, obviously they're not: we extracted a different digest. Remember, the envelope Alice knows Bob contains the subject and an assertion. The first is the digest of that entire envelope. The second is just the digest of the envelope, which is the subject.

Just for reference, let's look at the envelope notation again.
```
$ envelope $ALICE_KNOWS_BOB
"Alice" [
    "knows": "Bob"
]
```

Now let's type in more complex command to extract another digest.
[**▶️ envelope digest of object:**](https://youtu.be/K2gFTyjbiYk?t=433)
```
$ envelope assertion at 0 $ALICE_KNOWS_BOB | envelope extract --object | envelope digest
ur:crypto-digest/hdcxnyktchbzfsknehpfesaebyfpfrurmdaezmgtlojosfwnaoplehwdoyihpydaurcybzaaqzko
```
What we're doing here is we're saying `envelope assertion at zero`, which means we're extracting the first assertion, which is the envelope we're extracting from. And then we're going to pipe that into `envelope extract --object`, which you now remember, this is a predicate and an object, so we're going to get the envelope this is just the Bob string. And then we're going to ask for the digest. 

So this is basically saying, get the first assertion, extract the object of that assertion,  and show us the digest. When we run this, we get a third digest.

So this is how you can drill down into an envelope and ask for a digest. Because every assertion of an envelope has to be unique, and there are no duplicate assertions, every assertion is guaranteed to have unique digest.

### Elision

Let's talk a little bit about elision. Since we know how to get digests, we can transform an envelope in interesting ways. Elision means removing various parts of the envelope without changing its digest. To do this, we use the `elide` command.

For these examples, I'm going to place the subject digest of our envelope into a shell variable:

```
$ SUBJECT_DIGEST=`envelope extract --envelope $ALICE_KNOWS_BOB | envelope digest`
$ echo $SUBJECT_DIGEST
ur:crypto-digest/hdcxdilraxgdgeteptptsagscwecotiofmwycmhthlgmfhlgdrhhyktojntdhtemwnbeoscxeonl
```

If we want to produce a version of the envelope with its subject elided, we now provide that digest to the `elide removing` command and that looks like this: `envelope elided removing` with the envelope to elide and the subject digest. Then we're going to pipe that directly into the `envelope format` command so we can see what the result is. 

[**▶️ envelope elide removing:**](https://youtu.be/K2gFTyjbiYk?t=518)
```
$ envelope elide removing $ALICE_KNOWS_BOB $SUBJECT_DIGEST | envelope
ELIDED [
    "knows": "Bob"
]
```
And as we can see, the subject has been elided. It's literally not there anymore, but its digest still is. So the Merkel tree of the envelope is still the same.

We can actually provide any number of digests as the target set. Because we're using `elide removing`, it basically means it's going to go through the envelope recursively, and if it finds any sub envelopes that match anything in the target set, it will elide it.

There's also another command called `elide revealing`, which does the opposite. It's more useful in cases where you just want to reveal particular things about an envelope. If something's not in the revealed target set, then it gets elided.

For example, here we're going to provide two different digests. The first is for the subject as we did above and the second represents the object of the assertion. (Remember that we we already extracted that once.) 

So there's our Bob digest. Now we're going to `elide removing` from this envelope, the subject and the Bob object and then pass that to format. 

[**▶️ envelope elide removing, multiple targets:**](https://youtu.be/K2gFTyjbiYk?t=546)

```
$ BOB_DIGEST=`envelope assertion at 0 $ALICE_KNOWS_BOB | envelope extract --object | envelope digest`
$ envelope elide removing $ALICE_KNOWS_BOB $SUBJECT_DIGEST $BOB_DIGEST | envelope
ELIDED [
    "knows": ELIDED
]
```
So here we have it: the subject is elided and so is the object. All we have left is the predicate. 

This is important: the elided version of the envelope we produced has the same digest as the original non-elided envelope. This means that things like cryptographic signatures that you added to the envelope as assertions, unless they're themselves elided, will still verify. 

Let's compare the original envelope's digest to the elided version's digest. Let's get back the digest of Alice knows Bob. And then we're going to compare that to the digest of the envelope that's been elided. Again, `envelope elide removing` passed with the envelope, the subject, and the object. We pass that to the `format` command and we get the exact same digest as we did before.

```
$ envelope digest $ALICE_KNOWS_BOB
ur:crypto-digest/hdcxvwgtjltemnnlgmwttslynblpgamugszmtdlkmnckwkatmelbpdwljnynnehedrmhnnlfmthl
$ envelope elide removing $ALICE_KNOWS_BOB $SUBJECT_DIGEST $BOB_DIGEST | envelope digest
ur:crypto-digest/hdcxvwgtjltemnnlgmwttslynblpgamugszmtdlkmnckwkatmelbpdwljnynnehedrmhnnlfmthl
```

Even though we've literally removed information, we're still getting the same digest overall.

### Encryption

Now let's talk about symmetric key encryption. The `envelope` tool provides two commands: `encrypt` and `decrypt` to perform symmetric key encryption of the envelope subject.

If you type `envelope help`. You'll see that it has the `generate` command. This is  a set of utilities to generate and convert various objects. Then I type `envelope help generate`.
```
$ envelope help generate
OVERVIEW: Utilities to generate and convert various objects.

USAGE: envelope generate <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  cid                     Generate a Common Identifer (CID).
  digest                  Generate a digest from the input data.
  key                     Generate a symmetric encryption key.
  nonce                   Generate a Number Used One (Nonce).
  prvkeys                 Generate a private key base. Generated randomly, or
                          deterministically if a seed is provided.
  pubkeys                 Generate a public key base from a public key base.
  seed                    Generate a seed.

  See 'envelope help generate <subcommand>' for detailed help
  ```

You can generate: a common identifier; digest; symmetric encryption keys; nonce; private key; public key; bases; and seeds. For now let's just generate a random symmetric encryption key. I'm going to `envelope generate key` and store that in a variable.

[**▶️ envelope generate key:**](https://youtu.be/K2gFTyjbiYk?t=682)
```
$ KEY=`envelope generate key`
Mac-mini:~ shannona$ echo $KEY
ur:crypto-key/hdcxkolsgshsprjkfgeetbmtgyrsyldksrrnkezcprisykpebylapmfhaondpslakggmstrhrphp
```
(Key generated is different than the one in the video, and thus resultant URs will be as well.)

Here we see it's a `ur:crypto-key`. Once we have this, we can produce a version of our example envelope that has its subject encrypted by handing `envelope encrypt` the name of our envelope and then the key we're going to use.

We can then reveal the result with `envelope format`.

[**▶️ envelope encrypt:**](https://youtu.be/K2gFTyjbiYk?t=698)
```

$ ENCRYPTED=`envelope encrypt $ALICE_KNOWS_BOB --key $KEY`
Mac-mini:~ shannona$ envelope $ENCRYPTED
ENCRYPTED [
    "knows": "Bob"
]
```

It's the same envelope. In fact, it has the same hash, but now the subject is not `ELIDED` as we saw before. The data is still there, but it's `ENCRYPTED` with that symmetric key. 

It's important to realize that when you encrypt, the encryption process uses random data, a nonce or "number used once", and this keeps people from correlating separately encrypted things, but the hash remains the same. 

So for example, I encrypt the Alice Knows Bob example. This is the same envelope we just produced before: it has the same data. But if I do it again, you'll see that we have different data. 
```
$ envelope encrypt $ALICE_KNOWS_BOB --key $KEY
ur:envelope/lftpsptpsolrgejpioosinoxbghsiedmfggsdalpgldkdrdlbdhlpaotvltegdmwgyswkgvesokeemglcyvddmswimjlkohddktpsbhdcxdilraxgdgeteptptsagscwecotiofmwycmhthlgmfhlgdrhhyktojntdhtemwnbetpsptputlftpsptpuoihjejtjlktjktpsptpuoiafwjlidmylebbol
$ envelope encrypt $ALICE_KNOWS_BOB --key $KEY
ur:envelope/lftpsptpsolrgesrcnbwpthyeovshndtpfgsfnwzeyrebzftmdcxbncweyhegdbdiokndtpyskvwtdlnlprlbwmngemnpdhddktpsbhdcxdilraxgdgeteptptsagscwecotiofmwycmhthlgmfhlgdrhhyktojntdhtemwnbetpsptputlftpsptpuoihjejtjlktjktpsptpuoiafwjlidwtflftms
```

Again, you don't need to look at the whole UR. All you'd ever need to look at is the last eight characters. Even the last three or four characters is probably enough to tell if are the same.

This is the exact same envelope encrypted with the exact same key. And yet it's two different sets of data. And that's because encryption uses random information, but the envelope that's been encrypted is still the same envelope, and it has the same hashes as well.

If I get the digest of the whole envelope, and then I also produce the digest of the encrypted version of the envelope, you can see that these two hashes are the same.

```
$ envelope digest $ALICE_KNOWS_BOB
ur:crypto-digest/hdcxvwgtjltemnnlgmwttslynblpgamugszmtdlkmnckwkatmelbpdwljnynnehedrmhnnlfmthl
$ envelope encrypt $ALICE_KNOWS_BOB --key $KEY | envelope digest
ur:crypto-digest/hdcxvwgtjltemnnlgmwttslynblpgamugszmtdlkmnckwkatmelbpdwljnynnehedrmhnnlfmthl
```

When the digests are the same, you have the same data at the core, even though the actual encrypted data is different. 

Sometimes you  don't want the hash to be the same. And that's why you can add salt. We'll talk about salt later, but generally speaking, there's a number of different transformations you can do on envelopes (elision and encryption) that don't change the Merkel tree. And there are other things you can do, like adding assertions that do change it.

### Encryption with Wrapping

I mentioned that when we use the encrypt command, we're only encrypting the subject of the envelope you see here. So what if we want to encrypt the whole envelope? That's pretty easy as well, because we can actually wrap an envelope in an envelope. When we encrypt a wrapped envelope, we're encrypting everything inside it. So let's look at what a wrapped envelope looks like. 

[**▶️ envelope subject --wrapped:**](https://youtu.be/K2gFTyjbiYk?t=800)
```
$ WRAPPED=`envelope subject --wrapped $ALICE_KNOWS_BOB`
$ envelope $WRAPPED
{
    "Alice" [
        "knows": "Bob"
    ]
}
```
We've just created wrapped envelope and we're going to pass that to the `format` command. So now you see that there's an outer pair of curly braces here, and this means that this envelope that we've already become familiar with is now wrapped in an outer envelope. Whenever you have an envelope, you have can have assertions, so there could be also assertions added here as well. However, this outer envelope has no assertions. This inner envelope has one assertion.

When there's one or more assertions, you'll always see these square brackets. And whenever there's a wrapped envelope, you'll see these curly braces. 

Mow if we look at the digest of the wrapped envelope, you see it's different from the original envelope. That's because this is in fact a different envelope, it's got different data. You can't expect the same thing.
```
$ envelope digest $ALICE_KNOWS_BOB
ur:crypto-digest/hdcxvwgtjltemnnlgmwttslynblpgamugszmtdlkmnckwkatmelbpdwljnynnehedrmhnnlfmthl
$ envelope digest $WRAPPED
ur:crypto-digest/hdcxdsdacwememuoztpkmsamkbkolbutoxjztagmjymdjsmkdinlrnmokbjtttemdwdigsimfets
```

To use the contents of the inner envelope, you'd have to unwrap it, and we'll talk about that in a bit. 

If we want to encrypt the wrapped envelope, here's the command to do that: we encrypt the wrapped envelope with the same symmetric key we've been using. 

[**▶️ envelope subject --wrapped with encryption:**](https://youtu.be/K2gFTyjbiYk?t=868)
```
$ WRAPPED_ENCRYPTED=`envelope encrypt $WRAPPED --key $KEY`
$ envelope $WRAPPED_ENCRYPTED
ENCRYPTED
```

Here the envelope notation just says it's `ENCRYPTED`. That's the whole envelope. It's the outer envelope and everything inside it, but it's now been encrypted.

If we actually compare the digest of the wrapped envelope to the digest of the wrapped encrypted envelope, they are the same.
```
$ envelope digest $WRAPPED
ur:crypto-digest/hdcxdsdacwememuoztpkmsamkbkolbutoxjztagmjymdjsmkdinlrnmokbjtttemdwdigsimfets
$ envelope digest $WRAPPED_ENCRYPTED
ur:crypto-digest/hdcxdsdacwememuoztpkmsamkbkolbutoxjztagmjymdjsmkdinlrnmokbjtttemdwdigsimfets
```

If we want to recover the original envelope, we have to reverse the steps. First we decrypt. Then we unwrap.

So here in the first line, we're going to `envelope decrypt`, the wrapped, encrypted envelope with the key. Then we say `envelope extract --wrapped` and that unwraps the envelope. Now we `format` the contents. And there's our original envelope back.

[**▶️ envelope decrypt:**](https://youtu.be/K2gFTyjbiYk?t=898)

```
$ envelope decrypt $WRAPPED_ENCRYPTED --key $KEY | envelope extract --wrapped | envelope
"Alice" [
    "knows": "Bob"
]
```

### Signatures

Now let's talk about signatures. We were using symmetric key encryption; signatures are one way of using public key encryption. To use public key encryption you need both a private key and public key. Let's start by noting that the `generate` tool let's you generate private keys.

[**▶️ envelope generate prvkeys:**](https://youtu.be/K2gFTyjbiYk?t=934)
```
$ envelope generate prvkeys
ur:crypto-prvkeys/hdcxkildfxwednsodktnrotpkppsrsrnoszewfeypekstlfrfllsbbtlpdltsbeowntljllrytio
```

This is a `ur:crypto-prvkeys` or private key base. And you can generate public keys from this. 

There are also ways of generating private keys. For example, if you're familiar with the [Blockchain Commons Seed Tool](https://github.com/BlockchainCommons/seedtool-cli), its seed is a starting point for a lot of things. 

For example, if we take a seed that was generated using Seed Tool, then we can also generate private keys using the same `envelope generate` command, but we're going to use the seed here and assign the result to a shell variable.

[**▶️ envelope generate prvkeys from seed:**](https://youtu.be/K2gFTyjbiYk?t=946)
```
$ SEED=ur:crypto-seed/oyadgdmdeefejoaonnatcycefxjedrfyaspkiakionamgl
$ PRVKEYS=`envelope generate prvkeys $SEED`
$ echo $PRVKEYS
ur:crypto-prvkeys/gdmdeefejoaonnatcycefxjedrfyaspkiawdioolhs

```
This was created using a shorter seed, which is why it's shorter. It's still very secure: it's using at least 16 bytes of randomness. 

So now that we have a private keys, we're going to want to distribute the public key version of this: we're going to sign with a private key and verify signatures with the public keys. 

Here's how we would generate our public keys from our private keys: we `generate pubkeys` with our private keys. 

[**▶️ envelope generate pubkeys:**](https://youtu.be/K2gFTyjbiYk?t=972)
```
$ PUBKEYS=`envelope generate pubkeys $PRVKEYS`
$ echo $PUBKEYS
ur:crypto-pubkeys/lftaaosehdcxbansurpspfeccabtbtjteopdwpwtsfskdretfewyktlssksflspmahpdjefpghwptpvahdcxrtuoiddkgsoxzegughnszmfzgobnvlkpjscyrokesgnnkslumshnrfgtgmsfcnfgbzmdvyvw
```

The public key bases are a bit longer than private keys, but this lets other people who receive them both encrypt data to us as well as verify signatures from us.

Now we can actually sign our envelope. Here's the command to do that: `envelope sign` the name of our envelope with `--prvkeys` and our private keys. So before we said, `--key` for symmetric key encryption, here we're signing with our `--prvkeys`.

[**▶️ envelope sign:**](https://youtu.be/K2gFTyjbiYk?t=1003)
```
$ SIGNED=`envelope sign $ALICE_KNOWS_BOB --prvkeys $PRVKEYS`
Mac-mini:~ shannona$ envelope $SIGNED
"Alice" [
    "knows": "Bob"
    verifiedBy: Signature
]
```

Now we have Alice knows Bob verified by signature. That looks pretty good, except one problem. This is added as an assertion, but what does it verify? Does it verify "knows Bob"? Does it verify "Alice"? The answer is that the assertions apply to the subject. In this case, verified by signature only applies to the subject: "Alice".

The assertion "knows Bob" could be changed and not invalidate the signature. Additional assertions could be added and not invalidate the signature. Only if "Alice" is changed, will the signature fail to verify.  

How do we get around this? We have wrapping and it's wrapping to the rescue. We wrap the envelope first and then we pipe that to `envelope sign` with private keys, just like we did a moment ago. 
```
$ WRAPPED_SIGNED=`envelope subject --wrapped $ALICE_KNOWS_BOB | envelope sign --prvkeys $PRVKEYS`
$ echo $WRAPPED_SIGNED
ur:envelope/lftpsptpvtlftpsptpuoihfpjziniaihtpsptputlftpsptpuoihjejtjlktjktpsptpuoiafwjlidtpsptputlftpsptpuraxtpsptpuotpuehdfzsbfrettdihtkmsssjputfdtkhscnsnwzvtondthtcxhleswshhhhlpotkirsludihejedyrfbzjtrfihmskkoncfqzfyjykeylqdfrrsoedsckndbewlsajytemnvllddrsahhdm
$ envelope $WRAPPED_SIGNED
{
    "Alice" [
        "knows": "Bob"
    ]
} [
    verifiedBy: Signature
]
```

We've wrapped the envelope, including its assertions, and then we've signed that. So now our original envelope is all enclosed in this outer envelope. And then this new assertion, `verifiedBy` and then the signature, has been added to that. Now nothing in this can change without invalidating the signature.

So if we send this to someone who has her public key, they can now verify the signature. How would they do that? We use the command `envelope verify` with the wrapped signed envelope, and the public keys we generated above here. 

[**▶️ envelope verify:**](https://youtu.be/K2gFTyjbiYk?t=1094)
```
$ envelope verify $WRAPPED_SIGNED --pubkeys $PUBKEYS
ur:envelope/lftpsptpvtlftpsptpuoihfpjziniaihtpsptputlftpsptpuoihjejtjlktjktpsptpuoiafwjlidtpsptputlftpsptpuraxtpsptpuotpuehdfzsbfrettdihtkmsssjputfdtkhscnsnwzvtondthtcxhleswshhhhlpotkirsludihejedyrfbzjtrfihmskkoncfqzfyjykeylqdfrrsoedsckndbewlsajytemnvllddrsahhdm
```

The fact that it printed back the original envelope means that verification passed. The reason why it does this is so that you can continue to use the pipe character to pipe this to other things in your script. If verification fails, the shell script will exit with an error. 

If for some reason you don't want to do that, you can always use the `--silent` flag, and then it will still exit with an error if the verification fails, but it won't print the envelope if it succeeds. 

```
$ envelope verify $WRAPPED_SIGNED --pubkeys $PUBKEYS --silent
```

Let's generate a bad set of public keys here, and then we're going to try to verify our envelope with the wrong keys. We get `unverifiedSignature`.
```
$ BAD_PUBKEYS=`envelope generate prvkeys | envelope generate pubkeys`
Mac-mini:~ shannona$ envelope verify $WRAPPED_SIGNED --pubkeys $BAD_PUBKEYS
Error: unverifiedSignature
```
So that's what it looks like when a signature fails to verify. That could happen because you're using the wrong key to verify or the wrong public keys to verify, or it could happen because the envelope's been tampered with.

### SSKR Sharding

Okay, so let's talk a little bit about backing up.

Blockchain Commons has SSKR, our Sharded Secret Key Reconstruction technology. SSKR lets you "shard" an envelope into several shares. I can take a secret which is one envelope and turn it into three envelopes, which I can distribute among three friends.

Then if I ever need to recover them, I only need to say, get two of them back. Any two of them will do, but any of my friends can't use their individual envelope to recover my secret. So, how would that look? Sharding envelopes is done using the `envelope sskr split` command.

[**▶️ envelope sskr split:**](https://youtu.be/K2gFTyjbiYk?t=1189)
```
$ SHARE_ENVELOPES=(`envelope sskr split -g 2-of-3 $ALICE_KNOWS_BOB`)
```

We're specifying a group of two of three. So we're going to make three envelopes, any two of which are necessary. Then `$ALICE_KNOWS_BOB` is the envelope that we are sharding. Then we're taking the results of this command and the outer parentheses mean assign this as an array to this variable, `$SHARE_ENVELOPES`.

If we just `echo $SHARE_ENVELOPES`, we're going to get a long set of strings here. 
```
$ echo $SHARE_ENVELOPES
ur:envelope/lftpsptpsolrhddkwngmhehnldwlbwsejsrnlesbjkhhcmcxlnnblrgyjlmsfywktotpqzsakbdwashtdnfyrlplgststyvsldhltidltdgmfsonaxgdvwkthkkgfplsfytssrnbbksaonnnmnfwhddktpsbhdcxdsdacwememuoztpkmsamkbkolbutoxjztagmjymdjsmkdinlrnmokbjtttemdwditpsptputlftpsptpuramtpsptpuotaadechddafmjeaeadaefmtndtaacwpavanlflltwzbavsnyjomhuemhhfdwnyjpctjosouokogsemyabyjtgmtepyen
```

Notice this is a `ur:envelope` and there's a space and another UR envelope and then a space and another UR envelope. So these are space separated, but this is also in an array now.

Let's make this a little bit simpler. We're going to use three commands to assign elements of that array to three separate shell variables. 
```
$ SHARE_1=${SHARE_ENVELOPES[0]}
$ SHARE_2=${SHARE_ENVELOPES[1]}
$ SHARE_3=${SHARE_ENVELOPES[2]}
$ echo $SHARE_1
ur:envelope/lftpsptpsolrhddkwngmhehnldwlbwsejsrnlesbjkhhcmcxlnnblrgyjlmsfywktotpqzsakbdwashtdnfyrlplgststyvsldhltidltdgmfsonaxgdvwkthkkgfplsfytssrnbbksaonnnmnfwhddktpsbhdcxdsdacwememuoztpkmsamkbkolbutoxjztagmjymdjsmkdinlrnmokbjtttemdwditpsptputlftpsptpuramtpsptpuotaadechddafmjeaeadaefmtndtaacwpavanlflltwzbavsnyjomhuemhhfdwnyjpctjosouokogsemyabyjtgmtepyen
```

Now if I just echo share one, that's just a single envelope and share two and three are the same — or similar, they're obviously not the same envelope. But each of them only has part of the key in it — not even a part it's mathematically sharded so that you can't even determine anything about the original secret from any of the parts.

So what does it look like if we format one of these envelopes?
```
$ envelope $SHARE_1
ENCRYPTED [
    sskrShare: SSKRShare
]
```
We have an encrypted message (you've seen that already) and an `sskrShare`. An `sskrShare` is just one of those shares that our process of sharding created. Inside that is the actual symmetric key needed to unencrypt this. If you only have one of these, because we said two of three, that's not enough to retrieve that secret and decrypt the original message. 

### SSKR Recovery

If we wanted to, say, take share one and share three and actually recover the original, we could do it this way: `sskr join` and then the two shares. 

[**▶️ envelope sskr join:**](https://youtu.be/K2gFTyjbiYk?t=1284)

```
$ RECOVERED=`envelope sskr join $SHARE_1 $SHARE_3`
$ envelope $RECOVERED
"Alice" [
    "knows": "Bob"
]
```
We've recovered our original secret!

But let's assume one of our friends tries to recover the secret using just the share you gave them. 
```
$ envelope sskr join $SHARE_2
Error: invalidShares
```
In this case, it says `invalidShares`. 

But if you added share one or share three to this, it would work. So for example, let's take, share three, add that: there it is.
```
$ envelope sskr join $SHARE_2 $SHARE_3
ur:envelope/lftpsptpuoihfpjziniaihtpsptputlftpsptpuoihjejtjlktjktpsptpuoiafwjlidrdpdiesk
$ envelope sskr join $SHARE_2 $SHARE_3 | envelope
"Alice" [
    "knows": "Bob"
]
```

So any two of three!

SSKR is very flexible. You can have more than one group. You can have two of three and three of five with a threshold of one group or two groups. There's quite a few different ways [to use SSKR](https://github.com/BlockchainCommons/SmartCustody/blob/master/Docs/SSKR-Sharing.md).

### Salts

So finally, I want to talk a little bit about salt. 

Envelopes with the same content produce the same digests, even when they've been elided or encrypted, and this can make identical or even similar envelopes correlatable. That means somebody can tell that they contain the same message even though they're in different forms: one's encrypted, one's not for instance. 

Let's take the previous example. Here we have a wrapped envelope and we're going to encrypt that. Then we're going to print out both digest of the wrapped envelope and the encrypted envelope.
```
$ WRAPPED=`envelope subject --wrapped $ALICE_KNOWS_BOB`
$ ENCRYPTED=`envelope encrypt $WRAPPED --key $KEY`
$ envelope digest $WRAPPED; envelope digest $ENCRYPTED
ur:crypto-digest/hdcxdsdacwememuoztpkmsamkbkolbutoxjztagmjymdjsmkdinlrnmokbjtttemdwdigsimfets
ur:crypto-digest/hdcxdsdacwememuoztpkmsamkbkolbutoxjztagmjymdjsmkdinlrnmokbjtttemdwdigsimfets
```

As you can see, they have the same digests. That's very useful in certain cases, but if you don't want that to be correlatable this way, you can use salt. 

The `salt` command lets us add an assertion with random data. If we do this before we encrypt, the unencrypted subject will be the same, but the digest will be different.

So here we are saying `envelope salt` for Alice Knows Bob. This is going to add another assertion with random data to it. And then we're going to wrap that. 

We can now look at the results.

[**▶️ envelope salt:**](https://youtu.be/K2gFTyjbiYk?t=1379)

```
$ SALTED_WRAPPED=`envelope salt $ALICE_KNOWS_BOB | envelope subject --wrapped`
$ envelope $SALTED_WRAPPED
{
    "Alice" [
        "knows": "Bob"
        salt: Salt
    ]
}
```
There's the outer envelope we've we added secondly, and there's the salt. And this changes the digest of the entire envelope.

Now if we encrypt that and if we compare the one we wrapped and encrypted with the one we salted, wrapped, and ecnrypted, we have two different digests.
```
$ SALTED_ENCRYPTED=`envelope encrypt $SALTED_WRAPPED --key $KEY`
$ envelope digest $ENCRYPTED; envelope digest $SALTED_ENCRYPTED
ur:crypto-digest/hdcxdsdacwememuoztpkmsamkbkolbutoxjztagmjymdjsmkdinlrnmokbjtttemdwdigsimfets
ur:crypto-digest/hdcxiyrdinldjpgosadkjshnwefdcychwphpkogwmydtbdgssadlahnlprhdjplflkrswernpmim
```

Even when it encrypted, it doesn't match because we added the salt. So salting is a very convenient way of making sure that even the digests are different.

Remember encryption uses random data to perform the actual encryption without disturbing the original data, but the digest remains the same in an envelope. So you add salt if you don't want either of those to be correlatable.
