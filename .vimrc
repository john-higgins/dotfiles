
" Notes {
  " Last updated: 27/02/2018

  " Requirements:
  " - Git
  " - Python 3.6.x
  " - ctags

  " Based on:
  " - https://github.com/spf13/spf13-vim
  " - https://www.youtube.com/watch?v=XA2WjJbmmoM

  " TODO: Plugins, cross-compatibility
" }


" Environment {
  " Basics {
    set nocompatible        " must be first line
    set background=dark     " Assume a dark background
  " }

  " Windows Compatibility {
    " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization across different platforms easier.
    if has('win32') || has('win64')
        set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        source $VIMRUNTIME/mswin.vim
        behave mswin
    endif
  " }

  " Setup Bundle Support {
    " The next two lines ensure that the ~/.vim/bundle/ system works
    "runtime! autoload/pathogen.vim
    "silent! call pathogen\#helptags()
    "silent! call pathogen\#runtime_append_all_bundles()
  " }

" }


" General {
    if !has('win32') && !has('win64')
        set term=$TERM                              " Make arrow and other keys work
    endif

    scriptencoding utf-8
    set mouse=a                                     " automatically enable mouse usage
    set shortmess+=filmnrxoOtT                      " abbreviation of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
    set history=1000                                " Store a ton of history (default is 20)
    set dictionary+=/usr/share/dict/words
    "set spell spelllang=en_gb                      " spell checking on
    silent! nnoremap <F6> :setlocal spell! spelllang=en_gb<CR>
    silent! nnoremap <F7> :SyntasticToggleMode<CR>
    silent! nnoremap <F8> :SyntasticCheck<CR>

    cabbr <expr> %% expand('%:p:h')

    set backup                                      " keep backups
    " Directories for backup, swap, and views will be set by the call to InitializeDirectories() at the bottom
" }


" Formatting {
    set nu                                  " turn on line numbers
    set nowrap                              " wrap long lines
    set tabstop=4                           " 4 space tab
    set shiftwidth=4                        " the amount to block indent when using < and >
    set autoindent                          " indent at the same level of the previous line
    set expandtab                           " tabs are spaces, not tabs
    set smarttab                            " use shiftwidth instead of tabstop at start of lines
    set softtabstop=4                       " let backspace delete indent
    set pastetoggle=<F12>                   " pastetoggle (sane indentation on pastes)
    " Remove trailing whitespaces and \^M chars
    autocmd FileType c,cpp,java,php,js,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\\\s\\\\+$","","")'))
    filetype plugin indent on               " Automatically detect file types.
    syntax on                               " syntax highlighting
" }


" Plugins {
   set runtimepath+=$HOME/.vim/bundle/Vundle.vim/
   call vundle#begin()

   Plugin 'VundleVim/Vundle.vim'
   "Plugin 'scrooloose/nerdtree'
   Plugin 'scrooloose/syntastic'
   Plugin 'tpope/vim-fugitive'
   "Plugin 'tpope/vim-surround'
   "Plugin 'pangloss/vim-javascript'
   "Plugin 'SirVer/ultisnips'
   "Plugin 'honza/vim-snippets'
   Plugin 'flazz/vim-colorschemes'
   "Plugin 'vimwiki/vimwiki'
   "Plugin 'davidhalter/jedi-vim'
   "Plugin 'elzr/vim-json'
   "Plugin 'nvie/vim-flake8'
   "Plugin 'jistr/vim-nerdtree-tabs'
   "Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

   call vundle#end()

   " UltiSnips {
       let g:UltiSnipsExpandTrigger="<tab>"
       let g:UltiSnipsJumpForwardTrigger="<c-b>"
       let g:UltiSnipsJumpBackwardTrigger="<c-z>"
       let g:UltiSnipsSnippetDirectories=["UltiSnips"]

       " If you want :UltiSnipsEdit to split your window.
       " let g:UltiSnipsEditSplit="vertical"
   " }

   " NerdTree {
       " autocmd vimenter * NERDTree " Load NERDTree on startup
       "autocmd StdinReadPre * let s:std_in=1
       "autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
       "map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
       "map <leader>e :NERDTreeFind<CR>
       "nmap <leader>nt :NERDTreeFind<CR>

       let NERDTreeShowBookmarks=1
       let NERDTreeIgnore=['\\.pyc', '\\\~$', '\\.swo$', '\\.swp$', '\\.git', '\\.hg', '\\.svn', '\\.bzr']
       let NERDTreeChDirMode=0
       let NERDTreeQuitOnOpen=1
       let NERDTreeShowHidden=1
       let NERDTreeKeepTreeInNewTab=1
   " }

   " Syntastic {
       let g:syntastic_always_populate_loc_list = 1
       let g:syntastic_auto_loc_list = 1
       let g:syntastic_check_on_open = 0
       let g:syntastic_check_on_wq = 0
       let g:syntastic_python_checkers = ['pylint', 'pep8']
   " }

   " JSON {
       nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
   " }
" }


" Navigation {
  " File browsing {
    " Read :help netrw-browse-maps for more info
    let g:netrw_banner=0                            " Remove banner
    let g:netrw_browse_split=4                      " Open in prior window
    let g:netrw_altv=1                              " Open splits to the right
    let g:netrw_liststyle=3                         " Tree view
    " Hide files
    let g:netrw_list_hide=netrw_gitignore#Hide()
    let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
  " }

  " Finding files {
    set path+=** " Descend into subdirectories from the current path
    set wildmenu " Display all matching files when tab complete
  " }

  " Jump to definition {
    " https://www.fusionbox.com/blog/detail/navigating-your-django-project-with-vim-and-ctags/590/
    " Add the following options to your ~/.ctags:
    "  --fields=+l
    "  --languages=python
    "  --python-kinds=-iv
    set tags=.tags
    "command MakeTags :call GenerateTagsFile()
  " }

  " Search {
    set incsearch                                   " incremental search
    set ignorecase                                  " case insensitive search
    set smartcase                                   " case sensitive when uppercase
  " }

" }


" Snippets {
    nnoremap <leader> snip :read $HOME/.vim/snippets/
    nmap <leader> html :read $HOME/.vim/snippets/skeleton.html<CR>
" }


 " Vim UI {
    try
        colorscheme minimalist
    catch /^Vim\%((\a\+)\)\=:E185/
        colorscheme ron
    endtry

    set showmode                                                    " display the current mode
    set cursorline                                                  " highlight current line
    highlight CursorLine ctermbg=0
    set colorcolumn=80,120                                          " set column markers

    set list
    set listchars=tab:>.,trail:.,extends:\#,nbsp:.                  " show dodgy whitespace


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
        set statusline+=%{SyntasticStatuslineFlag()}
        set statusline+=%*
        set laststatus=2                                            " always show the statusline
    endif
" }


" Functions {


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
                call mkdir(directory)
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


call InitializeDirectories()

" }

