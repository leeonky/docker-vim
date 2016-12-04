" vim-pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

for f in split(glob('~/.vimrc.d/*.vimrc'))
	exe 'source '. f
endfor
