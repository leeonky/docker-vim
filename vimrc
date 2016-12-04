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

syntax enable

syntax on

filetype indent on

set tabstop=8
set shiftwidth=8
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""" reset all color settings
function Reset_color_settings()
	for color in g:color_settings
		exe color
	endfor
endfunction

function g:AddColor(name, fg, bg, tm)
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

call Source_session()
call Reset_color_settings()
