# TRANSCRIPT: Gordian Envelope CLI - 3 - Elision in Detail

[![Gordian Envelope CLI - 3 - Elision in Detail](https://img.youtube.com/vi/3G70mUYQB18/mqdefault.jpg)](https://www.youtube.com/watch?v=3G70mUYQB18)

_Part of the [Envelope-CLI Playlist](https://www.youtube.com/playlist?list=PLCkrqxOY1FbooYwJ7ZhpJ_QQk8Az1aCnG)._

## Description

Detail about using the Gordian Envelope-CLI (command line interface) tool for data minimization, including techniques for elision & redaction.

Envelopes are a new type of “smart document” to support the storage, backup, encryption & authentication of data, with explicit support for Merkle-based selective disclosure. It’s part of the Gordian Architecture led by Blockchain Commons. `envelope`, is CLI ( command-line interface) reference tool for creating and verifying cryptographic envelopes.

* [Brief Overview of These Examples](https://github.com/BlockchainCommons/envelope-cli-swift/blob/master/Docs/7-VC-ELISION-EXAMPLE.md)
* [cbor-cli](https://www.npmjs.com/package/cbor-cli)

**Other Overview Docs:**

* [Gordian Envelope-CLI — Repo for the CLI program](https://github.com/BlockchainCommons/envelope-cli-swift)
* [Gordian Envelope Intro](https://www.blockchaincommons.com/introduction/Envelope-Intro/)
* [Gordian Envelope Docs — Swift Library and Specs](https://github.com/BlockchainCommons/Gordian/tree/master/Envelope#articles)
* [Gordian Architecture — Overview of Entire Design](https://github.com/BlockchainCommons/Gordian/blob/master/Architecture/README.md)

## Unedited Transcript

Hi, I'm Wolf McNally and this video, we're going to go deeper into the subject of elision with the envelope command line interface tool.

### Building a Target Set for Elision, Piece by Piece

In this example, we're going to imagine that an employer of an employee with a continuing education credential wants to use elision to warrant to a third party, that their employee has such a credential without revealing anything else about the employee. So this example goes into detail about creating the target set for elision, building it up piece by piece.

So first we're going to add a couple private keys one for the electrical engineering certification board and one for the employer. So these are the private keys and public keys for the board and for the employer that I've generated previously. And so now we can compose the credential.

### Composing Raw CBOR

The envelope type is based on CBOR, the common binary object representation. You can think of it as like JSON, but in binary, not text. An envelope consists of a subject, which is an envelope and a set of assertions, which contain two envelopes each for the predicate and the object, and it's recursive that way. Any of these envelopes can also contain CBOR because the whole structure itself is CBOR. 

One of the fields of this credential we're going to be composing is raw CBOR, and I want to explain how to do that. The envelope tool can handle any CBOR in any position, but the envelope command line tool isn't designed to compose CBOR. So we're going to compose some custom CBOR here, and there's a tool, it's an NPM package that you can install using Node called "cbor-cli", and I have a link to it in the documentation, but I have it running here, so I'm going to type that command. And then I'm going to just type some, basically some JSON: it's going to be a array of strings. And then when I press return it outputs the actual CBOR code for that array of strings. And so control D here, to exit the tool.

And so you're going to see that in the next command, which is actually a whole bunch of envelope commands that compose the credential that this raw CBOR is in it. So let's put that in.

### Building the Envelope

So this is a long sequence of commands. You see it invokes the tool repeatedly. You've seen this in my previous videos. So the subject to the envelope is going to be a common identifier. And then it's going to have a series of assertions on it and it's going to have what it is: it's "isA" certificate completion. It's issuer is example electrical engineering board. The controller of this certificate is the example electrical engineering board. First and last names of the holder James Maxwell, the issue date, the expiration date, a photo of James Maxwell, which is just a text string in this case standing in for that, the certificate number, the subject, the number of continuing education units, the professional development hours.

And then array of strings, which is the topics that were studied. Which again is just say subject one and subject two. And again, the envelope tool doesn't care what's inside the CBOR, as long as it's well formed CBOR. And then we're going to wrap that into an outer envelope. We're going to sign that with the board's private keys and also add a note signed by example electrical engineering board. Remember, this is not part of what's been signed. This is just being added along with the signature on the outside. So once we execute that, then if we type envelope credential, so this is the format command again, the default envelope sub command. So this is the actual credential we've just created.

And it has all the the fields we just specified. And we have the signature, which applies to everything inside the signed part of the envelope. Remember the subject of the outer envelope is this inner envelope. So as you know, by now, every part of an envelope creates a digest and these together form a Merkel tree.

### Revealing vs Removing

So when we're going to elide parts of a document, we can decide what to remove or reveal by identifying a subset of all the digests that make up the tree.  This set is known as the "target" or the "target set". Normally we would create the target and then perform the elision in a single operation. But for this example, I'm going to break it down and build the target in increments, showing the result of each step.

So first we are going to create a shell variable to represent the target set and parentheses in the shell represent an array. So we're going to have an array of digest objects in UR format. And you'll see this as we develop it.

So this is an empty target. It contains no digests. And so right now, if we were to use the elide command on this set and say that only reveal what's in the set, there's nothing in the set. So if we do this...

So we've just created this redacted credential. And if we actually print this out now, it says the whole thing is elided. There's only a digest now there's no other data in this envelope, except for the digest, the top level digest of the envelope, because there was nothing in the target set.

So we said envelope elide revealing. If we said envelope elide removing here, that's saying we're not going to remove anything. In this case, we're saying we are removing everything. So that's what happened. 

### Eliding the Envelope

Now we're going to work our way down from the top of the tree structure that is the envelope adding digests to the target as we go. So the first digest we need to add is the top level digest of the envelope itself. This reveals the macro structure of the envelope. I'm going to have a command here, target plus equals and then in back ticks envelope, digest credential.

And so this is the actual credential we created before. And this is asking just for the digest of that, and we're adding that to the target. So if we just say echo target now. We have a single digest in there. And remember this is a shell script array, so we can actually individually address these, but now, if I re-execute the command here, so this is the command I'm going to execute every time we update the target, it's two commands: it's one to recreate the the redacted credential and then print it out. So now we have more than just elided. We have the macro structure, we have the subject, which remember is a wrapped envelope, containing a whole bunch of other stuff.

And then two elided assertions, which is the signature and the note we added. But again, that data doesn't exist in the envelope right now. It's just the digests of these things. The next step is we want to reveal the two assertions because we want whoever we send this elided envelope to be able to check the the signature on the envelope. So to do that, we have to iterate through the two assertions and reveal them completely. And remember, because each assertion is an envelope which contains two envelopes itself, we have a nested hierarchy of envelopes in every single assertion. The envelope digest command has an option on it called deep, which basically says this assertion all the way down, we want the digests for. So for example if we were asked for just the first assertion of the of the envelope, so this is the first assertion, it's just another envelope.

And so if we pipe that. To the deep digests command. So we have the same command pipe to envelope digest deep. We get several digests. We get 1, 2, 3. And so that's as far as it goes, because this assertion has no further assertions, but that's as much as we need to reveal the first assertion.

So now I'm going to type in two commands that will add all these assertions to the target in one step, and notice I'm using the plus equals command. Also notice I'm using these parentheses and this is a shell magic for basically I'm going to take this array and then append this to this other array here.

So now I've got more digests in my target set. And then if I go back to the command that basically re-elides the envelope and prints it, the subject's still elided, but now I have everything that we added to it in terms of the signature now visible.

The other thing to note here is that I'm using the "assertion at" command to iterate through; I didn't use a loop here. I'm just typing two command lines. Cause there's only two assertions to worry about. Normally if you were using a loop to iterate through all them, you'd use assertion at 0, 1, 2, 3, and so on until you have the count of all the envelopes and there's another envelope assertion command that prints out how many assertions there are in the envelope to let you iterate through them.

But what's important to realize is that the assertion retrieved by index here is not necessarily the assertion in the envelope itself. So this is the first assertion that's printed out by the format command. This is the second one, but this is not necessarily the order they are in the actual serialized or in memory envelope.

And the reason is this is intended to be human readable. And so you notice that they're alphabetical. They're lexicographically by the human readable parts of the envelope in this, but in the actual, in memory and serialized version envelope, they're in lexicographic order by digest. And this is also a way of ensuring that the composition of an envelope is deterministic.

So no matter what order you add assertions in, there's no duplicates allowed. And they're all in lexicographic order by digest, which basically means that no matter what assertions you add, there's only one way they're going to actually fall into place once you have the completed envelope. This will actually retrieve them by the lexicographic order, which you can't see from this, but doesn't really matter because normally you'll use the "assertion find" command to extract just the assertions you want to work with.

It's also important to realize at this point, if you had the proper public keys, which we do the receiver of this mostly-redacted credential could still verify the signature even without knowing anything else about the contents of the credential. So we have everything else about it, but we still have the signature.

So here's a command that actually verifies. So envelope verify silent so we don't want to reprint the envelope because we're not going to pipe it anywhere. The redacted credential with the board's public keys, and nothing happens, which means we succeeded. We would've got an error if it failed. So this shows that the signature still verifies, even though everything about the subject is still elided. 

So next we're going to reveal the macro structure of the subject. Remember, this is another elided envelope in the subject. All the holder's information is still there. So now we're going to add the subject itself, to the target.

Let's type this command. Target plus equals envelope extract and remember extract extracts the subject itself. This is the credential, and we're going to extract that as an envelope and then pipe that to envelope digest. So we're saying the top level digest of this envelope, the subject, we want to add it to our target.

And then we're going to re-redact and print. Now we have two new curly braces here. This is the wrapped envelope here. It's entire contents are still elided, but now we can see that this is in fact a wrapped envelope. So we're drilling our way down step by step.  And as you recall, we used the wrapped command to create the original credential. So now we're basically unwrapping it. We're undoing that as we step down into the envelope. So now we're going to reveal the content of the inner envelope.

We're going to assign this to a new shell variable envelope extract, wrapped credential. So we're not getting the digest now we're actually extracting that specific envelope, because we're going to start looking at digests inside it, and then we're going to add the target of the content to that.

And now we're going to re-redact and print, and now we see the macro structure of the inner envelope here. It has a subject which is still elided. That's the CID, and then we have 13 elided assertions. And our target set is getting bigger and bigger, in the end you'll probably have about 30 digests in it.

But it looks like we're actually getting somewhere here. The wrapped envelope has is still elided a bunch of assertions. So now we're going to decide what are these we want to reveal? We want to reveal the CID because that's the record locator for the board.

So we want to reveal the CID representing the issuing authority's unique reference to the credential holder. And this is because the warranty, the employer's making is that a specific identifiable employee has the credential without actually revealing their identity. And this allows the entire document to be identified and unredacted should the dispute ever occur.

So now we're saying envelope extract, this is the actual subject of the content envelope. And that's this right here. This is the CID, and we're asking for its digest and we're adding that to the target. And now we're going to re-redact and print, and you see the only difference between this and this is now the CID is visible.

Okay. In the content here of these elided assertions, there's only four that we actually want to reveal "isA", which is the It's a certificate of completion, the issuer, which is the board of engineering the subject, which is what was studied and the expiration date. So we're going to do this by finding those specific assertions by their predicate.

So here we're adding four things to the target, which actually could be more than one digest as you'll see in the moment, the first one says envelope assertion find that we're searching the content envelope. Now not the outer envelope. The content envelope find an assertion with known value "isA", and we're passing that to envelope digest shallow.

Now remember when we revealed the signatures. We said, envelope digest deep. We didn't care how deep it went. We wanted to reveal everything. Here, we're being a little bit more circumspect. We're only basically revealing the assertion, its predicate, and its object, without going  any deeper on those things.

So if there are further assertions or we're not going to reveal them It's up to you of course, to decide based on the scenario, what you want to do with that. So we've added those to the target. Now let's re-redact and show, and now we've revealed the expiration date, the subject that was studied, the isA and the issuer, and we still have nine elided including the person's name. 

### Warranting the Revelations

So in this case we're warranting that one of our employees has this information issued and this signature's still verifiable, but we need to go one step further. We need to actually create the warranty, which is signed by the employer and warrants to who they're revealing in a non reputable way that this is in fact an employee of the company.

So remember we have the redacted credential here and now in this command, we see that we're making a warranty where the subject is wrapped redacted credential. So now anything we add on the outside of this will be applied to the entire inner envelope. This is the predicate, employee hire date, which is a string. It's not a known value, which evaluates like a byte or two. It's the actual physical string that we're typing here. And then we're adding our employee status active. These are also strings they're strings by default, but if you actually want to use a type on the second on the second one, you have to also specify string on the first that's because of the way it's parsed.

If they're both strings, you never need to specify their data types. You only need quotes if there's spaces involved, that's basically because the way the shell parses strings. So in this case, They're strings without quotes and I want them to be parsed as strings. So I don't need anything in this case this is a string without spaces , so it doesn't need quote marks. But I do need to specify it as a string because if I only give this date switch, it'll apply to the first one. So this one applies the first one. This is one applies to the second one. It's bit weird, but that's the way shell parsing of flags works.

Anyway, we're basically adding these assertions and then we're wrapping that again. And then we're basically going to sign that with the employer's private keys and add a note on the outside of the envelope. So this is the warranty and we're going to then print that out.

Here's the full warranty. Here's the signature that applies to everything inside our envelope. So again, the note could change, but the note doesn't really matter. The signature is what matters and nothing inside here can change without invalidating the signature.

Inside here, we have another envelope which is also a wrapped envelope that we are making certain assertions on when they were hired and what their current status is.

And that's non-repudiable without breaking the signature. And then the envelope inside that is their redacted credential. So it's only what we want to reveal about the employee. 

### Recap

So what you see me do right now is build it up line by line. If I were actually writing a script to do this.  And I want to basically start with an empty target and go all the way to the warranty.

So this is a recap here. I just paste all those commands in one fell swoop here. We've already created the credential that's here, empty target, add the top level, add the assertions deep, add the top level digest of the envelope, extract the inner envelope so we can start accessing its digests.

Add that top level digest. Again, you have to add the top level digest envelope, and then you have to add the digest of the subject, which is what we're doing here. Extract, extracts the subject, and then we're finding the assertions we want to reveal, either as known values or as custom strings. And then we're adding those digests all the digests necessary to show them, but without going deep on them, and then we're finally redacting the credential with our target. And then we're taking that redacted credential, wrapping that, adding our assertions to it wrapping that and then signing it, and that's creating the entire warranty. So again, if I print that out, that's what our final warranty looks like. 

I'm really looking forward to the community's feedback on this work we're doing, I'm very excited about it. 

Next transcript is on [DIDs](4-DID-TRANSCRIPT.md).

