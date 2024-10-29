set secure " do not allow unsafe commands in vim config files
set exrc " local vim config files have precidence


set makeprg=cargo\ run

" temp dotnet settings
" set makeprg=dotnet
set errorformat+=%f(%l\\,%c):\ error\ CS%n:\ %m\ [%o]
set errorformat+=%f(%l\\,%c):\ error\ MC%n:\ %m\ [%o]
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
color gruvbox
set background=dark

" font size
set guifont=Menlo:h13

set fullscreen


