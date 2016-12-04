" vim-pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

for f in split(glob('~/.vimrc.d/*.vimrc'))
	exe 'source '. f
endfor

function Source_session()
	let path=expand('%:p:h')
	if filereadable(path."/.session.vim")
		silent exe "source ".path."/.session.vim"
	endif
endfunction

call Source_session()
