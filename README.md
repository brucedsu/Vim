# My Awesome Vim Configurations

## Installation

### Install homebrew and vim

1. Install homebrew package manager

        $ ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

2. Install python, lua, ruby by `brew`

        $ brew install python
        $ brew install lua
        $ brew install ruby

3. Install vim and macvim; macvim is going to replace the system vim with
the `--with-override-system-vim` flag on

        $ brew install vim --with-python --with-ruby --with-perl --with-lua
        $ brew install macvim --env-std --with-override-system-vim --with-cscope --with-python --with-ruby --with-perl --with-lua --HEAD

### Configure vim

    $ git clone https://brucedsu@bitbucket.org/brucedsu/dotvim.git ~/.vim
    $ cd ~/.vim && ./install-vim

### Compile YouCompleteMe

* YouCompleteMe only supports python 2.7, NOT python 3 and above
* For better YouCompleteMe experience, just use macvim (overriding system vim)

        $ cd ~/.vim/plugins/YouCompleteMe
        $ ./install.py --clang-completer --js-completer --java-completer
        $ ./install.py --all

## Italic Font in iTerm 2:

1. Set "Terminal Type" to "xterm-256color-italic"
2. Check "Italic text allowed" in iTerm's preference

## Perfect Powerline Font in iTerm 2

1. Add all menlo for powerline fonts in the font folder
2. Also add monaco for powerline font
2. In iTerm2 preferences, set "Regular Font" to "14pt Menlo Regular"
3. Set "Non-ASCII Font" to "14.4pt Inconsolata-dz for Powerline"

## Function Keys

* __F1__: CtrlPBuffer
* __F2__: NERDTreeToggle
* __F3__: TagbarToggle
* __F4__: PasteToggle
* __F5__: indentLinesToggle
* __F6__: RainbowParentheses
* __F7__: Autoformat
* __F8__: ToggleVimShell
* __F11__: RunCode in VimShell, supports interaction, e.g. user input
* __F12__: RunCode by vim-quickrun, no interaction, but fast

