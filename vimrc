" line numbers
set number
set relativenumber
set laststatus=2
set textwidth=80
set colorcolumn=81
set cursorline
set hlsearch
set ruler

" tabs and indentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set expandtab 
filetype plugin indent on
" ARROW KEY NAVIAGATION
" navigate in normal mode
nnoremap <silent> <Left>  :call ForceWinCMD('h')<CR>
nnoremap <silent> <Down>  :call ForceWinCMD('j')<CR>
nnoremap <silent> <Up>    :call ForceWinCMD('k')<CR>
nnoremap <silent> <Right> :call ForceWinCMD('l')<CR>
" navigate in term mode
tnoremap <silent> <Left>  <C-w>:call ForceWinCMD('h')<CR>
tnoremap <silent> <Down>  <C-w>:call ForceWinCMD('j')<CR>
tnoremap <silent> <Up>    <C-w>:call ForceWinCMD('k')<CR>
tnoremap <silent> <Right> <C-w>:call ForceWinCMD('l')<CR>
" arrow keys work normally when holding alt/option in normal mode
nnoremap <A-Up>    <Up>
nnoremap <A-Down>  <Down>
nnoremap <A-Left>  <Left>
nnoremap <A-Right> <Right>
" arrow keys work normally when holding alt/option in term mode
tnoremap <A-Up>    <Up>
tnoremap <A-Down>  <Down>
tnoremap <A-Left>  <Left>
tnoremap <A-Right> <Right>
function! ForceWinCMD(direction)
    if !(a:direction =~# '^[hjkl]$')
        execute printf("%s wincmd q", old_window)
    else
        " observe window state before moving to new one
        let leaving_dead_window = InUnusedWindow()
        let old_window = winnr()

        " move 
        exec "normal! \<C-w>" . a:direction
        let new_window = winnr()

        " If move wasn't sucessful, there wasn't anywhere to go, so split.
        if(old_window == new_window)
            call AutoSplit(a:direction)
            execute ':Explore'
        endif 

        " dont leave empty windows open
        if leaving_dead_window 
            execute old_window . 'wincmd q'
        endif
    endif
endfunction
function! AutoSplit(direction)
    if a:direction ==# 'h'
        exec 'vertical   leftabove  new' 
    elseif a:direction ==# 'j'
        exec 'horizontal rightbelow new'
    elseif a:direction ==# 'k'
        exec 'horizontal leftabove  new'
    elseif a:direction ==# 'l'
        exec 'vertical   rightbelow new'
    else
        echoerr "Invalid direction. Use on of: h, j, k, l."
    endif
endfunction
function! InUnusedWindow()
    if &filetype ==# 'netrw' 
        return (expand('%:r') ==# getcwd())
    elseif &filetype ==# ''
        return (line('$') == 1) && (getline(1) ==# '')
    else 
        return 0
    endif
endfunction




" enable man page plugin
runtime! ftplugin/man.vim

" explore
command! E Explore







" why is Async make not launching cargo as it should? need to check the rust.vim
" extention code. i suspect it checks for .rs in the file name, only applying
" rust settings if in a rust file (:make doesn't work in :Explore mode or in" none-source files). Whatever Async does causes % to temporarily not be *.rs,
" because the async process likly has no file name. 




command! T call RmTags() | call Tag()

command! M call so $MYVIMRC | 

function! Tag()
    let gitroot = GitRoot(expand('%:p'))
    echo gitroot
    if !empty(gitroot)
        let flags = printf("-R -V -a -f %s", BuildIgnoreFlag())
        let tagfile = GetTagsPath()
        execute printf("!ctags %s %s %s", flags, tagfile, gitroot) 
        execute printf("set tags+=%s", tagfile)
    else
        echo "not in a git repo"
    endif
endfunction



" Evaluates to the root of the git dir containing a:path
function! GitRoot(path)
    let temppath = expand('%:p')
    let cmd = printf('git -C %s rev-parse --show-toplevel 2>/dev/null',temppath)
    let root = trim(system(cmd))
    return root
    " return isdirectory(root)? root:''
endfunction




function! RmTags()
    silent! execute printf("!rm -f %s > /dev/null",GetTagsPath())
endfunction

function! BuildIgnoreFlag()
    let excludes = ''
    for line in GetGitIgnored()
        let excludes .= printf(" --exclude=%s",line)
    endfor
    return excludes 
endfunction
function! GetTagsPath()
    let tag_file_name = 'tags'
    return printf("%s/%s",GetGitRoot(),tag_file_name)
endfunction
function! GetGitIgnored()
    let git_ignore_file = printf("%s/.gitignore", GetGitRoot())
    return filereadable(git_ignore_file)? readfile(git_ignore_file):[]
endfunction
function! GetGitModules(path)
    let submodules = []
    let file = printf("%s/.gitmodules", GetGitRoot(a:path))
    for line in filereadable(file)? readfile(file):[] 
        let submod = substitute(trim(line), '^path = ', '', '')
        let submod = substitute(submod, '.vim$', '', '')
        if isdirectory(submod)
            " echo printf('submodule documenation: %s', submod)
            call add(submodules, matches[1])
        endif
    endfor
    return submodules
endfunction




" function! CheckForHelpFiles(path
"     let plugins = GetGitModules(a:path)
"     " for plugin in plugins 
"     "     let docs = printf("%s/doc/",plugin)
"     "     if isdirectory(docs)
"     "         echo printf("helptags %s",docs)
"     "     endif
"     " endfor
" endfunction

" augroup AIChatMapping
"   autocmd!
"   " Set the mapping when entering an aichat buffer
"   autocmd FileType aichat nnoremap <silent><buffer> :w :AIChat
"   autocmd FileType aichat setlocal nonumber norelativenumber
" augroup END


" apply syntax highlighting settings
syntax enable

" autocmds cannot modify .vimrc or .exrc
set secure 
