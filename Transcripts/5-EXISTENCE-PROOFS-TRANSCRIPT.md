# TRANSCRIPT: Gordian Envelope CLI - 5 - Existence Proofs

[![Gordian Envelope CLI - 5 - Existence Proofs](https://img.youtube.com/vi/LUQ-n9EZa0U/mqdefault.jpg)](https://www.youtube.com/watch?v=LUQ-n9EZa0U)

_Part of the [Envelope-CLI Playlist](https://www.youtube.com/playlist?list=PLCkrqxOY1FbooYwJ7ZhpJ_QQk8Az1aCnG)._

## Description

Existence Proofs are a feature of Gordian Envelopes that support selective disclosure with a proof capability.
 
Envelopes are a new type of “smart document” to support the storage, backup, encryption & authentication of data, with explicit support for Merkle-based selective disclosure. It’s part of the Gordian Architecture led by Blockchain Commons. `envelope`, is CLI ( command-line interface) reference tool for creating and verifying cryptographic envelopes.

This video offers an overview of the Gordian Envelope-CLI (command line interface) tool, `envelope`, which can be used to create and verify cryptographic envelopes.

* [Brief Overview of These Commands](https://github.com/BlockchainCommons/envelope-cli-swift/blob/master/Docs/8-EXISTENCE-PROOFS.md)

**Other Overview Docs:**

* [Gordian Envelope-CLI — Repo for the CLI program](https://github.com/BlockchainCommons/envelope-cli-swift)
* [Gordian Envelope Intro](https://www.blockchaincommons.com/introduction/Envelope-Intro/)
* [Gordian Envelope Docs — Swift Library and Specs](https://github.com/BlockchainCommons/Gordian/tree/master/Envelope#articles)
* [Gordian Architecture — Overview of Entire Design](https://github.com/BlockchainCommons/Gordian/blob/master/Architecture/README.md)

## Unedited Transcript

An existence proof is a method of showing that particular information exists in a document without revealing more than is necessary about the document in which it exists. In a previous video, I covered elision, which is a method whereby information can be removed from an envelope without changing its digest tree structure.

Because each element of an envelope provides a unique digest, and because changing an element in an envelope changes the digest of all the elements upwards towards its root, the structure of an envelope is comparable to a Merkel tree. In a Merkel tree, all semantically significant information is carried by the tree's leaves. For example, the transactions in a block of Bitcoin transactions, while internal nodes of the tree or nothing but digests, computed from combinations of pairs of lower nodes all the way up to the root of the tree, which is called the Merkel root. In an envelope, every digest points at some potentially useful semantic information at the subject of the envelope, at one of the assertions in the envelope or at the predicate or object of a given assertion.

### Offering a Proof of Friendship

So for example, this envelope you're seeing right now is actually a nested envelope, which is the subject, and then two additional assertions, the note and the verified by signature at the end. But the subject of the envelope itself is an envelope. So if we look at just the inner envelope, we see that this inner envelope yields a digest.

And then the subject, which is just the CID, also has its own unique digest. Each of the assertions in this envelope has its own unique digest, and the predicate and object of each assertion has its own unique digest. And each of these things together, each of these elements — the envelope, its subject, the assertion, and the predicate and objects — they are all envelopes as well.

This highlighted object right here. This object to this of this assertion is itself actually an envelope. It's an envelope whose subject is the string 1, 2, 3, 4, 5, 6, 7, 8, 9, and it has no assertions. If it did have assertions, then this printout in envelope notation would show them. So I'm going to walk you through a set of scenarios where I show you how the envelope command line interface tool is capable of generating proofs for what exists inside the envelope without revealing anything else about the envelope except what is absolutely necessary. So let's start with creating an envelope here. This is just the commands necessary to create an envelope called Alice's Friends or Alice Friends. We're gonna echo that. Okay. That's just an envelope. That's the UR of the envelope.

So if we use the envelope tool again to say Envelope alice Friends, then this is the envelope notation. Now you notice that up here for each time I called envelope and I created an assertion, I also gave it the "salted" flag. And this means that the assertion, which is an envelope, gets an additional assertion, which is a random data called a salt.

And I'll explain why this is necessary or useful. It's not necessary actually. But now that we have this particular envelope, then Alice might want to just provide this, the root digest of her document to a third party. In doing so, nothing is revealed about the contents of that document.

#### Eliding Alice's Friends

So here's how we would generate that. So what we're doing is we're calling the envelope elide function. This is the elide revealing function with the Alice friends. And normally we would put a set of target digests after this of things to reveal, but since we're not providing anything, then nothing is gonna be revealed except the very top level digest.

So now if we just echo again, this is gonna be a an envelope. But you see it's significantly smaller than the previous one. So now if we say envelope, Alice Friends root, it's just, it says elided and this means that all you're seeing is the top level digest of the envelope of this whole envelope.

#### Creating Bob's Digest

In fact, this envelope and this envelope have the same digest. So Alice would send this to somebody and then say, Okay, I can prove certain things about this envelope. So let's say Alice wants to prove to a third party that her document contains a knows Bob assertion that Alice knows Bob. So to do this, she has to produce a proof that is an envelope with the minimal structure of digests included. So the proof envelope has the same digest as the completely elided envelope, the root that you see here. But it also exposes the digest of the target as the proof. Note that in the proof the digest of the other two elided knows assertions are present.

Let's let's create the knows Bob Digest. So this is the actual digest we want to reveal. So we're saying envelope subject assertion knows Bob, and we're piping that into Envelope Digest. We're just creating the assertion.

We're saying envelope, subject assertion. We're creating a new envelope who's subject to the assertion, knows Bob, and we're getting the digest, notice that there is that in the alice's friends, it's got these other things too: there's the salt and then there's the other assertions. But all we're really interested in revealing is this particular assertion and this new envelope's digest is exactly the same as this Envelope's Digest. It's the same object, basically. 

#### Generating a Proof

So now we're going to generate the actual proof. So now we're using the envelope proof command. We're saying envelope proof create.  and then we're using Alice's Friends, the full document here and we're saying just prove that the knows Bob Digest exists in this. So now if we type envelope knows Bob proof, it's not as tiny as this anymore, but it's got a structure to it. Everything inside it is elided. But the top level this would be the Alice, its digest is there and one of the assertions, the knows Bob is there. And then salt, that's the one assertion on that assertion. The salt is elided, but all these digest are necessary as well as the other two unrevealed assertions are all necessary so that this proof envelope has the same digest as this envelope, the root envelope, and the complete envelope. The unelided envelope. 

#### Confirming a Proof

So now Alice can send this proof on and the third party can then use the previously known and trusted route to confirm that the envelope does indeed contain a knows Bob assertion. So here's what that looks like: okay, so envelope proof, confirm. Like the signature verification command, we can say silent. This means that if you're writing a script, if it succeeds, it'll output the envelope so you can pipe it into the next script command. But in this case, we just want it to just silently succeed if it works. We give it the root envelope. We give it the knows proof and the knows digest. And so it's gonna make sure that first of all, that the top-level digest of the root is the same as the proof. And assuming that is correct, then it's going to look through the proof for the digest, and if it finds that, then it will succeed.

And as you can see, nothing happened. And that's a good thing because that means it succeeded.

### Offering a Proof with Credentials

So if we take a slightly more sophisticated example here we're going to use a modified version of a verifiable credential we used in a previous video. And in this case, we're creating our credential certificate here. So we've created some private keys for the electrical engineering board, and then we've created a credential.

It has a subject, which is a CID, it's basically the same as the previous scenario. We are using the salted flag on a number of things, and in a moment I'll actually show you why that's important. This will also seem familiar if I print out the credential itself.

As you can see a number of these things have salt and some of them don't. And the reason why we would add salt is because this makes them impossible to guess unless they're deliberately revealed. Here we're going to do the same thing we do with the previous envelope. We're gonna create the credential root, so we're gonna say, envelope elide revealing credential, and nothing more. And that will look totally elided. And so in this case, the holder of the credential wants to reveal a single assertion from it: the subject. And the subject is in this case, RF and microwave engineering.

So we're gonna do the same thing we did before. We're going to create a targeted digest. We're gonna say an envelope, subject assertion. This is the the predicate, which is subject, so don't get confused. This is the actual predicate. And the object, which is the string, RF and microwave engineering.

And we're gonna get its digest. So this is the subject of study that we're going to reveal. And then we're gonna create the proof of that. And that looks like this envelope proof create, here's the credential, and then we're gonna prove that the subject digest exists inside it.

#### Looking at our Elided Credential

Okay, so this is what that looks like. This is, again, a completely elided envelope. It reveals several levels. Most of these assertions are completely elided. The one of concern and it's salt the hashes are there, not the actual data, but just the hashes. So now the third party is going to use the proof envelope, proof confirm, silent with just the credential route, the completely elided envelope, and the proof. We're going to prove that it contains the subject digest, and that means it succeeded. 

#### The Power of Salt

So assertions without salt can also be guessed at and confirmed if the guess is correct. So for example if we wanted to guess at the issuer, remember the issuer here is example electrical engineering board. And if we did the same kind of technique, we say envelope, subject, assertion, known value issuer string example, electoral engineering board, and then we get the digest of that. Then we can also confirm just using the proof we were just given that the envelope also contains the particular issuer. And this is possible because that particular assertion did not have salt, and so we were able to create a digest that matches that assertion. 

But this proof cannot be used to confirm any of the assertions that were salted. For example, the first name which is, here James is salted. And so this entire envelope inside here does not have the same digest as just the assertion envelope. And so when we say we're gonna produce the digest envelope, subject assertion, first name, James, get the digest, and then we're going to try to prove that envelope contains that digest and we get error: invalid proof. We said envelope proof, confirm credential root, subject proof, first name, digest. That didn't work. That's because it could not find the digest in the proof anywhere because these elided digests are salted. 

### Offering Multiproofs

Okay. Finally, I wanna talk a little bit about, multi proofs.  So a single proof can be generated to reveal multiple target digests. In the example above here, we have a first name field and last name field. But what if we wanted to prove that both of them exist in the same envelope in one go? If we have a first name digest, we already saw how we'd create that and we'll create the last name digest. And then we're gonna create what we're called, the name proof. And we're seeing envelope proof create from our credential.

Both of these digest the first name and last name digest. So if we actually look at what that looks like now, you can see two of the assertions have been revealed along with the digest of their salt. And there's only 11 assertions that are completely elided now. So now we've made it possible to find the specific digests of the first name and last name. In this case, we would confirm it this way, envelope proof, confirm from the credential route, name proof, and then provide both digests that we want. If either of these is not confirmable, then the whole proof will fail and there we see it worked.

### Summary

When you create a proof, you decide what you want to reveal. What you want to be able to prove is in the original envelope, even though all you gave them originally was just the root, just a single digest essentially.

Existence proofs are a way to confirm the existence of a digest or set of digests within an envelope using minimal disclosure, but there are only one tool in the toolbox of techniques that envelope provides. Real life applications are likely to employ several of these tools. In the example above, we are assuming certain things such as the credential root being trusted, and the signature on the envelope having been validated.

These aren't provided for by the existence proof mechanism on its own. In addition, it's possible for a specific digest to appear in more than one place in the structure of an envelope. So proving that it exists in a single place where it's expected to exist also needs to be part of the process. Using tools that incorporate randomness like salting, signing, and encryption, as well as the tree structure of the envelope, provide a variety of ways to ensure that a specific digest occurs in exactly one place.

