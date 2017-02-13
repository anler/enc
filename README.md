# Enc

Encode in a variety of encodings without leaving the command line.

## Usage

See `USAGE.txt`.

## Examples

### URL encoding

```sh
$ echo hello there | enc url
hello%20there

$ enc url hello there
hello%20there

$ enc url
hello there
hello%20there
^C

$ enc url > encoded.txt
hello there
^C
$ cat encoded.txt
hello%20there

$ enc url hello.txt
hello%20there
```
