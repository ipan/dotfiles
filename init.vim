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

" whitespaces
set expandtab
set tabstop=4
set shiftwidth=4

" Term: map <Esc> to exit terminal-mode
tnoremap <Esc> <C-\><C-n>

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

" install vim-plug if not found
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plug: vim plugins, use single quote
call plug#begin('~/.local/share/nvim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'easymotion/vim-easymotion'
Plug 'fatih/vim-go'
Plug 'flazz/vim-colorschemes'
Plug 'haya14busa/incsearch.vim'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'majutsushi/tagbar'
Plug 'myusuf3/numbers.vim'
Plug 'pearofducks/ansible-vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ambv/black'
" works better with neovim
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'jodosha/vim-godebug'
" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()

" vim-colorschemes:
silent! colorscheme 256-grayvim

" airline-themes:
let g:airline_therme='onedark'

" CtrlP:
let g:ctrlp_working_path_mode = 'ra'
nmap <Leader>r :CtrlPBufTag<CR>

" TagBar:
nmap <Leader>rt :TagbarToggle<CR>

" NERDTree:
map <C-n> :NERDTreeToggle<CR>

" syntastic: syntax hightlight
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8']

" EasyMotion:
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" EasyMotion: <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" EasyMotion: {char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" EasyMotion: Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" EasyMotion Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" deoplete: (nvim/vim8)
let g:deoplete#enable_at_startup = 1
