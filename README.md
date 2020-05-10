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
| `<Leader>we` | edit a Wiki file       |

The following mappings are present when editing a Wiki file:

| mapping             | action                               |
| ------------------- | ------------------------------------ |
|  `<Leader><Leader>` | close the file                       |
|  `<CR>`             | follow the WikiWord under the cursor |
|  `<Tab>`            | move to the next WikiWord            |
|  `<BS>`             | move to the previous WikiWord        |
|  `<Leader>wr`       | reload WikiWords                     |

[vim-plug]: https://github.com/junegunn/vim-plug
[WikiWords]: https://wiki.c2.com/?WikiWord
[WikiWikiWeb]: https://en.wikipedia.org/wiki/WikiWikiWeb
