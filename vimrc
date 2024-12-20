set secure " do not allow unsafe commands in vim config files
set exrc " local vim config files have precidence


" dotnet settings
" set makeprg=dotnet
" set errorformat+=%f(%l\\,%c):\ error\ CS%n:\ %m\ [%o]
" set errorformat+=%f(%l\\,%c):\ error\ MC%n:\ %m\ [%o]
" format xaml as xml, becasue syntax is similar
au BufNewFile,BufRead *.xaml        setf xml
" end of temp dotnet settings

syntax enable
filetype plugin indent on

" rust settings 
let &efm = ''
" Random non issue stuff
let &efm .= '%-G%.%#aborting due to previous error%.%#,'
let &efm .= '%-G%.%#test failed, to rerun pass%.%#,'
" Capture enter directory events for doc tests
let &efm .= '%D%*\sDoc-tests %f%.%#,'
" Doc Tests
let &efm .= '%E---- %f - %o (line %l) stdout ----,'
let &efm .= '%Cerror%m,'
let &efm .= '%-Z%*\s--> %f:%l:%c,'
" Unit tests && `tests/` dir failures
" This pattern has to come _after_ the doc test one
let &efm .= '%E---- %o stdout ----,'
let &efm .= '%Zthread %.%# panicked at %m\, %f:%l:%c,'
let &efm .= '%Cthread %.%# panicked at %m,'
let &efm .= '%+C%*\sleft: %.%#,'
let &efm .= '%+Z%*\sright: %.%#\, %f:%l:%c,'
" Compiler Errors and Warnings
let &efm .= '%Eerror%m,'
let &efm .= '%Wwarning: %m,'
let &efm .= '%-Z%*\s--> %f:%l:%c,'

" navigate in normal mode
nnoremap <Left>  :call ForceWinCMD('h')<CR>
nnoremap <Down>  :call ForceWinCMD('j')<CR>
nnoremap <Up>    :call ForceWinCMD('k')<CR>
nnoremap <Right> :call ForceWinCMD('l')<CR>
" navigate in term mode
tnoremap <Left>  <C-\><C-N><Esc>:call ForceWinCMD('h')<CR>
tnoremap <Down>  <C-\><C-N><Esc>:call ForceWinCMD('j')<CR>
tnoremap <Up>    <C-\><C-N><Esc>:call ForceWinCMD('k')<CR>
tnoremap <Right> <C-\><C-N><Esc>:call ForceWinCMD('l')<CR>

function! ForceWinCMD(direction)
    if a:direction =~# '^[hjkl]$'
        let start_window = winnr()
        exec 'wincmd ' . a:direction

        if start_window == winnr() 
            " edge reached, make a new window pane
            call AutoSplit(a:direction)
        else
            " clear empty buffers upon exit
            call KillWindowIfEmpty(start_window)
            call DefaultToTerminalMode()
        endif
    else
        echoerr "Invalid direction. Use on of: h, j, k, l."
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
function! KillWindowIfEmpty(window)
    if a:window > 0 && a:window <= winnr('$')
        let buffer = winbufnr(a:window)

        if join(getbufline(buffer, 1, '$')) !~# '\S'
            execute a:window . 'wincmd q'
        endif
    else
        echoerr "Invalid window number."
    endif
endfunction
function! DefaultToTerminalMode()
    if &filetype ==# 'terminal'
        echo "TERMINAL"
        call feedkeys("a")
    else
        echo " not TERMINAL"
    endif
endfunction


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

" explore
command! E Explore

" colors
color nord
set background=dark

" font size
set guifont=Menlo:h13






