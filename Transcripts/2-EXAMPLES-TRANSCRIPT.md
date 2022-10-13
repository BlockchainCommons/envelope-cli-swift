# TRANSCRIPT: Gordian Envelope CLI - 2 - Examples

[![Gordian Envelope CLI - 2 - Examples](https://img.youtube.com/vi/LYjtuBO1Sgw/mqdefault.jpg)](https://www.youtube.com/watch?v=LYjtuBO1Sgw)

_Part of the [Envelope-CLI Playlist](https://www.youtube.com/playlist?list=PLCkrqxOY1FbooYwJ7ZhpJ_QQk8Az1aCnG)._

## Description

Examples of using the Gordian Envelope-CLI (command line interface) tool.

Envelopes are a new type of “smart document” to support the storage, backup, encryption & authentication of data, with explicit support for Merkle-based selective disclosure. It’s part of the Gordian Architecture led by Blockchain Commons. `envelope`, is CLI ( command-line interface) reference tool for creating and verifying cryptographic envelopes.

This video offers examples of the the Gordian Envelope-CLI (command line interface) tool, `envelope`, which can be used to create and verify cryptographic envelopes.

* [Brief Overview of These Examples](https://github.com/BlockchainCommons/envelope-cli-swift/blob/master/Docs/2-BASIC-EXAMPLES.md)

**Other Overview Docs:**

* [Gordian Envelope-CLI — Repo for the CLI program](https://github.com/BlockchainCommons/envelope-cli-swift)
* [Gordian Envelope Docs — Swift Library and Specs](https://github.com/BlockchainCommons/BCSwiftSecureComponents/tree/master/Docs)
* [Gordian Architecture — Overview of Entire Design](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Overview-Architecture.md)

## Unedited Transcript

 Hi, I'm Wolf McNally. In my previous video, I gave you an overview of many of the commands in the envelope command line interface tool. In this one, I'm going to go through a series of increasingly complex, practical examples of basic scenarios you could use the tool in. 

A lot of these examples use a number of pre-made keys; I have a pre-made plaintext, and a bunch of seeds, public keys, private keys, things like that. So I'm just going to paste those into the terminal now.

And you can see that I have one here called plaintext hello. We're going to be using that a lot, and then we have our characters: Alice, Bob, Carol. We have a generic cryptographic ledger service, and we have an example governmental state. And these are their common identifier, which is a cryptographically random identifier, a seed from which they used to generate their private keys, their private key base and their public key base, which they can distribute.

And so that's basically what you're seeing for these various actors here, as well as our piece of plaintext. So I'm just going to execute that. So those are all in shell variables now, so we can actually get started. 

### Plaintext

So the first thing I want to show is just how to send and receive a plaintext message.

If you saw the previous video, then you'll recognize this it's pretty straightforward. We're going to call the envelope tool, give it the subject command and feed it an existing string, in this case is just the plaintext string hello, and we're going to assign that to a shell variable. And then if we echo that we get a short UR, which is just the actual encoded envelope. So if Alice had created this envelope and she wanted to send this to Bob and Bob received it, then he could just simply extract the subject directly like this: envelope extract, hello envelope. And there's the original message that was encoded.

### Signed Plaintext

So example two: signed plaintext. Now we did a little bit of signing before, so this is kinda a bit of recap. So we're going to create an envelope, which has the subject plaintext hello. We're going to pipe this into signing with Alice's private keys.

And then again, this is just a somewhat longer envelope. And if we format this envelope, we have the subject and then we have a signature. So when Bob receives this, he could run this, see what he is looking at there, and then he can verify the signature using Alice's public key. Notice that I'm using the silent flag here, so it doesn't print back the envelope to me; because when we're piping from command to command, we often want the envelope to continue through the pipes. In this case, we're just checking to make sure the signature's correct from the command line, since we didn't get any output, that means it's correct. 

So once Bob has verified the signature, then again, he uses exact same command to extract the subject, which is the plaintext message.

If another actor tried to verify using the wrong public key, like Carol's public keys, then we would get unverified signature. 

The tool also lets you actually use sets of signatures. So since you can have one signature, you can have multiple signatures and there's different ways of checking signatures. So for example, if you want to check to see if it was signed by Alice or Carol, here's the command line that would do that: `envelope verify`. This is the sign envelope with a threshold of one. And then we give two sets of public keys for Alice and Carol. And so as long as one of these  has been used to sign the envelope it succeeds.

But if we say, if we set that threshold to two, as we know, it was only signed by Alice, not Carol. So now it's going to say unverified signature because it didn't meet the threshold. 

### Multi Signatures

Okay, so moving on. We just talked about single signature. What if we want to multi-sign signatures? Here's a command that will create a multisig envelope, subject.

Here's the envelope that is the plaintext. So that creates the envelope. Then we sign it with two sets of private keys, Alice and Carol: Alice and Carol sign that and send it on to Bob. Bob receives the envelope, and checks it out and there's two different signatures now.

 Now you may have heard me say before that you aren't allowed duplicate assertions. Each assertion has to be unique. And so these look identical, but remember this is envelope notation, which basically means it's a high level human readable form for examining the structure of envelopes. But these are two different signatures made by two different keys. Two different time moments in time. Signing like encryption also uses random data. You can't see any of that here. If you examine the CBOR of the envelope, you'd see it.

But from this high level, point of view, all you can see is that there's two signatures. So then Bob can verify that it was signed by both parties. So here's a command he could use to do that envelope, verify the multi-signed envelope with these two public keys. And since we didn't use the silent flag, it prints back the envelope.

So once he has verified the signatures, he can extract the plaintext.

### Symmetric Encryption

All right. So now a little bit more symmetric encryption. If we have a new key and Alice sends an encrypted message to Bob, so you've envelope subject, the plaintext, and then immediately encrypt the envelope. 

Once Bob gets that envelope, he runs the message on it. He sees it's just an encrypted message. There's nothing else in it. But if Bob has the key, then he can decrypt the envelope: `envelope decrypt` with the encrypted envelope and the key. And now he can extract the subject of that and he gets back the original hello. 

So if there was an incorrect key attempted to be used and here we're actually generating an incorrect key on the fly, so we're saying envelope, decrypt, the encrypted envelope with a randomly generated key. We get invalid key.

### Signing, Then Encrypting

All right, moving on. When you have nested cryptographic structures, you can either decide to sign a structure and then encrypt the signed structure, or you can encrypt a structure and then sign the encrypted structure. So we're about sign then encrypt.

If Alice signs a plaintext message and then wraps it so that her signature will also be encrypted and then encrypts it, it looks like this.

So here she's creating the envelope. Here she signs it. Here she wraps it so that the entire envelope will encrypted and then she encrypts it. And so when Bob receives that and he examines the structure, it's just an encrypted message. The signature itself has also been encrypted. So first he has to decrypt it with the key.

Since this is a symmetric encryption. He also has the same key. He decrypts that. And now he can examine the structure of that envelope and he can see it's a wrapped envelope. And if he just wants to extract the subject, then he reverses the process. He says, envelope extract wrapped from the decrypted envelope and then verify Alice's signature. And if that succeeds then extract the subject. And that did succeed.

So if Bob tried to do that with anybody else's keys, for example, Carol's public keys, like in this example, he would get unverified signature. And in a script, if you have it terminate upon error, this envelope extract would never even happen. Your script would exit with an error condition.

So that was sign then encrypt. So we actually encrypted the signature, but if we want to do encrypt then sign, then it works a little bit differently.

### Encrypting, Then Signing

So here's a command that creates an envelope, encrypts just the subject: remember we only encrypt the subject, and then signs it which means we're adding a signature to the outside of the envelope.

And so if we actually look at the structure of that, we have encrypted message with a signature, so we can actually verify the signature without decrypting the message.

So Bob would then verify the signature first with Alice's public keys and then decrypt and then extract. So if the key didn't verify, then it wouldn't get to the point of decrypting or attempting to decrypt or extract.

If we did the exact same thing, but just use the format command. You'd see that we got back to the original envelope.

### Public-Key Encryption

So far we've been doing public key signing, but symmetric encryption. But of course, envelope also supports public key encryption. That is you use a public key to encrypt to a party who can only decrypt it with their private key. So here's an example of how you do that. 

So here's an envelope that's going to be sent to two possible recipients. So again, envelope, subject plane takes below that creates the envelope encrypt. In this case, we're not giving a key, we're giving a recipient, which is the public key base and another recipient, which is different public key base. So we're encrypting to Bob or Carol.

So let's say Bob gets the envelope and he examines its structure.

So here we have the encrypted message and we have not signatures this time, but we have has recipient predicates with sealed message objects. So there's two assertions. These are not identical assertions. These are in fact different because one's to Bob, and one's to Carol. And that the sealed message actually contains the public key encrypted symmetric key for the encrypted message. 

So if I have Bob's private keys, I can decrypt one of these two sealed messages, which contains the symmetric key, which lets me decrypt the subject. So let's say Bob does that.

In this case, he's going to say decrypt, this is the envelope he's decrypting. He's saying the recipient is Bob's private keys, and then he's going to extract the subject. There it is. 

Now let's say Alice actually sent this to Bob and Carol, but she didn't add a recipient for herself. So she herself can't even decrypt it. So envelope, decrypt, same envelope, but recipient is Alice's private keys: invalid recipient.

And this can work in various kinds of permutations as well. That's one of the nice things about envelope: it's all mixable, and matchable. 

### Signing & Public-Key Encryption

So for example, I could send to multiple recipients and sign it. So in this case, create the envelope, sign it, and then encrypt it to two different participants. How does that look?

So in this case, I have verified the subject with the signature and also made it so the subject can only be decrypted by one of my two recipients. So for example, Bob could verify the signature using Alice's public keys and assuming that passes, then he can decrypt to himself and then extract the subject.

So again, all these different techniques, envelope supports them all simultaneously, and you just opt into whichever ones you're interested in.

### Complex Metadata

Okay. So now let's look at an example of complex metadata, because envelope is a recursive structure, assertions can have assertions. So you're not restricted to semantic triples. You can have semantic quads, you can have multidimensional objects because anything is CBOR. Everything is structured, and there's no normalization. Everything about normalization that you would consider with things like JSON-LD and so on, is all baked in to the envelope structure. 

In this example, we're going to use common identifiers or CIDs to represent, structures that are in a database. They'd be a primary key. The data associated with the CID can change over time. So for example let's start with this this command. We're going to talk about a book. And so we have a CID we've already generated, and we're going to create an envelope with with its structure as that.

This is going to create the actual CID we're going to pipe that to envelope subject. And the subject is a UR, which is the CID. Trust me, this'll make sense in a moment. And we're going to add two assertions to it: dereferenceVia and hasName. 

Now, these are "known predicates." This is the type of data we're using here. And they basically encode to a single bite because they're well known. They're predefined the envelope tool knows them. You can always create your own predicates from strings or anything else actually, but there's also a set of known predicates, and this is a still growing and still very open to additions and suggestions by the community. So we'd like to know what you think ought to be, the canonical set of known predicates, and there'll be a process for adopting new ones as we go. 

We're going to create this envelope here in this multi-step process. And when we run that through the envelope formatting command, this is the envelope. The subject is our CID, and it's got two assertions: dereferenceVia and hasName. Now you notice that in the envelope notation, these are surrounded by quotes: that means these are actual strings. Whereas these are not surrounded by quotes, which means they're basically encoded known byte sequences.

But this basically says that whatever this thing is, you can find out more from the Library of Congress, but this thing has a name: Ayn Rand. So this is actually referring to the author.

So now we're going to create some more envelopes representing the name of a novel she wrote in two different languages, annotated with assertions that specify the language. So here's the first one. So NAME_EN for English envelope subject "Atlas Shrugged", piped to envelope, assertion, known predicate, language.

And then EN. So we're basically specifying the language of this string.

And that's what that envelope looks like. It's just a subject "Atlas Shrugged" with an annotation on it that says this name is in English. So now let's do the same thing for Spanish.

Envelope, subject, "La rebelión de Atlas" envelope, assertion, known predicate, language. "es": español.

Okay. So our strings can self-describe what language they are actually written in. So now we're going to create a large envelope that specifies known information about the novel. So this envelope embeds the previous envelopes we created for the author and the names of the work.

Let's go up here and edit this.

Here we go.  It's supposed to be called "work", not "ork". All right, so we're taking another CID and we're creating a UR from it to feed into the subject UR command. And again, this is because this work has a known identifier. And then we have a, "isA" novel, it has an ISBN number, and two of these predicates here are custom predicates, which are strings. The reason why I had to annotate string here is because I use the second annotation here, but by default, they're both strings. So if you're going to use, say envelope on the second one, because I want to embed this envelope here, you need to specify the first one as well.

In this case, I'm using several known predicates dereferenceVia, hasName. And I'm also using implicit strings here and here, but here I'm using explicit strings here and envelope type here. So anyway, the result of this is probably the most complex envelope we've seen so far. This represents the work. This is the common identifier of the work. It has a field called author. This is a custom predicate, which is made from a string, which this is the author's identifier. So if I want to look at more things by this author, I could use that identifier, how to find more information about the author, what her name is, then the ISBN of the work, where to find more information about the work, and then the two names. These are two different name assertions: hasName assertions. Remember, they're different. So they're okay. If they're identical, they wouldn't be allowed, but they're both different in terms of their subject as well as the assertions on them. So it's fine. And finally, an isA assertion to say what kind of work this is.

So now we have a a much more complex envelope, but we're not done yet.

So now we want to refer to a particular digital embodiment of this work. This is general information about the work, about the novel. So we now want to say we have an EPUB of the actual novel somewhere out in the cloud, and so we're going to just use a shorthand string for that. So we're going to say this is the entire book, Atlas Shrugged, in EPUB format.

Again, we're using a string, but CBOR is binary. So this could actually be literal binary. And then now we're going to calculate the digest of that. So we're going to say envelope generate digest from the book data. And this is the BLAKE3 digest. If we say echo book digest. So there's the crypto digest of the entire book.

And so now we're going to create a a book metadata envelope. And the subject of this is the  book digest. That means this refers not to like a CID the information on file about the author or about the work could change over time. Whereas this now referring to this, the subject as the digest of the actual work bit for bit, if it changed even one bit, the digest wouldn't match, so this is referring to an immutable object. And then we're adding several assertions, we're saying that the work predicate here is actually the envelope called work above. So we're actually going to embed this entire envelope in this new envelope. We're also going to search that the format of this is EPUB and that to find more information about this EPUB, or to dereference this particular digest, you can go to Interplanetary File System, or IPFS.

So now we have the digest, which is the subject, and then all these assertions about it, but there's only three: there's the format, what format it is, information about the work and how to get the actual object. Within the work assertion, its object is the identifier of the work, and then it contains the author, the ISBN, dereferenceVia, hasName again. You need a different language and what it is. This is a really good example of how you would actually represent very complex metadata: assertions on assertions, essentially. 

Next transcript is on [Elision](3-ELISION-TRANSCRIPT.md).

