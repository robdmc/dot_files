"--- initialize pathogen
execute pathogen#infect()

"--- define a custom leader
let mapleader=","

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
set colorcolumn=79,119
filetype indent on
filetype plugin on
set number
set ofu=syntaxcomplete#Complete
set viminfo='100,f1
set ww=h,l,b,s,<,>
set cm=blowfish

"--- This improves highlight colors in vimdiff
set t_Co=256
"colo ron
"colo desert256
colo desert_mod
highlight DiffText term=standout ctermfg=0 ctermbg=11
highlight ColorColumn ctermbg=235 guibg=#2c2d27

"--- This improves colors in autocompletion
highlight PmenuSel ctermfg=11 ctermbg=18
highlight Pmenu ctermfg=0 ctermbg=7

"--- This is a shortcut for the NERDTree plugin
nnoremap ,e :NERDTreeToggle<cr>

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
nmap <C-b> :set nopaste<CR> :set number<CR> :set mouse=a<CR>  
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
"nmap <CR> <C-w>w
nmap \ <C-w>w
nmap <Leader>ww <C-w>w
nmap <Leader>wl <C-w>l
nmap <Leader>wh <C-w>h
nmap <Leader>wj <C-w>j
nmap <Leader>wk <C-w>k

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

"--- set up vim-flake8
autocmd FileType python map <buffer> <Leader>f :call Flake8()<CR>
let g:flake8_max_line_length=120
let g:flake8_max_complexity=10

"---  Set up ctrlp
nmap <Leader>t :CtrlP<CR>
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\.yardoc\|public\/images\|public\/system\|data\|log\|tmp$',
  \ 'file': '\.exe$\|\.so$\|\.dat$|\.pyc$'
  \ }

"--- set up ack
nmap <Leader>a :Ack! 

"--- setup jedi-vim
let g:jedi#popup_on_dot = 0
let g:jedi#completions_command = "<C-j>"
