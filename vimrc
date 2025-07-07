" tabs and indentation and some misc shit
set laststatus=2
set textwidth=80
set colorcolumn=81
set linebreak
set cursorline
set hlsearch
set ruler
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set expandtab 
filetype plugin indent on

" line width shit
set wrap
set breakindent
set breakindentopt=shift:4
set linebreak


" experinmental refactor command
command! -nargs=1 R execute '%s/\<' . expand('<cword>') . '\>/' . <q-args> . '/gc'

set tags
" ai chat shit that needs to be in a pull request to the plugin but i am a lazy
" undiciplined scumbag who leaches off open source projects & never contributes
command! -nargs=* A execute 'AIChat ' join([<f-args>], ' ')
command! -nargs=* E execute 'Explore ' join([<f-args>], ' ')
command! T call UpdateTags()
function! UpdateTags()
    let githead = GitHeadFromCurrentPhile()

    let excludeflag = ''
    for file in GitIgnored()
        let excludeflag .= ' --exclude=' . githead . '/' . file
    endfor

    let tagfile = githead . 'tags'
    call delete(tagfile)
    
    let taggencmd = 'ctags' . ' -R -f ' . tagfile . excludeflag
    call system(taggencmd . ' ' . githead)

    execute 'set tags=' . tagfile
endfunction

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
            let dir = expand('%:h')
            call AutoSplit(a:direction)
            execute ':Explore ' . dir
        endif 

        " dont leave empty windows open
        if leaving_dead_window 
            execute old_window . 'wincmd q'
        endif

        execute ':wincmd ='
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
function! GitHead(path)
    let flags = ' rev-parse --show-toplevel 2>/dev/null'
    let cmd = 'git -C ' . a:path . flags
    let root = trim(system(cmd))
    return isdirectory(root)? fnamemodify(root, ':p') : ''
endfunction
function! GitHeadFromCurrentPhile()
    return GitHead(expand('%:p:h'))
endfunction
function! GitHeadFromCurrentWorkingDir()
    return GitHead(getcwd())
endfunction
function! GitIgnored()
    let naughtylist = []
    let gitignorefilepath = GitHeadFromCurrentPhile() . '/.gitignore'
    if filereadable(gitignorefilepath)
        for line in readfile(gitignorefilepath)
            if !empty(line) && line !=# '^#'
                call extend(naughtylist, glob(line, 0, 1))
            endif
        endfor
    endif
    return naughtylist
endfunction
function! GitModules()
    let submodslist = []
    let githead = GitHeadFromCurrentPhile()
    let modulesfile = githead . '/.gitmodules'
    if filereadable(modulesfile)
        for line in readfile(modulesfile)
            let path = matchstr(line, '^\s*path\s*=\s*\zs.\+\ze\s*$')
            if isdirectory(path)
                call add(submodslist, githead . path)
            endif
        endfor
    endif
    return submodslist 
endfunction
" AUTO LINE NUMBERS
autocmd WinEnter,BufWinEnter,WinResized,InsertLeave * call AutoLineBar()
function! AutoLineBar()
    if line('$') <= 0x0f
        set nonumber
        set norelativenumber
    elseif line('$') <= 0x1f
        set number
        set norelativenumber
    else
        set number
        set relativenumber
    endif
endfunction

" html files are also opened in a browser. this is convienent when writing html
" or viewing docs generated by rust from a <C-]>.
augroup HtmlAutoCmd
    autocmd!
    autocmd BufRead,BufNewFile *.html
        \ silent! execute '!open ' . shellescape(expand('%:p'))
augroup END


" when a font is changed, go ahead and resize all the windows
augroup AutoResizeWindows
    autocmd!
    autocmd OptionSet guifont :wincmd =
augroup END

" apply syntax highlighting settings
syntax enable

" rust files are autoformatted when saved
" TODO figure this out for c code!
let g:rustfmt_autosave = 1
let g:netrw_keepdir = 1

" enable builtin man page viewer plugin
runtime! ftplugin/man.vim
:helptags ALL


" let vim use latex for text formatting shit
let $PATH = '/Library/TeX/texbin:' . $PATH


" autocmds cannot modify .vimrc or .exrc
set secure 
echom 'vim config loaded'

color gruvbox
set guifont=CourierNewPS-ItalicMT:h14






