" vim settings
"
" <leader> -> Space
" <C> -> Control
let mapleader = " "
let maplocalleader = " "
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
set number
set relativenumber
set ignorecase
set smartcase
set signcolumn=yes
if exists('&inccommand')
  set inccommand=split
endif

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

" navigations, down (j), up (k), right (l), left (h)
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Delete trailing whitespaces
" https://vim.fandom.com/wiki/Remove_unwanted_spaces
nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

if has("nvim")
    " NeoVim terminal: map <Esc> to exit terminal-mode
    tnoremap <Esc> <C-\><C-n>
else
    " == vim only ==
    " Prevent Vim from clobbering the scrollback buffer. See
    " http://www.shallowsky.com/linux/noaltscreen.html
    set t_ti= t_te=
    au VimLeave * :!clear
endif

" == vim plugins ==

" Plug: install vim-plug if not found
let g:vim_plug_install_path = '~/.vim/autoload/plug.vim'

if empty(glob(vim_plug_install_path))
  let g:vim_plug_github = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  execute "silent !curl -fLo " . g:vim_plug_install_path . " " . g:vim_plug_github " --create-dirs"
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:vim_plug_dir = '~/.vim/plugged'

" Plug: vim plugins, use single quote
call plug#begin(vim_plug_dir)

" general settings
Plug 'tpope/vim-sensible'

" colorscheme
Plug 'ghifarit53/tokyonight-vim'

" status (the Vim-compatible equivalent of lualine)
Plug 'itchyny/lightline.vim'

" git
Plug 'tpope/vim-fugitive'

" gutter
Plug 'airblade/vim-gitgutter'

" code search and navigation
Plug 'jeetsukumaran/vim-buffergator'
Plug 'majutsushi/tagbar'

" file search and navgigation
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.local/share/fzf', 'do': './install --all' }

call plug#end()

" colorscheme
silent! colorscheme tokyonight

" lightline
let g:lightline = { 'colorscheme': 'tokyonight' }

" TagBar:
nmap <Leader>rt :TagbarToggle<CR>

" NERDTree:
map <C-n> :NERDTreeToggle<CR>

" Vimux
" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>
