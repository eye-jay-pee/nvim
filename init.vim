set secure " do not allow unsafe commands in vim config files
set exrc " local vim config files have precidence

" temp dotnet settings
set makeprg=dotnet
set errorformat=%f(%l\\,%c):\ error\ CS%n:\ %m\ [%o]
" end of temp dotnet settings

" colors and themes
set termguicolors
color gruvbox

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

" ctrl-[hjkl] to navigate split panes
nmap <silent <C-h> :wincmd h<CR>
nmap <silent <C-j> :wincmd j<CR>
nmap <silent <C-k> :wincmd k<CR>
nmap <silent <C-l> :wincmd l<CR>

command! E Explore
