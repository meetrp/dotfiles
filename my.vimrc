"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" personalized .vimrc I use.
" 
" Version:
"	1.0 - 11:09 AM 11/12/2014
"
" Courtesy:
"	The Ultimate Vim configeration - vimrc: http://amix.dk/vim/vimrc.html
"	The perfect .vimrc vim config file: http://spf13.com/post/perfect-vimrc-vim-config-file
"	Writing a valid statusline: http://vim.wikia.com/wiki/Writing_a_valid_statusline
"	A more useful statusline in vim? [closed]: http://stackoverflow.com/questions/5375240/a-more-useful-statusline-in-vim
"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" always switch to the current file directory
set autochdir


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn on the WiLd menu
set wildmenu

" command <Tab> completion, listmatches, then longest common part, then all.
set wildmode=list:longest,full

"Always show current position
set ruler
"set rulerformat=%30(%=\\:b%n%y%m%r%w\\ %l,%c%V\\ %P%)

" Height of the command bar
set cmdheight=2

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" display the current mode
set showmode

" highlight the cursor line
set cursorline

" auto fold code
set foldenable

" the /g flag on :s substitutions by default
set gdefault

" Highlight problematic whitespace
set list
set listchars=tab:>.,trail:.,extends:\#,nbsp:.


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" color scheme
colorscheme desert
set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
	set guioptions-=T
	set guioptions+=e
	set t_Co=256
	set guitablabel=%M\ %t
endif

" Set the font based on the OS
if has("gui_running")
	if has("gui_gtk2")
		set guifont=Inconsolata\ 16
	elseif has("gui_macvim")
		set guifont=Menlo\ Regular:h14
	elseif has("gui_win32")
		set guifont=Consolas:h11:cANSI
	endif
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git, etc anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
" set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" enable numbers
set nu

" auto indentation: indent at the same level of the previous line
set autoindent

" do not wrap the lines
set nowrap

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=
set statusline +=[%n]\ 				"buffer number
set statusline +=\ %<%F				"full path
set statusline +=\ %m%*				"modified flag
set statusline +=%r%*				"read-only flag
set statusline +=%h%*				"help buffer flag
set statusline +=%w%*				"preview window flag
set statusline +=[%Y%*]				"file type
set statusline +=[%{&ff}%*]			"file format
set statusline +=%=\ line:%l		"current line
set statusline +=/%L				"total lines
set statusline +=\ col:%c\ 			"column number
set statusline +=\ \ %p%%			"virtual column number
set statusline +=\ \ [%{strftime(\"%H:%M:%S\ %b\ %d\"\ )}]		"date & time
