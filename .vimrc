"--- add entries to run time path
set rtp+=$GOROOT/misc/vim

"--- handle special case for golang
autocmd FileType go setlocal nolist noexpandtab shiftwidth=4 softtabstop=4 tabstop=4

"--- This is some standard stuff
syntax on
filetype plugin indent on
set autoindent
set backspace=2
set tabstop=4
set shiftwidth=4
set expandtab
set showmatch
set ruler
set incsearch
set nowrap
set mouse=a
set nohls
set modeline
set ls=2
set colorcolumn=80
filetype indent on
filetype plugin on
set number
set ofu=syntaxcomplete#Complete
set viminfo='100,f1
set ww=h,l,b,s,<,>

"--- This improves highlight colors in vimdiff
set t_Co=256
colo ron
highlight DiffText term=standout ctermfg=0 ctermbg=11

"--- This improves colors in autocompletion
highlight PmenuSel ctermfg=11 ctermbg=18
highlight Pmenu ctermfg=0 ctermbg=7

"--- This is a shortcut for the NERDTree plugin
"nmap <C-t> :NERDTreeToggle<cr>

"---These commands make windows-like copy/paste.
"   To get them to work, you must add the following to your .cshrc or .bashrc
"   stty stop ''
"   stty start''
"map <C-c> y
"map<C-x> x
"imap <C-v> <Esc>pi
imap <C-s> <Esc>:w<CR>i
nmap <C-s> :w<CR>
nmap <C-q> :q<CR>
imap <C-q> <Esc>:q<CR>

"--- Make some shortcuts for toggling mouse
nmap <C-m> :set nopaste<CR> :set number<CR> :set mouse=a<CR>  
nmap <C-n> :set paste<CR> :set nonumber<CR> :set mouse=<CR>

"--- this allows for repeated block indenting in v-mode like komodo
vmap <Tab> >`[v`]
vmap <S-Tab> <`[v`]

"--- this allows for some nice tab completion in insert mode
"#   shift-tab for file completion  tab for variable completion
imap <S-Tab> <C-x><C-f>
imap <Tab> <C-n>

"---- make control-P insert the full path of the current file
nmap <C-p> :let @" = expand("%:p")<CR>P

"---- This allows tab to switch windows in normal mode
nmap <CR> <C-w>w

"---- This allows switching tabs in normal mode
nmap <S-Tab> :tabn<CR>

"---- This allows opening copy of this window in new tab
nmap <S-t> <C-w>s<C-w><S-T>


"---this remaps the numeric keypad to behave reasonably
if &term=="xterm" || &term=="xterm-color"
   set t_Sb=^[4%dm
   set t_Sf=^[3%dm
   :imap <Esc>Oq 1
   :imap <Esc>Or 2
   :imap <Esc>Os 3
   :imap <Esc>Ot 4
   :imap <Esc>Ou 5
   :imap <Esc>Ov 6
   :imap <Esc>Ow 7
   :imap <Esc>Ox 8
   :imap <Esc>Oy 9
   :imap <Esc>Op 0
   :imap <Esc>On .
   :imap <Esc>OQ /
   :imap <Esc>OR *
   :imap <Esc>Ol +
   :imap <Esc>OS -
endif

"---this sets vim to understand relative tag path
set tagrelative

