" vimrc
set nocompatible
set mouse=a

" whitespaces
set expandtab
set tabstop=4
set shiftwidth=4

" Stop certain movements from always going to the first character of a line.
set nostartofline

" Set encoding
set encoding=utf-8

" Indent and Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.pyc,*.rbc,*.class,.svn,vendor/gems/*,*/tmp/*,*.so,*.swp,*.zip

" 'set paste' interfere with autoindent
set pastetoggle=<F2>

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
au VimLeave * :!clear

" yaml for ansible
" autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" python: remove trailing spaces
autocmd BufWritePre *.py :%s/\s\+$//e

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" == vim plugins ==

" install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py
  endif
endfunction

" vim plugins, use single quote
call plug#begin('~/.vim/plugged')
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
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
call plug#end()

" vim-colorschemes
silent! colorscheme zenburn

" airline-themes
let g:airline_therme='onedark'

" CtrlP
let g:ctrlp_working_path_mode = 'ra'
nmap <Leader>r :CtrlPBufTag<CR>

" TagBar
nmap <Leader>rt :TagbarToggle<CR>

" NERDTree
map <C-n> :NERDTreeToggle<CR>

" syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8']

" EasyMotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

