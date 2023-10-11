# `envelope` - Attachments

Attachments are defined in [BCR-2023-006](https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2023-006-envelope-attachment.md). They are a standardized way to add discoverable third-party data to an envelope.

Attachments are assertions that can be built up by using various invocations of the `envelope` command line tool, but since they have a specific format, the `envelope` tool provides shortcuts for creating and working with them.

## Attachment Subcommands

```bash
👉
envelope attachment --help
```

```
👈
OVERVIEW: Work with the envelope's attachments.

USAGE: envelope attachment <subcommand>

OPTIONS:
  --version               Show the version.
  -h, --help              Show help information.

SUBCOMMANDS:
  add (default)           Add an attachment to the given envelope.
  all                     Retrieve all the envelope's attachments.
  at                      Retrieve the attachment at the given index.
  conforms-to             Get the (optional) conformance of the attachment.
  count                   Print the count of the envelope's attachments.
  create                  Create an attachment.
  find                    Retrieve attachments having the specified attributes.
  payload                 Get the payload of the attachment.
  vendor                  Get the vendor of the attachment.

  See 'envelope help attachment <subcommand>' for detailed help.
```

## Creating an Attachment

The `attachment create` command lets you create an attachment by specifying its fields: `vendor`, `conforms-to` (optional), and `payload`.

```bash
👉
envelope attachment create --help
```

```
👈
OVERVIEW: Create an attachment.

USAGE: envelope attachment create <vendor> [--conforms-to <conforms-to>] [<payload>]

ARGUMENTS:
  <vendor>                The vendor that adds this attachment. Usually a reverse domain name.
  <payload>               The payload of the attachment. Entirely specified by the vendor.

OPTIONS:
  --conforms-to <conforms-to>
                          The spec to which this attachment conforms. Usually a URI.
  --version               Show the version.
  -h, --help              Show help information.
```

But first we need an envelope that is our attachment "payload", i.e., the vendor-specific data that we want to attach to an envelope. This can any possible envelope of arbitrary complexity, but here we'll just use a simple string:

```bash
👉
PAYLOAD_ENVELOPE=`envelope subject "this-is-the-payload"`
```

Now we create our attachment with our payload, and specify the vendor and conformance strings:

```bash
👉
VENDOR="com.example"
CONFORMS_TO="https://example.com/attachment"
ATTACHMENT=`envelope attachment create $VENDOR --conforms-to $CONFORMS_TO $PAYLOAD_ENVELOPE`
```

Here's what our attachment looks like in envelope notation:

```bash
👉
envelope $ATTACHMENT
```

```
👈
'attachment': {
    "this-is-the-payload"
} [
    'conformsTo': "https://example.com/attachment"
    'vendor': "com.example"
]
```

Notice that attachments are "bare assertions," i.e., assertions without a subject. Recall that assertions have a predicate and an object: in this case the predicate is the known value `'attachment'` and the object is the payload, which is wrapped and then has its own `'vendor'` and `'conformsTo'` assertions added to it.

## Querying an Attachment

Now that we have an attachment, we can query it for its vendor:

```bash
👉
envelope attachment vendor $ATTACHMENT
```

```
👈
com.example
```

Or for its conformance:

```bash
👉
envelope attachment conforms-to $ATTACHMENT
```

```
👈
https://example.com/attachment
```

Or for its payload:

```bash
👉
envelope attachment payload $ATTACHMENT
```

```
👈
ur:envelope/tpcsjkjyisinjkdpinjkdpjyisihdpjohskkjzjlhsiefgjtesdk
```

Note that since the payload is itself an envelope which can be arbitrarily complex, it is returned as a UR. So we can take the result of the above command and extract its subject as a string:

```bash
👉
envelope extract `envelope attachment payload $ATTACHMENT`
```

```
👈
this-is-the-payload
```

## Adding an Attachment

Now that we have an attachment, let's create a simple envelope to add it to:

```bash
👉
ENVELOPE=`envelope subject "this-is-the-envelope"`
```

Since we already have an attachment, we can add it to our envelope using the `attachment add envelope` command:

```bash
👉
ENVELOPE_WITH_ATTACHMENT=`envelope attachment add envelope $ATTACHMENT $ENVELOPE`

envelope $ENVELOPE_WITH_ATTACHMENT
```

```
👈
"this-is-the-envelope" [
    'attachment': {
        "this-is-the-payload"
    } [
        'conformsTo': "https://example.com/attachment"
        'vendor': "com.example"
    ]
]
```

## Multiple Attachments

Let's say the vendor releases a new version of the attachment spec. But for backwards compatibility, they want to support both the old and the new version. So they create a new attachment with the new version, and add it to the envelope. we start by creating the version 2 payload:

```bash
👉
PAYLOAD_ENVELOPE_V2=`envelope subject "this-is-the-payload-v2"`
```

In the previous example we created the attachment and then added it to the envelope, but we can also do it in one step by using the `attachment add components` command:

```bash
👉
ENVELOPE_WITH_TWO_ATTACHMENTS=`envelope attachment add components "com.example" --conforms-to "https://example.com/attachment-v2" $PAYLOAD_ENVELOPE_V2 $ENVELOPE_WITH_ATTACHMENT`

envelope $ENVELOPE_WITH_TWO_ATTACHMENTS
```

```
👈
"this-is-the-envelope" [
    'attachment': {
        "this-is-the-payload"
    } [
        'conformsTo': "https://example.com/attachment"
        'vendor': "com.example"
    ]
    'attachment': {
        "this-is-the-payload-v2"
    } [
        'conformsTo': "https://example.com/attachment-v2"
        'vendor': "com.example"
    ]
]
```

## Enumerating Attachments

The `count`, `all`, and `at` commands let you enumerate the attachments in an envelope:

```bash
👉
envelope attachment count $ENVELOPE_WITH_TWO_ATTACHMENTS
```

```
👈
2
```

```bash
👉
envelope attachment all $ENVELOPE_WITH_TWO_ATTACHMENTS
```

```
👈
ur:envelope/oycseylstpsptpcsjkjyisinjkdpinjkdpjyisihdpjohskkjzjlhsieoycseetpcsksckisjyjyjojkftdldlihkshsjnjojzihdmiajljndlhsjyjyhsiaisjnihjtjyoycseotpcsjeiajljndmihkshsjnjojzihzozmhhao
ur:envelope/oycseylstpsptpcskojyisinjkdpinjkdpjyisihdpjohskkjzjlhsiedpkoeyoycseetpcsksclisjyjyjojkftdldlihkshsjnjojzihdmiajljndlhsjyjyhsiaisjnihjtjydpkoeyoycseotpcsjeiajljndmihkshsjnjojzihjtlflpst
```

```bash
👉
envelope attachment at 0 $ENVELOPE_WITH_TWO_ATTACHMENTS
```

```
👈
ur:envelope/oycseylstpsptpcsjkjyisinjkdpinjkdpjyisihdpjohskkjzjlhsieoycseetpcsksckisjyjyjojkftdldlihkshsjnjojzihdmiajljndlhsjyjyhsiaisjnihjtjyoycseotpcsjeiajljndmihkshsjnjojzihzozmhhao
```

## Finding Attachments

The `find` command lets you find attachments that match a given set of attributes. In these examples we pipe the results to `wc -l` to count the number of attachments that match the given attributes.

There are two attachments in our envelope, and both were added by the same vendor, so we can find them both by specifying the vendor:

```bash
👉
envelope attachment find --vendor "com.example" $ENVELOPE_WITH_TWO_ATTACHMENTS | wc -l
```

```
👈
2
```

Each of these two attachments have different conformance URIs, so we can just find the version 2 attachment by specifying its conformance URI:

```bash
👉
envelope attachment find --conforms-to "https://example.com/attachment-v2" $ENVELOPE_WITH_TWO_ATTACHMENTS | wc -l
```

```
👈
1
```
