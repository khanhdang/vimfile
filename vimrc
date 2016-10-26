" This is vimrc file 
" Author: Khanh, Dang <dnk0904@gmail.com>.
"
execute pathogen#infect() 

scriptencoding utf-8   " set encoding method
set mousehide    " hide mouse when typing
set cursorline   " highlight current line
set laststatus=2 " display statusline
set statusline=%t%m[%l/%L]%y[%{&ff}][%c,%l][fullpath=%F] " Format of statusline
" now set it up to change the status line based on mode
set cmdheight=1 "command bar is 2 high
set backspace=indent,eol,start "set backspace function
set hlsearch "highlight searched things
set incsearch "incremental search
set ignorecase "ignore case
set textwidth=0 " ???
set autoread "auto read when file is changed from outside
set ruler "show current position
set nu "show line number
set showmatch "show maching braces
set autochdir "set auto change directory
set fdm=indent " set foding method
set iskeyword+=_,$,@,%,#    " These character will not divide a word
set noerrorbells " no error bell
"set compatible " set compatible with original vi
set t_Co=256 "set number of terminal colour
syntax on "turn on syntax
colorscheme molokai  "colorscheme
set background=dark
filetype plugin on " enable plugin with filetype
set smarttab
set smartindent
filetype plugin indent on
filetype indent on
set mouse=a  "use mouse every where
set guioptions-=T "remove toolbox
set guioptions-=r "remove right scroll
set guioptions-=L "remove left scroll
set guioptions-=b "remove toolbox
"set guioptions-=m  " remove menu
set ruler " add ruler
set virtualedit=all
set enc=utf-8 "set encoding=utf-8
set backup "set  back up    
au FocusLost * :wa "save when out of forcus
" Get Rid of stupid Goddamned help keys
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
" Setup backup folder, font and dictionary
if has("win32")
	set backupdir=~/vimfiles/backup "set back up directory
	set dict+=~/vimfiles/dictionary/common.dic  "add common dictionary   
  "let Powerline_symbols = 'fancy'
	"set guifont=Ubuntu\ Mono:h13
	set guifont=Consolas:h13
	"set makeprg=make
elseif has("unix")
	set backupdir=~/.vim/backup "set back up directory
	set dict+=~/.vim/dictionary/common.dic  "add common dictionary   
	set dict+=~/usr/share/dict/words
	"set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
	let Powerline_symbols = 'fancy'
	"set guifont=Monaco\ 11
	set guifont=Inconsolata
	set makeprg=make
endif
set noswapfile "remove swap file
set complete+=k " set autocomplete
set guitablabel=%{GuiTabLabel()}
let g:NERDTreeWinPos = "right"
" Mapping
map <f2> :silent ! ctags -R .<CR>
map <f3> :TagbarCurrentTag<CR>
map <f4> :TagbarToggle<CR>
map <f5> :NERDTreeToggle<CR>
map <f6> :NERDTree<CR>
map <f7> :cprev<CR>
map <f8> :cnext<CR>
map <f9> :make<CR>
map <f10> :make compile_all<CR>
map <f11> :clist<CR>
imap ;; <Esc>
" navigate without lifting hand off of keys
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>
"Changing Leader Key
let mapleader = ","
" Tab modification
map <C-t> :tabnew<CR>
map <C-TAB> :tabNext<CR>

let do_syntax_sel_menu = 1|runtime! synmenu.vim
" Call function depend on filetype :
au Filetype tcl call Func_tcl()
au Filetype vhdl call Func_vhdl()
au Filetype systemverilog call Func_systemverilog()
au Filetype verilog call Func_systemverilog()
au Filetype perl call Func_perl()
au Filetype tex call Func_Latex()
au FileType vhdl,verilog,perl au BufWritePre <buffer> :%s/\s\+$//e
au BufRead,BufNewFile *.logs,*.log set filetype=changelog
au BufRead,BufNewFile *.do,*.vsim set filetype=tcl
au BufRead,BufNewFile *.vh set filetype=verilog
au BufRead,BufNewFile *.gp set filetype=gnuplot

" Use autocomplete function
if has("autocmd") && exists("+omnifunc")
	autocmd Filetype *
				\ if &omnifunc == "" |
				\ setlocal omnifunc=syntaxcomplete#Complete |
				\ endif
endif 
" Return previous line after re-open"
augroup line_return
	au!
	au BufReadPost *
				\ if line("'\"") > 0 && line("'\"") <= line("$") |
				\ execute 'normal! g`"zvzz' |
				\ endif
augroup END
" Here is function :
" Set GUI TAB label
function! GuiTabLabel()
	" add the tab number
	let label = '['.tabpagenr()
	" modified since the last save?
	let buflist = tabpagebuflist(v:lnum)
	for bufnr in buflist
		if getbufvar(bufnr, '&modified')
			let label .= '*'
			break
		endif
	endfor
	" count number of open windows in the tab
	let wincount = tabpagewinnr(v:lnum, '$')
	if wincount > 1
		let label .= ', '.wincount
	endif
	let label .= '] '
	" add the file name without path information
	let n = bufname(buflist[tabpagewinnr(v:lnum) - 1])
	let label .= fnamemodify(n, ':t')
	return label
endfunction
" Set function of TCL file
function! Func_tcl()
	:call Func_set_spec_tab()
	"vmap <C-c>c :s/^/#/<CR>:noh<CR>
	"vmap <C-c>u :s/^#/<CR>:noh<CR>

endfunction
" Set function of tab
function Func_set_spec_tab()
	" Convert tab -> spaces
	set expandtab        " expand tab to 2 spaces
	set listchars=tab:»·,trail:·,extends:#,nbsp:· " display tab as >>>>
	set list             " display list of character
	set shiftwidth=2     " shift with 2 spaces (press tab)
	set tabstop=2        " set tab width
endfunction
" Configure VHDL file
function! Func_vhdl()
	:call Func_set_spec_tab()
	" Set dictionary
	if has("unix")
		set dict+=~/.vim/dictionary/vhdl.dic
	elseif has("win32")
		set dict+=~/vimfiles/dictionary/vhdl.dic
	endif
	"manual ctags
	let g:tlist_vhdl_settings   = 'vhdl;d:package declarations;b:package bodies;e:entities;Z:port map;a:architecture specifications;t:type declarations;p:processes;f:functions;r:procedures'
	"vmap <C-c>c :s/^/--/<CR>:noh<CR>
	"vmap <C-c>u :s/^--/<CR>:noh<CR>
	" Self-define error
	:syntax region Fixed  start= '-- Fixed' end='$'
	:syntax region Note start='-- Note' end='$'  
	:syntax region Warning start='-- Warning' end='$'  
	:syntax region Error start='-- Error' end='$'
	:syntax region Todo start='-- Todo' end='$'
	":syntax region Note start ='-- //' end="$"
	" Set errorformat
	set errorformat=**\ Error:\ %f(%l):\ %m
	set errorformat+=**\ Warning:\ %f(%l):\ %m
endfunction
" Configure systemverilog file
function Func_systemverilog()
	:call Func_set_spec_tab()
	let g:tlist_systemverilog_settings  =  'systemverilog;c:class;t:task;f:function;m:module;p:program;I:interface;e:typedef;i:input;o:output;P:parameter'
endfunction
" Configure perl file
function Func_perl()
	map <F12> <Esc>:silent ! perl %<CR><CR>
endfunction
" Configure latex file
function Func_Latex()
	:set cc=90 " the ruler of width
	:call Func_set_spec_tab()
	":AutoComplPopDisable 
let g:LatexBox_split_type="new"
let g:LatexBox_latexmk_options =
  \ '-pdflatex="pdflatex -synctex=1 %O %S"'
let g:LatexBox_viewer='SumatraPDF -reuse-instance -inverse-search '
	  \ . '"gvim --servername ' . v:servername
	  \ . ' --remote-send \"^<C-\^>^<C-n^>'
	  \ . ':drop \%f^<CR^>:\%l^<CR^>:normal\! zzzv^<CR^>'
	  \ . ':call remote_foreground('''.v:servername.''')^<CR^>\""'

"let g:LatexBox_latexmk_preview_continuously = 1
endfunction


" I dont know that is this
function! Preserve(command)
	" Preparation: save last search, and cursor position.
	let _s=@/
	let l = line(".")
	let c = col(".")
	" Do the business:
	execute a:command
	" Clean up: restore previous search history, and cursor position
	let @/=_s
	call cursor(l, c)
endfunction

map ;g :call Preserve("normal! gg=G")<CR>
