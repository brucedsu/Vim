Installation

    git clone https://github.com/brucedsu/dotvim.git ~/.vim
    
Create symlinks:

    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/vimrc.bundles ~/.vimrc.bundles
    ln -s ~/.vim/gvimrc ~/.gvimrc

iTerm2 italics:
    
    cd ~/.vim/iterm2-italic 
    tic xterm-256color-italic.terminfo
    Set "Terminal Type" to xterm-256color-italic
    Check "Italic text allowed" in iTerm's preference
