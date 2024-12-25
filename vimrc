set secure " do not allow unsafe commands in vim config files
set exrc " local vim config files have precidence

nnoremap :topen<CR> :TagbarOpen<CR>
nnoremap :tclose<CR> :TagbarClose<CR>
nnoremap :tclose<CR> :TagbarClose<CR>

" dotnet settings
" set makeprg=dotnet
" set errorformat+=%f(%l\\,%c):\ error\ CS%n:\ %m\ [%o]
" set errorformat+=%f(%l\\,%c):\ error\ MC%n:\ %m\ [%o]
" format xaml as xml, becasue syntax is similar
au BufNewFile,BufRead *.xaml        setf xml
" end of temp dotnet settings


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



augroup AIChatMapping
  autocmd!
  " Set the mapping when entering an aichat buffer
  autocmd FileType aichat nnoremap <silent><buffer> :w :AIChat
augroup END


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

function! ForceWinCMD(direction)
    if a:direction =~# '^[hjkl]$'
        let leaving_dead_window = InUnusedWindow()

        let old_window = winnr()
        exec "normal! \<C-w>" . a:direction
        let new_window = winnr()

        if(old_window == new_window)
            call AutoSplit(a:direction)
        elseif leaving_dead_window 
            execute old_window . 'wincmd q'
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

function! InUnusedWindow()
    let no_type = &buftype == '' 
    let no_name = bufname('%') == '' 
    let single_line = line('$') == 1 
    let empty_first_line = getline(1) == ''

    if (no_type && no_name && single_line && empty_first_line)
        return 1
    else
        return 0
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
filetype plugin indent on


" explore
command! E Explore

command! M make


" why is Async make not launching cargo as it should? need to check the rust.vim
" extention code. i suspect it checks for .rs in the file name, only applying
" rust settings if in a rust file (:make doesn't work in :Explore mode or in
" none-source files). Whatever Async does causes % to temporarily not be *.rs,
" because the async process likly has no file name. 

" colors
syntax enable
color gruvbox
set background=dark

" font size
set guifont=Menlo:h15


function! RetagCurrentRepo()
  let g:git_root = trim(system('git rev-parse --show-toplevel'))
  let g:changed_files = split(system('git diff --name-only HEAD'), "\n")
  echo g:changed_files
endfunction







