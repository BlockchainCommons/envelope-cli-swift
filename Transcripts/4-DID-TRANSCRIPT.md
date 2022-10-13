# TRANSCRIPT: Gordian Envelope CLI - 4 - DID Example

[![Gordian Envelope CLI - 4 - DID Example](https://img.youtube.com/vi/Dvs2CT60_uI/mqdefault.jpg)](https://www.youtube.com/watch?v=Dvs2CT60_uI)

_Part of the [Envelope-CLI Playlist](https://www.youtube.com/playlist?list=PLCkrqxOY1FbooYwJ7ZhpJ_QQk8Az1aCnG)._

## Description

This is a video about Decentralized Identifiers in Gordian Envelopes, drawing upon the work on W3C DIDs.

Envelopes are a new type of “smart document” to support the storage, backup, encryption & authentication of data, with explicit support for Merkle-based selective disclosure. It’s part of the Gordian Architecture led by Blockchain Commons. `envelope`, is CLI ( command-line interface) reference tool for creating and verifying cryptographic envelopes.

Envelopes are a new type of "smart document" allowing for storage and encryption of data and authentication by a variety of means. It's part of the Gordian Architecture led by Blockchain Commons. 

This video offers an overview of the Gordian Envelope-CLI (command line interface) tool, `envelope`, which can be used to create and verify cryptographic envelopes.

* [Brief Overview of These Commands](https://github.com/BlockchainCommons/envelope-cli-swift/blob/master/Docs/5-DID-EXAMPLE.md)
* [W3C DIDs](https://www.w3.org/TR/did-core/)

**Other Overview Docs:**

* [Gordian Envelope-CLI — Repo for the CLI program](https://github.com/BlockchainCommons/envelope-cli-swift)
* [Gordian Envelope Docs — Swift Library and Specs](https://github.com/BlockchainCommons/BCSwiftSecureComponents/tree/master/Docs)
* [Gordian Architecture — Overview of Entire Design](https://github.com/BlockchainCommons/Gordian/blob/master/Docs/Overview-Architecture.md)

## Unedited Transcript

In this video, I'm going to give you an example that is inspired by the W3C DID (Decentralized Identifier) standard.

### Creating Alice

In this case, we have an entity, Alice, who wants to create a way of identifying herself to other people on the internet. And so the first thing she's going to do is create a self-signed certificate, a document that describes herself.

Obviously there'll probably be a lot more information in a document like this, but this is the unsigned version of the document: it has a subject, which is her CID. In the previous video at the beginning, you saw me pasted a whole bunch of other things.

There's an an Alice common identifier that's already available. But that's going to be the subject of the envelope. And then we're going to add two assertions: the controller, who controls this document, which is Alice again, and then her public keys. So she's saying that, if you want to talk to me, you can send me private information using my public keys that only I can decrypt.

So if we look at this, there it is. There's, Alice's common identifier. She declares herself as the controller and here's her public keybase. So now she's going to sign this.

So here she created a subject, which is the wrapped unsigned document. Remember we do that before we sign, we signed it. And then we added a note just to make it more human readable. The note doesn't change anything about the subject or what's been signed, it's just an additional assertion. And it's there for anybody who might want to examine this.

So if we actually go ahead and look at this, now we see here's the wrapped envelope, here's it's been signed by the same person who actually owns these public keys, and a note. The note is not essential. The note could be removed without changing the overall digest of the top level of the envelope, but it wouldn't actually change the verifiability of the signature.

### Registering Alice

Okay. So the next step is that Alice wants to take this document and wants to register it with a registrar: a third party who will verify her identity or do whatever else is necessary, maybe just even host the document. She's going to send this signed document to the registrar. So once it's at the registrar, the registrar has to check the signature and perform any other validity checks, like making sure that her public keys are correct or whatever. They're going to verify and then extract the wrapped envelope. And then they're also going to just get her common identifier and extract that as both a UR and as a hex CID. And you'll see why in a moment, because they're going to create a URL from it that anybody can access. The registrar now creates their own registration document using Alice's CID as the subject and incorporating Alice's signed document and adding its own signature.

And so this is the that they're going to create using Alice's signature. So anybody will be able to, if they know Alice's CID they'll be able to use Example Ledger database to look it up using this URI.

So now let's look at how Example Ledger creates its own registration document. So envelope subject, UR Alice CID you are that's the subject. Then the added assertion, which is the entity that they're registering, which is the envelope of Alice's signed document. And then another assertion, how to get more information about that entity, which is the actual URI that we just generated above here and then wrap that and then sign that with Ledger's private keys and they add their own little note to say they're made by Example Ledger. 

So now if we actually look at the registration document, Here it is, now you see Alice's original signed document is now embedded in this here, but it's also got the other information that has been added by Example Ledger, including the, how to dereference it using their database.

This is going to Alice's CID up here, occurs here and here in the URI and here in the CID and here in the controller of the CID. 

Once they've got this all registered, then they're going to send this back to Alice, and Alice is going to be able use this URI to get her own record back.

### Challenging Alice

Now, let's say that Alice wants to introduce herself to Bob. And so Bob needs to know that she controls her identifier. To do this, Bob needs to send a challenge to Alice that only Alice can respond to, and that he needs to be able to cross-check that the person he is corresponding with is the same person that Example Ledger actually verified and put up on their database. So he's going to generate this challenge.

In this case, he's going to use the envelope generate command to generate a nonce, which is just a random piece of data. And then he's going to create an envelope with that as its subject.  And then add the assertion, which is a note just saying challenge to Alice from Bob.

### Responding to the Challenge

So there's our nonce and there's the note and that's it. So Alice is going to sign this and then send it back to Bob. And then Bob is going to use Example Ledger's public keys on file for her to double check this, to make sure the same person that is sending back this challenge is also the person recorded at Example Ledger. So now Alice has to respond to the challenge. So this is how Alice composes her response. She wraps the challenge and then gives the Alice URI as the dereferenceVia assertion, and then wraps that and then signs the whole thing.

Here's the challenge. Here's additional information she's added saying, okay, I'm responding to your challenge. And I'm saying, this is how you get more information about me and I'm wrapping all this up and I'm verifying this with my signature, which will be made by the same public keys up on Example Ledger. notice that Alice hasn't even provided her public key yet she's provided a pointer back to Example Ledger, and she's also signed something here.

### Verifying the Response

So Bob can't even verify the signature yet. He has to ask Example Ledger for the public keys. So the first thing he has to do is make sure that the nonce that she's sending back is the one that he actually sent. Here's how he does that. So remember he sent Alice challenge before, now he is going to create Alice challenge two, he's going to extract the wrapped Alice response and then extract it again. So this is the first extraction here, and this is the second extraction. So he is just getting back the record that he originally sent her. And he is going to compare that to the original.

Here's how he does that: he calculates the digest of his original challenge and then calculates the digest of the challenge he got back. And now he can see that they're identical, which means that Alice did in fact, send him back a signed copy of his original challenge, but is it actually her signature?

So Bob uses the URI that Alice has provided to ask Example Ledger for Alice's identifier document, and then checks Example Ledger's signature on that. So Bob trusts Example Ledger's validation of Alice's original document. So he doesn't bother to check it for internal consistency because he presumes Example Ledger's done that already, but instead he goes and extracts Alice's public keys from it.

So he's verifying Alice's registration document. Getting Ledger's public keys and verifying that and that passes. Then he unwraps, he finds the known predicate called entity. Remember, this is Alice's original document. He extracts the object of that. He unwraps that, he finds the known predicate called public keys. He extracts the object of that and finally extracts the UR of that. And after all that, so let's look at Alice's public keys now.

And so there's a crypto pubkeys. This is her public keybase. So now he knows that this is Alice he's actually talking to. So now he needs to make sure that her signature on it is actually good. So now, since he has her public keys, now he can say verify the Alice response, public keys, Alice public keys that he just got back and it works.

So now he can correspond with Alice knowing that she is in fact, the entity, that Example Ledger has on record. 
