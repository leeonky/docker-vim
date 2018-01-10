"""""""""""""" vim-pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
"""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""" configs
let mapleader=","
let g:color_settings = []

filetype on

filetype plugin on

set nocompatible

set cursorline

set number

set hlsearch

syntax enable

syntax on

filetype indent on

set tabstop=8
set shiftwidth=8

colorscheme default
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""" reset all color settings
function Reset_color_settings()
	for color in g:color_settings
		exe color
	endfor
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""" source plugins
for f in split(glob('~/.vimrc.d/*.vimrc'))
	exe 'source '. f
endfor
"""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""" session.vim
function Source_session()
	let path=expand('%:p:h')
	if filereadable(path."/.session.vim")
		silent exe "source ".path."/.session.vim"
	endif
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""

call Reset_color_settings()
call Source_session()
