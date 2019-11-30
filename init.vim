" neovim settings
"
" <leader> -> \
" <C> -> Control
" j: down
" k: up
" h: left
" l: right

" for buggy terminal
set guicursor=

" Stop certain movements from always going to the first character of a line.
set nostartofline

" Set encoding
set encoding=utf-8

" whitespaces
set expandtab
set tabstop=4
set shiftwidth=4

" set title of terminal
set title

" make sure number in gutter is not copied
set mouse=a

" Split: behavior and shortcut
" reszie +5 / vertical resize -
" ctrl-w = (vertical)
" ctrl-w | (max width)
" ctrl-w _ (max height)
" ctrl-w R (swap)
" ctrl-w T (move to tab)
" ctrl-w o (close all window but current)
set splitbelow
set splitright

" navigations, down (j), up (k), right (l), left(h)
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Copy to clipboard
nnoremap  <leader>y  "+y
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>yy  "+yy

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" == neovim only ==
" NeoVim Term: map <Esc> to exit terminal-mode
tnoremap <Esc> <C-\><C-n>


" live substitute
if exists('&inccommand')
  set inccommand=split
endif

" == vim plugins ==
" install vim-plug if not found
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plug: vim plugins, use single quote
call plug#begin('~/.local/share/nvim/plugged')
" general settings
Plug 'tpope/vim-sensible'
" colorscheme and syntax
Plug 'flazz/vim-colorschemes'
Plug 'robertmeta/nofrils'
Plug 'sheerun/vim-polyglot'
" status
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" git
Plug 'tpope/vim-fugitive'
" gutter
Plug 'airblade/vim-gitgutter'
Plug 'myusuf3/numbers.vim'
" code search and navigation
Plug 'haya14busa/incsearch.vim'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'majutsushi/tagbar'
" file search and navgigation
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.local/share/fzf', 'do': './install --all' }
if executable("black")
  Plug 'psf/black'
endif
call plug#end()

" vim-colorschemes:
" silent! colorscheme molokai_dark
silent! colorscheme nofrils-dark

" airline-themes:
let g:airline_theme='minimalist'

" TagBar:
nmap <Leader>rt :TagbarToggle<CR>

" NERDTree:
map <C-n> :NERDTreeToggle<CR>

" Black:
if executable("black")
  let g:black_virtualenv = '/usr/local/bin/'
endif
