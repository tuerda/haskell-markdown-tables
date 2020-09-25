# Table Formatter and Converter

Written to learn Haskell.
Converts tables between CSV, Markdown and LaTeX formats.

## Compilation

`ghc --make tabla.hs` to compile.

Alternatively, you can just run it directly with
`runhaskell tabla.hs`.

## Usage

Accepts two arguments. Syntax is:
`tabla <fromformat> <toformat>`

Accepts any of the following format indications:
- LaTeX format: tex, latex, Tex, LaTeX, Latex
- markdown format: md, markdown, Markdown
- csv format: csv, CSV

Pipe your markdown tables into it to change their format.

Default (no arguments) assumes tables are in markdown format and adjusts spacing to make them easily readable.

This is mostly intended for use in formatting tables from within a vim session.
Use `:<range> !runhaskell tabla.hs <fromformat> <toformat>` to format a table in the mentioned range of lines.
