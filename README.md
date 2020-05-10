vim :heart: wiki = vimki
========================

If you use Vim and like to keep notes as text files, then you should
like this simple plugin.

Vimki allows to browse, navigate and edit a collection of text files in
a single directory (usually `~/Wiki`). These files contain hyperlinks to
each other in the form of [WikiWords], as in the original [WikiWikiWeb].

So it smells like 1995 ? That's the goal :-). Text files are here to
stay, cost almost nothing to store, and will still be available in the
same form in the next decades and beyond. A dead simple wiki in plain
old text is both durable and scalable.

I can (and do) throw everything at it: some random notes, my diary
(a file per month), my contacts, my research notes and references, a
catalog of all my stuff, books, films, music with the links to open when
available, etc. All kind of data, loosely coupled or well structured,
personal or professional, public or private (using `:X` vim command), but
always interlinked. And as for the brain, with a growing number of
links with the time.

The point of using vimki is to remove any friction in the flow of
browsing, reading and writing. Everything you read is writable right now.
To open a new file, I write a WikiWord, press `Return` with the cursor
on it, and I'm now editing it (or just press `,,` to go back, as I set
`,` as `<Leader>` on my french keyboard). And all collisions (content
already existing for a new WikiWord) are in fact happy accidents with
deep meaning.

Installation
------------

Vimki should install with your favorite package manager.  For example,
using [vim-plug], add `Plug 'mvertes/vimki'` in the vim-plug section of
your `~/.vimrc` and in vim, run `:PlugInstall`.

Usage
-----

The default mappings, present from any buffer, are defined as follow
(by default, `<Leader>` stands for `\`):

| mapping      | action                 |
| ------------ | ---------------------- |
| `<Leader>ww` | open the Wiki HomePage |
| `<Leader>wi` | open the Wiki index    |
| `<Leader>wf` | follow a WikiWord      |

The following mappings are present when editing a Wiki file:

| mapping             | action                               |
| ------------------- | ------------------------------------ |
|  `<Leader><Leader>` | close the file (back to previous)    |
|  `<CR>`             | follow the WikiWord under the cursor |
|  `<Tab>`            | move to the next WikiWord            |
|  `<BS>`             | move to the previous WikiWord        |
|  `<Leader>wr`       | reload WikiWords                     |

Customization
-------------

Several variables are checked by the script to customize vimki
behavior. You can set them using let in your `vimrc` file.
Example:
```vim
        let vimki_home = "$HOME/MyWiki/HomePage"
```
| variable          | default  | description                               |
| ----------------- | ----     | ----------------------------------------- |
| `vimki_suffix`    | `""`     | suffix appended to the names of WikiFiles |
| `vimki_home`      | `$HOME/Wiki/HomePage + wimki_suffix` | path of Wiki HomePage |
| `vimki_home_dir`  | dir of `vimki_home` |  path of Wiki directory |
| `vimki_upper`     | `'A-Z'`  | upper case characters for WikiWords |
| `vimki_lower`     | `'a-z'`  | lower case characters for WikiWords |
| `vimki_other`     | `'0-9_'` | non-letter characters for WikiWords |
| `vimki_autowrite` | `1`      | to automatically write a Wiki file on close |
| `vimki_ignore`    | `""`     | comma-separated list of words to ignore |

Bugs
----

Issues and pull-requests are opened at https://github.com/mvertes/vimki.

Credits
-------

This plugin was inspired by [potwiki] and some other projects.

[vim-plug]: https://github.com/junegunn/vim-plug
[WikiWords]: https://wiki.c2.com/?WikiWord
[WikiWikiWeb]: https://en.wikipedia.org/wiki/WikiWikiWeb
[potwiki]: https://www.vim.org/scripts/script.php?script_id=1018
