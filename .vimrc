
" =========================================================
"                           Notes
" Last updated: 13/05/2018

" Requirements:
" - Git
" - Python 3.6.x
" - ctags

" Based on:
" - https://github.com/spf13/spf13-vim/blob/3.0/.vimrc
" - https://github.com/HuntedCodes/.dotfiles/blob/master/dotfiles/files/.vimrc
" - https://www.youtube.com/watch?v=XA2WjJbmmoM

" TODO: Plugins, cross-compatibility


" =========================================================
"                           Environment
set nocompatible
set encoding=utf-8

" Identify platform
silent function! OSX()
    return has('macunix')
endfunction

silent function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction

silent function! WINDOWS()
    return  (has('win32') || has('win64'))
endfunction

" Windows Compatibility
" On Windows, also use '.vim' instead of 'vimfiles'.
" This makes synchronization across different platforms easier.
if WINDOWS()
    set runtimepath=[
                \$HOME/.vim,
                \$VIM/vimfiles,
                \$VIMRUNTIME,
                \$VIM/vimfiles/after,
                \$HOME/.vim/after,
                \]
    source $VIMRUNTIME/mswin.vim
    behave mswin
endif


" =========================================================
"                           General
if !WINDOWS()
    set term=$TERM                  " Make arrow and other keys work
endif

scriptencoding utf-8
set mouse=a                         " automatically enable mouse usage
set shortmess+=filmnrxoOtT          " abbreviation of messages (avoids 'hit enter')
set virtualedit=onemore             " Allow for cursor beyond last character
set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
set history=1000                                " Store a ton of history (default is 20)
set dictionary+=/usr/share/dict/words
"set spell spelllang=en_gb                      " spell checking on
silent! nnoremap <F6> :setlocal spell! spelllang=en_gb<CR>
"silent! nnoremap <F7> :SyntasticToggleMode<CR>
"silent! nnoremap <F8> :SyntasticCheck<CR>
syntax on                                       " syntax highlighting

cabbr <expr> %% expand('%:p:h')

set backup                                      " keep backups
" Directories for backup, swap, and views will be set by the call to InitializeDirectories() at the bottom


" =========================================================
"                           Formatting and editing
set nowrap                          " don't wrap long lines
set tabstop=4                       " 4 space tab
set shiftwidth=4                    " the amount to block indent when using < and >
set softtabstop=4                   " let backspace delete indent
set expandtab                       " always insert tabs as spaces
set smartindent                     " do smart autoindenting when starting a new line
set autoindent                      " indent at the same level of the previous line
set cindent                         " stricter indentation for C files
set pastetoggle=<F12>               " pastetoggle (sane indentation on pastes)
set backspace=indent,eol,start      " make backspace work
set fileformat=unix                 " Use unix line breaks
set undofile                        " Undo enabled, even after closing (.un~)

filetype plugin indent on           " Automatically detect file types.

if has("autocmd") && exists("+omnifunc")
    autocmd Filetype *
                \ if &omnifunc == "" |
                \ setlocal omnifunc=syntaxcomplete#Complete |
                \ endif
endif
"autocmd FileType c,cpp,java,php,js,python,twig,xml,yml
"autocmd FileType python set omnifunc=python3complete#Complete

" Remove trailing whitespaces and \^M chars
autocmd! BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\\\s\\\\+$","","")'))


" =========================================================
"                           Navigation
" File browsing
" Read :help netrw-browse-maps for more info
let g:netrw_banner=0                            " Remove banner
let g:netrw_browse_split=4                      " Open in prior window
let g:netrw_altv=1                              " Open splits to the right
let g:netrw_liststyle=3                         " Tree view
" Hide files
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" Finding files
set path+=** " Descend into subdirectories from the current path
set wildmenu " Display all matching files when tab complete

" Jump to definition
" https://www.fusionbox.com/blog/detail/navigating-your-django-project-with-vim-and-ctags/590/
" Add the following options to your ~/.ctags:
"  --fields=+l
"  --languages=python
"  --python-kinds=-iv
set tags=.tags
command! MakeTags :call GenerateTagsFile()

" Search
set incsearch                               " incremental search
set ignorecase                              " case insensitive search
set smartcase                               " case sensitive when uppercase
set wildignore+=*/tmp/*,*.so,*.swp,*.zip    " Ignore these file types when searching


" =========================================================
"                           Snippets
nnoremap <leader> snip :read $HOME/.vim/snippets/
nmap <leader> html :read $HOME/.vim/snippets/skeleton.html<CR>


" =========================================================
" Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
"Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
"Plug 'SirVer/ultisnips'
"Plug 'Valloric/YouCompleteMe', { 'dir': '~/.vim/plugged/YouCompleteMe', 'do': './install.py --all' }
"Plug 'davidhalter/jedi-vim'
"Plug 'elzr/vim-json'
"Plug 'honza/vim-snippets'
"Plug 'jistr/vim-nerdtree-tabs'
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"Plug 'maralla/completor.vim'
"Plug 'mxw/vim-jsx'
"Plug 'pangloss/vim-javascript'
"Plug 'scrooloose/nerdtree'
"Plug 'scrooloose/syntastic'
"Plug 'sheerun/vim-polyglot'
"Plug 'tpope/vim-surround'
"Plug 'vimwiki/vimwiki'
"Plug 'w0rp/ale'
Plug 'ajh17/VimCompletesMe'
Plug 'flazz/vim-colorschemes'
Plug 'tpope/vim-fugitive'
if has('python') || has('python3')
    Plug 'python-mode/python-mode', { 'branch': 'develop' }
endif
call plug#end()

" UltiSnips
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"let g:UltiSnipsSnippetDirectories=["UltiSnips"]

" If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"

" NerdTree
" autocmd vimenter * NERDTree " Load NERDTree on startup
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
"map <leader>e :NERDTreeFind<CR>
"nmap <leader>nt :NERDTreeFind<CR>

"let NERDTreeShowBookmarks=1
"let NERDTreeIgnore=['\\.pyc', '\\\~$', '\\.swo$', '\\.swp$', '\\.git', '\\.hg', '\\.svn', '\\.bzr']
"let NERDTreeChDirMode=0
"let NERDTreeQuitOnOpen=1
"let NERDTreeShowHidden=1
"let NERDTreeKeepTreeInNewTab=1

" Syntastic
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 0
"let g:syntastic_python_checkers = ['pylint', 'pep8']

" JSON
nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>

" fzf
map <C-p> :FZF<CR>

" Completor
"let g:completor_python_binary = system('which python3')

" ALE
"let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 0

let g:ale_python_pylint_options = '--load-plugins pylint_django'
" Enable completion where available.
"let g:ale_completion_enabled = 1

" python-mode
let g:pymode_python = 'python3'
let g:pymode_lint = 0  " ALE
let g:pymode_folding = 0  " SimplyFold
let g:pymode_run = 0
let g:pymode_breakpoint = 0
let g:pymode_options = 0
let g:pymode_doc = 0
let g:pymode_rope = 0
let g:pymode_debug = 0

let g:polyglot_disabled = ['python']  " Handled by python-mode
let g:polyglot_disabled += ['html']  " Handled by python-mode

autocmd FileType python setlocal omnifunc=pythoncomplete#Complete


" =========================================================
"                           Appearance
set background=dark     " Assume a dark background
set t_Co=256            " Enable 256 colors. Good for statusbar.

try
    colorscheme wombat256i
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme ron
endtry

set colorcolumn=80,120                  " set column markers
set cursorline                          " highlight current line
set number                              " turn on line numbers
set showmatch                           " Highlight matching brackets
set showmode                            " display the current mode
set splitright                          " open new split panes to the right

highlight CursorLine ctermbg=0
highlight ColorColumn ctermbg=0 guibg=black
" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

set list
set listchars=tab:>.,trail:.,extends:\#,nbsp:.  " show dodgy whitespace


if has('statusline')
    highlight StatusLine ctermfg=28 ctermbg=0
    highlight StatusLineNC ctermfg=32 ctermbg=0
    set statusline=
    set statusline+=%#StatusLineNC#
    set statusline+=%F                                          " full path and filename
    set statusline+=%#Statement#
    set statusline+=%m                                          " modified flag
    set statusline+=%=                                          " left / right divider
    set statusline+=%#StatusLine#
    set statusline+=%{fugitive#statusline()}
    set statusline+=%#LineNr#
    set statusline+=\ %y                                        " filetype
    set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
    set statusline+=\ %p%%
    set statusline+=\ %#Special#%l%#LineNr#[%L]:%c
    set statusline+=%#warningmsg#
    "set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    set laststatus=2                                            " always show the statusline
endif

" =========================================================
"                       Functions

function! GenerateTagsFile()
    let output_file = '.tags'
    execute '!ctags -R -f ' . output_file . " . $(python -c \"import os.path, sys; print(' '.join(f'{d}' for d in sys.path if os.path.isdir(d)))\")"
endfunction


function! InitializeDirectories()
    let parent = $HOME
    let prefix = '.vim'
    let dir_list = { '.backup': 'backupdir', '.views': 'viewdir', '.swap': 'directory' }

    for [dirname, settingname] in items(dir_list)
        let directory = parent . "/" . prefix . "/" . dirname . "/"
        if exists("\*mkdir")
            if !isdirectory(directory)
                call mkdir(directory, 'p', 0700)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction


function! NERDTreeInitAsNeeded()
    redir => bufoutput
    buffers!
    redir END
    let idx = stridx(bufoutput, "NERD_tree")
    if idx > -1
        NERDTreeMirror
        NERDTreeFind
        wincmd l
    endif
endfunction


function! FileSize()
    let bytes = getfsize(expand("%:p"))
    if bytes <= 0
        return ""
    endif
    if bytes < 1024
        return bytes
    else
        return (bytes / 1024) . "K"
    endif
endfunction


" Use the correct file source, based on context
function! ContextualFZF()
    " Determine if inside a git repo
    silent exec "!git rev-parse --show-toplevel"
    redraw!

    if v:shell_error
        " Search in current directory
        call fzf#run({
          \'sink': 'e',
          \'down': '40%',
        \})
    else
        " Search in entire git repo
        call fzf#run({
          \'sink': 'e',
          \'down': '40%',
          \'source': 'git ls-tree --full-tree --name-only -r HEAD',
        \})
    endif
endfunction
map <C-p> :call ContextualFZF()<CR>

call InitializeDirectories()

" =========================================================

