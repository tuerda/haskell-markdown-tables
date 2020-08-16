# Markdown Table Formatter

Written to learn Haskell.
Formats tables in one of two ways.

You may ask why use this instead of another program that might do the same thing.

There is no reason.
Those other programs are probably better: I made this for myself, but you are welcome to use it if you want to.

## Compilation

`ghc tabla.hs` to compile.

Alternatively, you can just run it directly with
`runhaskell tabla.hs`.

## Usage

Pipe your markdown tables into it to get them formatted.
By default it will make them look pretty while conforming to github flavored markdown.

Accepts the switch "-l" to draw underlines below every line.
This will not look good rendered in github, but it is a more attractive format if you just read your markdown directly in plain text.

This is mostly designed to format tables from within a vim session.
Use `:<range> !runhaskell tabla.hs` to format a table in the mentioned range of lines.
