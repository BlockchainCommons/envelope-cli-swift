# envelope - SSKR Example

This example demonstrates the use of SSKR to shard a symmetric key that encrypted a message. The shares are then enclosed in individual envelopes and the seed can be recovered from those shares, allowing the future decryption of the message.

Dan has a cryptographic seed he wants to backup using a social recovery scheme. The seed includes metadata he wants to back up also, making it too large to fit into a basic SSKR share.

```bash
👉
DAN_SEED=ur:crypto-seed/oxadgdhkwzdtfthptokigtvwnnjsqzcxknsktdaosezofptpbtlnlyjzkefmaxkpfyhsjpjecxgdkpjpjojzihcxfpjskphscxgsjlkoihaakskggsjljpihjncxinjojkkpjncxiejljzjljpcxjkinjycxhsjnihjydwcxiajljtjkihiajyihjykpjpcxhsieinjoinjkiainjtiocxihjzinjydwcxjkihiecxiejlcxihinkpjkjnjliecxjyihjnjojljpcxinjtiainieiniekpjtjycxkpjycxjzhsidjljpihcxihjycxiejljzjljpihcxjnhsiojthscxhsjzinjskphsdmluwmoxny
```

Dan encloses his seed in an envelope.

```bash
👉
DAN_ENVELOPE=`envelope subject --ur $DAN_SEED`
echo $DAN_ENVELOPE
```

```
👈
ur:envelope/tpuotaaddwoxadgdhkwzdtfthptokigtvwnnjsqzcxknsktdaosezofptpbtlnlyjzkefmaxkpfyhsjpjecxgdkpjpjojzihcxfpjskphscxgsjlkoihaakskggsjljpihjncxinjojkkpjncxiejljzjljpcxjkinjycxhsjnihjydwcxiajljtjkihiajyihjykpjpcxhsieinjoinjkiainjtiocxihjzinjydwcxjkihiecxiejlcxihinkpjkjnjliecxjyihjnjojljpcxinjtiainieiniekpjtjycxkpjycxjzhsidjljpihcxihjycxiejljzjljpihcxjnhsiojthscxhsjzinjskphsdmaygebzlg
```

Dan examines the contents of his envelope.

```bash
👉
envelope $DAN_ENVELOPE
```

```
👈
CBOR(crypto-seed)
```

Dan splits the envelope into a single group 2-of-3. The output of the `envelope` tool contains the list of share envelopes separated by spaces. He then assigns this to a shell array.

```bash
👉
SHARE_ENVELOPES=(`envelope sskr split -g 2-of-3 $DAN_ENVELOPE`)
```

Dan sends one envelope to each of Alice, Bob, and Carol.

```bash
👉
SHARE_ENVELOPE_ALICE=${SHARE_ENVELOPES[1]}
SHARE_ENVELOPE_BOB=${SHARE_ENVELOPES[2]}
SHARE_ENVELOPE_CAROL=${SHARE_ENVELOPES[3]}
```

Dan ➡️ ☁️ ➡️ Alice, Bob, Carol

Bob examines the contents of his envelope, but can't recover the original seed.

```bash
👉
envelope $SHARE_ENVELOPE_BOB
```

```
👈
ENCRYPTED [
    sskrShare: SSKRShare
]
```

By himself, Bob can't recover the seed.

```bash
👉
envelope sskr join $SHARE_ENVELOPE_BOB
```

```
👈
Error: invalidShares
```

At some future point, Dan retrieves two of the three envelopes so he can recover his seed.

```bash
👉
envelope sskr join $SHARE_ENVELOPE_BOB $SHARE_ENVELOPE_CAROL | envelope extract --ur
```

```
👈
ur:crypto-seed/oxadgdhkwzdtfthptokigtvwnnjsqzcxknsktdaosezofptpbtlnlyjzkefmaxkpfyhsjpjecxgdkpjpjojzihcxfpjskphscxgsjlkoihaakskggsjljpihjncxinjojkkpjncxiejljzjljpcxjkinjycxhsjnihjydwcxiajljtjkihiajyihjykpjpcxhsieinjoinjkiainjtiocxihjzinjydwcxjkihiecxiejlcxihinkpjkjnjliecxjyihjnjojljpcxinjtiainieiniekpjtjycxkpjycxjzhsidjljpihcxihjycxiejljzjljpihcxjnhsiojthscxhsjzinjskphsdmluwmoxny
```