HTML Beautifier
===============

A normaliser/beautifier for HTML that also understands embedded Ruby. Ideal for tidying up Rails templates.

Usage
-----

    htmlbeautifier file1 [file2 ...]

or

    htmlbeautifier < input > output

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
* Indents the left-hand margin of JavaScript and CSS blocks to match the indentation level of the code

