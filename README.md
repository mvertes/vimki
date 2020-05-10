vim :heart: wiki = vimki
========================

If you use Vim and like to keep notes as text files, then you should
like this simple plugin.

Vimki allows to browse, navigate and edit a collection of text files in
a single directory (usually `~/Wiki`). These files contain hyperlinks to
each other in the form of [WikiWords], as in the original [WikiWikiWeb].

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

[vim-plug]: https://github.com/junegunn/vim-plug
[WikiWords]: https://wiki.c2.com/?WikiWord
[WikiWikiWeb]: https://en.wikipedia.org/wiki/WikiWikiWeb
