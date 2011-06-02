"""""""""""""""""""""""""""""""""""" 
" Pathogen setup                   "
"""""""""""""""""""""""""""""""""""" 

" Needed on some linux distros.
filetype off 

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()


"""""""""""""""""""""""""""""""""""" 
"""""""""""""""""""""""""""""""""""" 

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
	finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" if has("vms")
"   set nobackup		" do not keep a backup file, use versions instead
" else
"   set backup		" keep a backup file
" endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
		au!

		" For all text files set 'textwidth' to 78 characters.
		autocmd FileType text setlocal textwidth=78

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		autocmd BufReadPost *
					\ if line("'\"") > 0 && line("'\"") <= line("$") |
					\   exe "normal g`\"" |
					\ endif

	augroup END

	" Autocommands for c and c++ filetypes.
	augroup cpp
		autocmd!

		" Reads the template file replacing the tags by the actual
		" information and insert the result at the beginning of the buffer. At
		" the end, creates two blank lines at the end of the file and
		" position the cursor at the first one.
		function! s:insert_description()
			let template = $HOME . "/.vim/template/cpp.template"
			let file_name = expand("%:t") " Get file name without path
			let date = strftime("%Y") " Get the current year in format YYYY
			let i = 0
			for line in readfile(template)
				let line = substitute(line, "<file_name>", file_name, "ge")
				let line = substitute(line, "<date>", date, "ge")
				call append(i, line)
				let i += 1
			endfor
			execute "normal! Go\<Esc>k"
		endfunction
		autocmd BufNewFile *.{c++,cpp,cc,c,h,hpp} call <SID>insert_description()

		" Inserts guards on header files. The headers are included starting at
		" the current cursor line. One line if left blank between #define and
		" #endif tags and is where the cursor is released at the end of the
		" execution.
		function! s:insert_guard()
			let guard_name = "__" . substitute(toupper(expand("%:t")), "\\.", "_", "g") . "__"
			execute "normal! i#ifndef " . guard_name
			execute "normal! o#define " . guard_name . " "
			execute "normal! o#endif /* " . guard_name . " */"
			execute "normal! O\<Esc>"
		endfunction
		autocmd BufNewFile *.{h,hpp} call <SID>insert_guard()

	augroup END

else

	set autoindent		" always set autoindenting on

endif " has("autocmd")




"""""""""""""""""""""
" Personal settings "
"""""""""""""""""""""

" Color scheme
colorscheme darkblue

" Disable the creation of backup files (the ones ending with ~)
set nobackup

" enable mouse 'all'
set mouse=a

" line numbers
set number

" Keep the cursor away from top/bottom
set scrolloff=4

" TAB completion (such as bash)
set wildmode=longest,list

"set cindent " c-style indentation
set shiftwidth=4    " # of spaces of auto indent
set softtabstop=4   " # of spaces of <TAB> key
set tabstop=4       " # of spaces erased when deleting a <TAB>
set expandtab       " Insert spaces instead of tabs
set smarttab        " 'siftwidth' in front of a line

" Always show a status bar
set laststatus=2

" Ignore case when search pattern is all lowercase
set smartcase



""""""""""""""""
" Key mappings "
""""""""""""""""
" Warning: <F1> is mapped to display help

" Clear search highlighting
nnoremap <silent> <F2> :nohlsearch<CR>

" Edit-compile-edit cycle shortcuts
nnoremap <F3> :make<CR>
nnoremap <F4> :make run<CR>
nnoremap <F5> :make clean<CR>
nnoremap <F6> :make ctags<CR>
nnoremap <F7> :cp<CR>
nnoremap <F8> :cn<CR>

" NERDTree
nnoremap <silent> <F9> :NERDTreeToggle<CR>

" Tagbar
let g:tagbar_sort = 0      " Display tags the same order they appear in the source file
let g:tagbar_autofocus = 1 " Change the focus to the Tagbar window whenever it is opened
nnoremap <silent> <F10> :TagbarToggle<CR>

" Use ctrl-[hjkl] to select the active split!
nnoremap <silent> <C-K> <C-W>k
nnoremap <silent> <C-J> <C-W>j
nnoremap <silent> <C-H> <C-W>h
nnoremap <silent> <C-L> <C-W>l


" These are command mapping used as an alternative for when the function keys
" are not available (on the macbook for instance)
nnoremap <silent> <leader>a :NERDTreeToggle<CR>
nnoremap <silent> <leader>f :TagbarToggle<CR>
