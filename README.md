HTML Beautifier
===============

A normaliser/beautifier for HTML that also understands embedded Ruby.
Ideal for tidying up Rails templates.

What it does
------------

* Normalises hard tabs to spaces
* Removes trailing spaces
* Indents after opening HTML elements
* Outdents before closing elements
* Collapses multiple whitespace
* Indents after block-opening embedded Ruby (if, do etc.)
* Outdents before closing Ruby blocks
* Outdents elsif and then indents again
* Indents the left-hand margin of JavaScript and CSS blocks to match the
  indentation level of the code

Usage
-----

### From the command line

To update files in-place:

``` sh
$ htmlbeautifier file1 [file2 ...]
```

or to operate on standard input and output:

``` sh
$ htmlbeautifier < input > output
```

## In your code

```ruby
require 'htmlbeautifier'

beautiful = HtmlBeautifier.beautify(messy)
```

You can also specify the number of spaces to indent (the default is 2):

```ruby
beautiful = HtmlBeautifier.beautify(messy, tab_stops: 4)
```
