# envelope

A Swift command line tool for manipulating the Gordian Envelope data type.

Written by [Wolf McNally](https://wolfmcnally.com) for [Blockchain Commons](https://blockchaincommons.com/).

## Dependencies and Resources

* [Introduction to Envelope](https://www.blockchaincommons.com/introduction/Envelope-Intro/) 
* [Envelope Docs](https://github.com/BlockchainCommons/Gordian/tree/master/Envelope#articles)
* [BC Secure Components](https://github.com/BlockchainCommons/BCSwiftSecureComponents) - A collection of useful primitives for cryptography, semantic graphs, and cryptocurrency in Swift. Includes the reference implementation of the `Envelope` type.
* [BC Foundation](https://github.com/BlockchainCommons/BCSwiftFoundation) - A collection of useful primitives for cryptocurrency wallets.
* [URKit](https://github.com/BlockchainCommons/URKit) - An iOS framework for encoding and decoding URs (Uniform Resources).
* [Research](https://github.com/BlockchainCommons/Research) - Research and proposals of interest to the blockchain community.

## Documentation and Examples

The following docs exemplify the basic functionality of the `envelope-cli` app. 

* [1: Overview of Commands](Docs/1-OVERVIEW.md) — Adding subjects, assertions, signatures, and salt.
* [2: Basic Examples](Docs/2-BASIC-EXAMPLES.md) — Demonstrating standard methodologies for entry, encryption, and signing.
* [3: SSKR Example](Docs/3-SSKR-EXAMPLE.md) — Using Shamir's Secret Sharing to lock envelopes.
* [4: Complex Metadata Example](Docs/4-METADATA-EXAMPLE.md) — Creating envelopes with layered, structured data.
* [5: DID Document Example](Docs/5-DID-EXAMPLE.md) — Creating and wrapping identifiers.
* [6: Verifiable Credential Example](Docs/6-VC-RESIDENT-EXAMPLE.md) — Building complex credentials around an identifier.
* [7: Verifiable Credential with Detailed Elision Example](Docs/7-VC-ELISION-EXAMPLE.md) — Eliding some of a credential.
* [8: Existence Proofs](Docs/8-EXISTENCE-PROOFS.md) — Proving the existence of an elided credential.
* [9: Diffing](Docs/9-DIFFING.md) — Showing the differences between two envelopes.

## Videos

For more examples of `envelope-cli` usage, see the [envelope-cli videos](https://github.com/BlockchainCommons/envelope-cli-swift#videos) and their transcripts.

* [Envelope CLI Playlist (YouTube)](https://www.youtube.com/playlist?list=PLCkrqxOY1FbooYwJ7ZhpJ_QQk8Az1aCnG)
  * [Introduction to Gordian Envelopes](https://www.youtube.com/watch?v=OcnpYqHn8NQ)
  * [Envelope CLI - 1 - Overview](https://youtu.be/K2gFTyjbiYk) [ [Transcript with Examples](Transcripts/1-OVERVIEW-TRANSCRIPT.md) ]
  * [Envelope CLI - 2 - Examples](https://youtu.be/K2gFTyjbiYk) [ [Rough Transcript](Transcripts/2-EXAMPLES-TRANSCRIPT.md) ]
  * [Envelope CLI - 3 - Elision in Detail](https://youtu.be/K2gFTyjbiYk) [ [Rough Transcript](Transcripts/3-ELISION-TRANSCRIPT.md) ]
  * [Envelope CLI - 4 - Distributed Identifier](https://youtu.be/K2gFTyjbiYk) [ [Rough Transcript](Transcripts/4-DID-TRANSCRIPT.md) ]
  * [Envelope CLI - 5 - Existence Proofs](https://www.youtube.com/watch?v=LUQ-n9EZa0U)[ [Rough Transcript](Transcripts/5-EXISTENCE-PROOFS-TRANSCRIPT.md) ]
  * Older videos
    * [Envelope MVA (Minimal Viable Architecture) & Cryptographic Choices](https://www.youtube.com/watch?v=S0deyIHXukk)
    * [Envelope Privacy Requirements for Non-Correlation & Support Elision](https://www.youtube.com/watch?v=ubqKJAizayU)
    * [Envelope CLI Talk](https://www.youtube.com/watch?v=JowheoEIGmE)
    * [Envelope CLI Q&A](https://www.youtube.com/watch?v=2MjcrKLEsSE)

## Building

You will need Xcode 15 or later installed.

From the cloned repository directory, the following command will compile the tool and install it in the `/usr/local/bin/` directory so it is available from the command line. The `install.sh` script will require you to enter your password to complete the install.

```bash
./install.sh
```

To check your installation, run:

```bash
envelope help
```

If you only want to run the tool from the command line without installing it:

```bash
./build.sh
swift run --run EnvelopeTool help
```

**NOTE:** If you run `envelope` with no arguments, it will begin waiting on input from stdin and you will need to press `^C` to exit it.

**NOTE:** There is an `uninstall.sh` script if you wish to remove the tool.

From here, visit the [Overview of Commands](Docs/1-Overview.md) to start learning how to use the tool. If you are unfamiliar with the `Envelope` type, we suggest starting with the [Introduction to Envelope](https://www.blockchaincommons.com/introduction/Envelope-Intro/).
