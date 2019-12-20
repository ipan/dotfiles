" vim settings
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

if has("nvim")
    " == neovim only ==
    " NeoVim Term: map <Esc> to exit terminal-mode
    tnoremap <Esc> <C-\><C-n>
else
    " == vim only ==
    " Prevent Vim from clobbering the scrollback buffer. See
    " http://www.shallowsky.com/linux/noaltscreen.html
    set t_ti= t_te=
    au VimLeave * :!clear
endif

" live substitute: neovim only
if exists('&inccommand')
  set inccommand=split
endif

" Python
let g:python_host_prog  = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

" == vim plugins ==

" Plug: install vim-plug if not found
if has('nvim')
    let g:vim_plug_install_path = '~/.config/nvim/autoload/plug.vim'
else
    let g:vim_plug_install_path = '~/.vim/autoload/plug.vim'
endif

if empty(glob(vim_plug_install_path))
  let g:vim_plug_github = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  execute "silent !curl -fLo " . g:vim_plug_install_path . " " . g:vim_plug_github
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if has('nvim')
    let g:vim_plug_dir = '~/.local/share/nvim/plugged'
else
    let g:vim_plug_dir = '~/.vim/plugged'
endif

" Plug: vim plugins, use single quote
call plug#begin(vim_plug_dir)
" general settings
Plug 'tpope/vim-sensible'
" colorscheme
Plug 'sheerun/vim-polyglot'
Plug 'robertmeta/nofrils'
Plug 'arzg/vim-corvine'
Plug 'dracula/vim'
Plug 'jdsimcoe/panic.vim'
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
" python
Plug 'tweekmonster/impsort.vim'
if executable("black") && has("python3")
    Plug 'psf/black'
endif
if has("python3")
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

  if !has("nvim")
    " below needed for vim
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

  Plug 'deoplete-plugins/deoplete-jedi'
  Plug 'deoplete-plugins/deoplete-zsh'

  Plug 'wellle/tmux-complete.vim'
endif
call plug#end()

" colorschemes
silent! colorscheme nofrils-dark

" airline-themes
let g:airline_theme='minimalist'

" TagBar:
nmap <Leader>rt :TagbarToggle<CR>

" NERDTree:
map <C-n> :NERDTreeToggle<CR>

" Black
if executable("black") && has("python3")
    let g:black_virtualenv = '/usr/local/bin/'
endif

" Deoplete
" Enable deoplete when InsertEnter.
if has("python3")
  let g:deoplete#enable_at_startup = 0
  autocmd InsertEnter * call deoplete#enable()
endif
