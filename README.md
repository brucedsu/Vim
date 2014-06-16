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

    1. Code templates
    2. iTerm cursor: NORMAL = block, INSERT = vertical bar
    3. Code auto completion based on not only context but also programming language, still neocomplcache? I'd rather learn vim script the hard way and write one plugin myself.
    4. Reformat code (not only reindent)
