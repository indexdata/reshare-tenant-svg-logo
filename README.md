# reshare-tenant-svg-logo

## Purpose

Generate a basic ReShare tenant logo as SVG.

## Usage

The base SVG `reshare-tenant-svg-logo.svg` has the ReShare logo as a base64 encoded image.

There are five centered placeholder text elements:

* There are lines of centered text.
* Line 1 is mandatory for the tenant name.
* Line 2 to line 5 are optional for a longer tenant name.
* Typically use the final line for the ISIL code.
* Each text piece must not be longer than 40 characters.
* The lines must be sequential.

For text with spaces, enclose in quotes.

If the optional lines are not provided, then the height of the SVG image is adjusted to suit.

Refer to the script help: `./reshare-tenant-svg-logo.sh -h`

### Wrapper script to prepare long text

With upcoming 350+ tenants for Trove, we cannot intervene in any way to manually prepare the text rows.

So use the wrapper script to automatically fold potential long text:

```
./reshare-tenant-svg-logo-fold.sh \
  -t "Queensland Griffith University" -c trove -i QGU -p black
```

Other arguments are:
* `-p color`
  -- The text colour. Default is reshare-grey, else black, red, etc.
* `-w width`
  -- The width at which to fold the text words into lines. Default 40.
  Tweaking this can help to adjust the folding.

This will create the output file as: `trove-qgu.svg`

Refer to the script help: `./reshare-tenant-svg-logo-fold.sh -h`

The text cannot be longer than 120 characters.

## Examples

View the output SVG in the web browser:\
`open output.svg`

The following are examples for the main script.
However it is much better to use the [wrapper](#Wrapper-script-to-prepare-long-text) script explained above.

### One text line

```
./reshare-tenant-svg-logo.sh \
  -1 "My Beaut Library Name" > output.svg
```

### Two text lines

Utilise the optional second text line when the name is longer than 40 characters:

```
./reshare-tenant-svg-logo.sh \
  -1 "My Beaut Library Name" \
  -2 "is Longer Than Short Names" > output.svg
```

### Three text lines

Utilise the optional third text line for an ISIL code or some such:

```
./reshare-tenant-svg-logo.sh \
  -1 "My Beaut Library Name" \
  -2 "is Longer Than Short Names" \
  -3 US-TEST-P > output.svg
```
