## Homebrew & Vim [OS X]

    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    brew install python
    brew install lua
    brew install ruby
    brew install vim --with-python --with-ruby --with-perl --with-lua
    brew install macvim --env-std --override-system-vim --with-cscope --with-lua --HEAD

## Installation

    git clone https://github.com/brucedsu/dotvim.git ~/.vim

## Create symlinks:

    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/vimrc.bundles ~/.vimrc.bundles
    ln -s ~/.vim/gvimrc ~/.gvimrc

## iTerm2 italics:

    cd ~/.vim/iterm2-italic
    tic xterm-256color-italic.terminfo
    Set "Terminal Type" to xterm-256color-italic
    Check "Italic text allowed" in iTerm's preference

## To-do list:

    1. Code templates (✓ UltiSnips)
    2. Replace neocomplete with __YouCompleteMe__
    3. iTerm cursor: NORMAL = block, INSERT = vertical bar
    4. Reformat code (not only reindent)
