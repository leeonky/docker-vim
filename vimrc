"""""""""""""" vim-pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
"""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=","
let g:color_settings = []
"""""""""""""""""""""""""""""""""""""""""""""""""""

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
