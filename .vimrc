" Robert Holt's vimrc file
" 
" Adapted from Bram Moolenaar's original with
" contributions from many other resources
"
" It is far from optimal, probably even with conflicting packages.
"
" You use this entirely at your own risk.

" This vim toolchain uses Tim Pope's Pathogen to install
" the following packages:
"   - emmet-vim
"   - ghcmod-vim
"   - html5-vim
"   - Pychimp-vim
"   - supertab
"   - syntastic
"   - ultisnips
"   - vim-atom-dark
"   - vim-colorschemes
"   - vim-colors-solarized
"   - VimCompletesMe
"   - vim-erlang-compiler
"   - vim-erlang-omnicomplete
"   - vim-fugitive
"   - vim-snippets
"   - vimtex
"   - YouCompleteMe
"
" Also installed by separate means:
"   - eclim

if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Use Tim Pope's Pathogen as plugin manager
" Currently disabled plugins
let g:pathogen_disabled = []
call add(g:pathogen_disabled, 'supertab')
call add(g:pathogen_disabled, 'ultisnips')
call add(g:pathogen_disabled, 'VimCompletesMe')
"call add(g:pathogen_disabled, 'YouCompleteMe')
"call add(g:pathogen_disabled, 'emmet-vim')

execute pathogen#infect()

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif

set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
  set undodir=~/.vim/undo
endif

set encoding=utf-8
set shell=/bin/bash
set clipboard=unnamed
set title

set colorcolumn=80
set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4
set tw=80               " textwidth set to 80 chars
set nu
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Get command completion to be more like bash
set wildmode=longest:full,full
set wildmenu

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Syntastic settings
let g:syntastic_mode_map = { 'mode': 'active',
    \ 'active_filetypes': [],
    \ 'passive_filetypes': [] }
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_ocaml_checkers = ['merlin']
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_haskell_checkers = ['ghc-mod', 'hlint']

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Give GNOME terminal its colours back
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set background=dark
  set hlsearch
  "
  " Keep a list here of colour schemes I like
  "
  "colo desert256
  "colo desert
  "colo desertEx
  "colo miko
  "colo pychimp
  "colo inkpot
  "colo neverness
  "colo molokai
  "colo blackboard
  "colo xoria256
  "colo mizore
  "colo jellybeans
  "colo maroloccio
  "colo railscasts
  "colo sorcerer
  "colo vividchalk
  "colo wombat256i
  "colo wuye
  "set background=light
  "colo radicalgoodspeed
  colo atom-dark-256
  "set bg=light
  "let g:solarized_termcolors = 256
  "colo solarized
  "let g:zenburn_high_Contrast = 1
  "colo zenburn
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
  set omnifunc=syntaxcomplete#Complete

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 80 characters.
  autocmd FileType text setlocal textwidth=80 spell

  " HTML file settings
  autocmd FileType html call SetHTMLOptions()

  " CSS file settings
  autocmd FileType css call SetCSSOptions()

  " Vim file settings
  autocmd FileType vim setlocal shiftwidth=2 softtabstop=2 tabstop=2

  " Haskell file settings
  autocmd FileType haskell call SetHaskellOptions()

  " OCaml file settings
  autocmd FileType ocaml setlocal shiftwidth=2 tabstop=2 softtabstop=2

  " Bash file settings
  autocmd FileType sh setlocal shiftwidth=2 tabstop=2 softtabstop=2

  " Use the vividchalk theme for LaTeX files
  autocmd FileType latex colo vividchalk

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Set syntax types for strange files
  au BufRead,BufNewFile .jshintrc,.eslintrc,.tern-project set filetype=json

  " Interpret .pl files as Prolog, not Perl
  au BufRead,BufNewFile *.pl set filetype=prolog

  augroup END

else

  set autoindent		" always set autoindenting on
  set smartindent

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Configure merlin for use with vim (for OCaml...)
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" Configure ocp-indent
set rtp^="/home/rob/.opam/system/share/ocp-indent/vim"

" Configure eclim (Java - eclipse/vim) to use vim's omnicompletion
let g:EclimCompletionMethod = 'omnifunc'

" Make YCM/Supertab/Syntastic share and care
let g:ycm_server_python_interpreter = '/usr/bin/python2.7'
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm/.ycm_extra_conf.py'
let g:ycm_register_as_syntastic_checker = 1
"let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<C-S-TAB>', '<Up>']
let g:ycm_collect_identifiers_from_tags_files = 1

" Disable YCM when using Java (for eclim)
let g:ycm_filetype_specific_completion_to_disable = {'java':''}

" Omnicomplete remappings to make things faster
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>

" Bring ghc-mod to the party by showing it the PATH
let $PATH = $PATH . ':' . expand('~/.local/bin')

" Make Emmet play nicely with others
let g:user_emmet_leader_key=','

" Syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1

" ghc-mod settings
map <silent> tw :GhcModTypeInsert<CR>
map <silent> ts :GhcModSplitFunCase<CR>
map <silent> tq :GhcModType<CR>
map <silent> te :GhcModTypeClear<CR>

function SetHTMLOptions()
  setlocal shiftwidth=2 tabstop=2 softtabstop=2
  setlocal omnifunc=htmlcomplete#CompleteTags
endfunction

function SetCSSOptions()
  setlocal omnifunc=csscomplete#CompleteCSS
  setlocal shiftwidth=2 softtabstop=2
endfunction

function SetHaskellOptions()
  let g:haskellmode_completion_ghc = 1
  setlocal shiftwidth=2 tabstop=2 softtabstop=2
  setlocal omnifunc=necoghc#omnifunc
endfunction
