" vim-pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

let mapleader=","
let g:color_settings = []

filetype on

filetype plugin on

" move to head and tail
nnoremap <leader>l' 0
nnoremap <leader>ll $

" move with block of {} ()
nnoremap <leader>pn %

" move window
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
inoremap <C-h> <ESC><C-w>h
inoremap <C-l> <ESC><C-w>l
inoremap <C-j> <ESC><C-w>j
inoremap <C-k> <ESC><C-w>k
"set showtabline=2

set nocompatible
set wildmenu

set background=dark

" always show status bar
set laststatus=2

" show row,column number
set ruler

set number

" show curse position
set cursorline
" set cursorcolumn


syntax enable
syntax on

filetype indent on

" default indent
set tabstop=8
set shiftwidth=8

colorscheme default

" foldmethod
set foldmethod=syntax
set nofoldenable

" buffer
"map <leader>bv :MBEToggle<cr>
"map <leader>bn :MBEbn<cr>
"map <leader>bp :MBEbp<cr>

" save session
"set undofile
nnoremap <silent> <leader>ss :call Save_all()<cr>
nnoremap <silent> <leader>sl :call Load_all()<cr>

function Save_all()
	NERDTreeClose
	wa
	mksession! .session.vim
"	wviminfo! session.viminfo
	NERDTree
endfunction

function Load_all()
	NERDTreeClose
	if filereadable(".session.vim")
		source .session.vim
	endif
"	if filereadable("session.viminfo")
"		source session.viminfo
"	endif
	NERDTree
endfunction


" shell util
let s:output_opened = 0

function Execute_command(command)
	silent !echo > .OUTPUT
	execute "!( ".a:command." ) 2>&1 | tee .OUTPUT"
endfunction

function Process_command_args(...)
	let cmd_args = []
	for arg in a:000
		call add(cmd_args, shellescape(arg))
	endfor
	return cmd_args
endfunction

function Execute_command_with_args(...)
	let args = call (function('Process_command_args'), a:000)
	call Execute_command(join(args))
endfunction

function Close_output_window()
	if filereadable('.OUTPUT')
		sp .OUTPUT
		call AnsiEse_off()
		bd
		let s:output_opened = 0
	endif
endfunction

function Open_output_window()
	if filereadable('.OUTPUT')
		sp .OUTPUT
		set buftype=nofile
		call AnsiEse_on()
		let s:output_opened = 1
	endif
endfunction

function Toggle_output_window()
	if s:output_opened
		call Close_output_window()
	else
		call Open_output_window()
	endif
	call Reset_color_settings()
endfunction

nnoremap <silent> <leader>ov :call Toggle_output_window()<cr>
command -nargs=* Shell call Execute_command_with_args(<f-args>)


" TEST/APP RUNNER
let g:test_current_ut = []
let g:test_current_at = []
let g:test_all_test = []
let g:test_last_test = []
let g:test_app = []

function Run_ut(...)
	let g:test_current_ut = a:000
	call Run_current_ut()
endfunction

function Run_current_ut()
	let g:test_last_test = g:test_current_ut
	call Run_last_test()
endfunction

function Run_at(...)
	let g:test_current_at = a:000
	call Run_current_at()
endfunction

function Run_current_at()
	let g:test_last_test = g:test_current_at
	call Run_last_test()
endfunction

function Run_t(...)
	let g:test_all_test = a:000
	call Run_all_t()
endfunction

function Run_all_t()
	let g:test_last_test = g:test_all_test
	call Run_last_test()
endfunction

function Run_last_test()
	if len(g:test_last_test)
		wa
		call call(function('Execute_command_with_args'), g:test_last_test)
	endif
endfunction

function Run_app(...)
	let g:test_app = a:000
	call Run_current_app()
endfunction

function Run_current_app()
	if len(g:test_app)
		wa
		call Execute_command(join(g:test_app))
	endif
endfunction

function Run_test_file()
	let file=@%
	if file =~ '.feature$'
		let g:test_last_test = g:test_bdd_features + [file]
	elseif file =~ 'spec/.*.rb$'
		let g:test_last_test = ['rspec', file]
	elseif file =~ '.py$'
		let file = substitute(file, '/', '.', 'g')
		let file = substitute(file, '.py$', '', '')
		let g:test_last_test = ['python', '-m', 'unittest', file]
	endif
	call Run_last_test()
endfunction

function Run_test_file_at()
	let file=@%
	if file =~ '.feature$'
		let g:test_last_test = g:test_bdd_features + [file.':'.line('.')]
	elseif file =~ 'spec/.*.rb$'
		let g:test_last_test = ['rspec', file.':'.line('.')]
	elseif file =~ '.py$'
		let file = substitute(file, '/', '.', 'g')
		let file = substitute(file, '.py$', '', '')
		let g:test_last_test = ['python', file]
	endif
	call Run_last_test()
endfunction

command -nargs=* RunUT call Run_ut(<f-args>)
command -nargs=* RunAT call Run_at(<f-args>)
command -nargs=* RunT call Run_t(<f-args>)
command -nargs=* RunAPP call Run_app(<f-args>)

nnoremap <silent> <leader>ru :echo 'Run Unit Tests...'<cr>:call Run_current_ut()<cr>
nnoremap <silent> <leader>ra :echo 'Run Acceptance Test...'<cr>:call Run_current_at()<cr>
nnoremap <silent> <leader>rt :echo 'Run All Test...'<cr>:call Run_all_t()<cr>
nnoremap <silent> <leader>rr :echo 'Rerun test...'<cr>:call Run_last_test()<cr>
nnoremap <silent> <leader>rp :echo 'Run App...'<cr>:call Run_current_app()<cr>
nnoremap <silent> <leader>rf :echo "Run Test in \'".@%."\'..."<cr>:call Run_test_file()<cr>
nnoremap <silent> <leader>rl :echo "Run Test in \'".@%.':'.line('.')"\'..."<cr>:call Run_test_file_at()<cr>
execute "set <M-r>=\er"
inoremap <silent> <M-r> <Esc> :echo 'Rerun test...'<cr>:call Run_last_test()<cr>
nnoremap <silent> <M-r> :echo 'Rerun test...'<cr>:call Run_last_test()<cr>

command Conf :tabnew ~/.vimrc

" tabs move
nmap <Leader>to :tabonly<CR>

" ctrl left right switch tab
inoremap <silent> <c-Left> <esc>gT
inoremap <silent> <c-right> <esc>gt
noremap <silent> <c-Left> gT
noremap <silent> <c-right> gt

execute "set <M-L>=\e\e[D"
execute "set <M-R>=\e\e[C"
noremap <silent> <M-L> :tabmove -1<cr>
inoremap <silent> <M-L> <esc>:tabmove -1<cr>
noremap <silent> <M-R> :tabmove +1<cr>
inoremap <silent> <M-R> <esc>:tabmove +1<cr>

execute "set <M-h>=\eh"
execute "set <M-l>=\el"
noremap <silent> <M-h> :tabmove -1<cr>
inoremap <silent> <M-h> <esc>:tabmove -1<cr>
noremap <silent> <M-l> :tabmove +1<cr>
inoremap <silent> <M-l> <esc>:tabmove +1<cr>


"move lines
function s:Move_line_up(l)
	let line_content = getline(a:l, a:l)
	let line_content_up = getline(a:l-1, a:l-1)
	call setline(a:l, line_content_up)
	call setline(a:l-1, line_content)
endfunction
function s:Move_line_down(l)
	let line_content = getline(a:l, a:l)
	let line_content_up = getline(a:l+1, a:l+1)
	call setline(a:l, line_content_up)
	call setline(a:l+1, line_content)
endfunction

function Move_line_up()
	call s:Move_line_up(line('.'))
	normal k
endfunction

function Move_line_down()
	call s:Move_line_down(line('.'))
	normal j
endfunction

function Move_lines_up()
	let ls = line("'<")
	let le = line("'>")
	for i in range(ls, le)
		call s:Move_line_up(i)
	endfor
	let ls=ls-1
	let le=le-1
	if ls>le
		exe "normal ".le."GV".ls."G"
	else
		exe "normal ".ls."GV".le."G"
	endif
endfunction

function Move_lines_down()
	let ls = line("'<")
	let le = line("'>")
	let i = le
	while i >= ls
		call s:Move_line_down(i)
		let i = i-1
	endwhile
	let ls=ls+1
	let le=le+1
	if ls>le
		exe "normal ".ls."GV".le."G"
	else
		exe "normal ".le."GV".ls."G"
	endif
endfunction

execute "set <M-U>=\e\e[A"
execute "set <M-D>=\e\e[B"
nnoremap <silent> <M-U> :call Move_line_up()<CR>
inoremap <silent> <M-U> :call Move_line_up()<CR>
vnoremap <silent> <M-U> <ESC>:call Move_lines_up()<CR>
nnoremap <silent> <M-D> :call Move_line_down()<CR>
inoremap <silent> <M-D> :call Move_line_down()<CR>
vnoremap <silent> <M-D> <ESC>:call Move_lines_down()<CR>

nnoremap <silent> <leader>sh :shell<CR>

execute "set <M-j>=\ej"
execute "set <M-k>=\ek"
nnoremap <silent> <M-k> :call Move_line_up()<CR>
inoremap <silent> <M-k> :call Move_line_up()<CR>
vnoremap <silent> <M-k> <ESC>:call Move_lines_up()<CR>
nnoremap <silent> <M-j> :call Move_line_down()<CR>
vnoremap <silent> <M-j> <ESC>:call Move_lines_down()<CR>
inoremap <silent> <M-j> :call Move_line_down()<CR>

for f in split(glob('~/.vimrc.d/*.vimrc'))
	exe 'source '. f
endfor

function Reset_color_settings()
	for color in g:color_settings
		exe color
	endfor
endfunction
cal Reset_color_settings()

function Source_session()
	let path=expand('%:p:h')
	if filereadable(path."/.session.vim")
		silent exe "source ".path."/.session.vim"
	endif
endfunction

call Source_session()
