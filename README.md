Summary
=======

org-vim is an outliner/organization plugin for vim.  It provides syntax
highlighting and some keyboard shortcuts for common operations for the
"ov" filetype.

Install
=======

If you're using [pathogen](https://github.com/tpope/vim-pathogen), drop this
project under `~/.vim/bundle`.  Otherwise, you'll need to copy some files:

    cp ftplugin/ov.vim ~/.vim/ftplugin/ov.vim
    cp syntax/ov.vim ~/.vim/syntax/ov.vim

Append to `.vimrc` file:

    filetype plugin on  " if you don't already have it
    au BufRead,BufNewFile *.ov set filetype=ov

Files with an extension of .ov will automatically get syntax highlighting and
some keyboard shortcuts in normal mode.  If the file you're editing doesn't have
the .ov extension, you can set the filetype manually.

    :set filetype=ov

Syntax
======

## Outlines

Outlines are done with hashes (#) at the beginning of the line.  Each hash
represents a new level.

Example:

    # Level 1
    ## Level 2
    Text in "Level 2" does not require any sort of indentation.
    ## Level 2b
    Additional text in level 2b.

## Lists

Lists start the line with a number followed by a period (1.), a dash (-),
or an asterik (*).  These items may be preceded with any amount of whitespace.

Examples:

    1. First item
    2. Second item
       Text can be wrapped around
    3. Third item

    - Unordered list item
    - Unordered list item again

    * Asteriks may also be used
    * For unordered list items

## Todo lists
Todos start with square brackes with a space between them ([ ]).  To mark
an item as done, replace the space with an 'x' ([x]).

Examples:

    [ ] Unfinished item
    [ ] Unfinished item #2
    [x] Finished item

## Tables

Table borders are done via pluses and dashes (+----+----+).  Columns are
separated using vertical bars (|).

Example:

    +-----+-------+-------+
    | Fox | Quick | Brown |
    +-----+-------+-------+
    | Dog | Lazy  | Green |
    +-----+-------+-------+

## Tags

Tags are any words prefixed with an at-sign (@).  They are not required to be
at the beginning of a line.

Examples:

    @maybe
    Tags can follow paragraphs. @tag

## Highlights

Highlighting text is done via mustaches ({{ }}).

Example:

    Normal text followed by {{ highlighted text }}.

## Separators
Separators are done via repeat equal signs (=).  All characters on the line must
be an equal sign, no whitespace is allowed.

Example:

    ============================================================================

Shortcuts in normal mode
========================

* `q=` inserts a separator
* `ql` re-numbers ordered lists
* `qn` moves cursor to next outline header
* `qN` moves cursor to previous outline header
* `qs` moves cursor to next separator
* `qS` moves cursor to previous separator
* `qt` auto formats table at cursor
* `qo` appends new list line to any list
* `qx` toggles the current todo item
* `qz` folds the current file according to its outline
