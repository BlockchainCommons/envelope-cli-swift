# envelope

A command line tool for manipulating the `Envelope` data type.

Written by [Wolf McNally](https://wolfmcnally.com) for [Blockchain Commons](https://blockchaincommons.com/).

## Dependencies and Resources

* [Introduction to Envelope](https://github.com/BlockchainCommons/BCSwiftSecureComponents/blob/master/Docs/02-ENVELOPE.md) (In the Secure Components repository.)
* [BC Secure Components](https://github.com/BlockchainCommons/BCSwiftSecureComponents) - A collection of useful primitives for cryptography, semantic graphs, and cryptocurrency in Swift. Includes the reference implementation of the `Envelope` type.
* [BC Foundation](https://github.com/BlockchainCommons/BCSwiftFoundation) - A collection of useful primitives for cryptocurrency wallets.
* [URKit](https://github.com/BlockchainCommons/URKit) - An iOS framework for encoding and decoding URs (Uniform Resources).
* [Research](https://github.com/BlockchainCommons/Research) - Research and proposals of interest to the blockchain community.

## Documentation and Examples

* [Overview of Commands](Docs/1-Overview.md)
* [Basic Examples](Docs/2-BASIC-EXAMPLES.md)
* [SSKR Example](Docs/3-SSKR-EXAMPLE.md)
* [Complex Metadata Example](Docs/4-METADATA-EXAMPLE.md)
* [DID Document Example](Docs/5-DID-EXAMPLE.md)
* [Verifiable Credential Example](Docs/6-VC-RESIDENT-EXAMPLE.md)
* [Verifiable Credential with Detailed Elision Example](Docs/7-VC-ELISION-EXAMPLE.md)

## Videos

* [Envelope CLI Playlist (YouTube)](https://www.youtube.com/playlist?list=PLCkrqxOY1FbooYwJ7ZhpJ_QQk8Az1aCnG)
  * [Introduction to Envelopes](https://www.youtube.com/watch?v=tQ9SPek0mnI)
  * [Envelope CLI - 1 - Overview](https://youtu.be/K2gFTyjbiYk)
  * [Envelope CLI - 2 - Examples](https://youtu.be/K2gFTyjbiYk)
  * [Envelope CLI - 3 - Elision in Detail](https://youtu.be/K2gFTyjbiYk)
  * [Envelope CLI - 4 - Distributed Identifier](https://youtu.be/K2gFTyjbiYk)
  * Older videos
    * [Envelope MVA (Minimal Viable Architecture) & Cryptographic Choices](https://www.youtube.com/watch?v=S0deyIHXukk)
    * [Envelope Privacy Requirements for Non-Correlation & Support Elision](https://www.youtube.com/watch?v=ubqKJAizayU)
    * [Envelope CLI Talk](https://www.youtube.com/watch?v=JowheoEIGmE)
    * [Envelope CLI Q&A](https://www.youtube.com/watch?v=2MjcrKLEsSE)

## Building

You will need Xcode 14 or later installed.

From the cloned repository directory, the following commands will compile the tool and link it to the `/usr/local/bin/` directory so it is available from the command line. the `link.sh` script will require you to enter your password.

```bash
./build.sh
./link.sh
```

To check your installation, run:

```bash
envelope help
```

**NOTE:** If you run `envelope` by itself, it will begin waiting on input from stdin and you will need to press `^C` to exit it.

**NOTE:** Removing or renaming the cloned repository directory will break the links established by `link.sh` so you will need to re-run it. If you wish to install the tool directly, run the `install.sh` script, after which you can remove the cloned repository directory. There is also an `uninstall.sh` script if you wish to remove the tool.

From here, visit the [Overview of Commands](Docs/1-Overview.md) to start learning how to use the tool. If you are unfamiliar with the `Envelope` type, we suggest starting with the [Introduction to Envelope](https://github.com/BlockchainCommons/BCSwiftSecureComponents/blob/master/Docs/02-ENVELOPE.md) in the Secure Components repository.
