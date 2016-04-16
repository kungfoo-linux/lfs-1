#!/bin/bash -e
. ../lfs.comm

# The Vim package contains a powerful text editor.

build_src() {
    srcfil=vim-7.4.tar.bz2
    srcdir=vim74

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # Change the default location of the vimrc configuration file to /etc:
    echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

    ./configure --prefix=/usr \
        --enable-multibyte \
        --enable-cscope \
        --enable-gui=no \
        --enable-pythoninterp \
        --enable-perlinterp \
        --enable-luainterp
    make -j$JOBS
    make install

    ln -sv vim /usr/bin/vi
    for L in /usr/share/man/{,*/}man1/vim.1; do
        ln -sv vim.1 $(dirname $L)/vi.1
    done
    ln -sv ../vim/vim74/doc /usr/share/doc/vim-7.4
    mkdir -pv ~/.vim

    cd .. && rm -rf $srcdir
}

configure() {
    # By default, vim runs in vi-incompatible mode. This may be new to users
    # who have used other editors in the past. The "nocompatible" setting is
    # included below to highlight the fact that a new behavior is being used.
    # It also reminds those who would change to “compatible” mode that it
    # should be the first setting in the configuration file. This is necessary
    # because it changes other settings, and overrides must come after this
    # setting. Create a default vim configuration file by running the
    # following:
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

set nocompatible
set backspace=2
set hlsearch
set vb t_vb=
set background=dark
syntax on

if &term == "xterm"
    set t_Co=8
    set t_Sb=[4%dm
    set t_Sf=[3%dm
endif

" Only do this part when compiled with support for autocommands
if has("autocmd")
    " In text files, always limit the width of text to 78 characters
    autocmd BufRead *.txt set tw=78

    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif

" End /etc/vimrc
EOF

    # create ~/.vimrc file:
cat > ~/.vimrc << EOF
" For all style
set ai noic nomagic ruler aw incsearch wildmenu wrap
set ts=8 sw=8 tw=78
" set fo=tcqro
set encoding=utf-8
set fileencodings=utf-8-bom,ucs-bom,utf-8,cp936,gb18030,ucs,big5

" For C language programming
set cin completeopt=longest,menu

" open filetype detect
filetype plugin indent on
au FileType java,javascript,php,conf,sh set ts=4 sw=4 expandtab
au FileType xml set ts=2 sw=2 expandtab

" Change buffer - without saving
set hid

" automatic save and restore folders
au BufWinLeave *.* silent mkview
au BufWinEnter *.* silent loadview

" Word completion
"
EOF

    # Documentation for other available options can be obtained by 
    # running the command: "vim -c ':options'".
}

build
