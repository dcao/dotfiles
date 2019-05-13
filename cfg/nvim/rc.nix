''
set background=dark
set encoding=utf-8
set tabstop=4       
set shiftwidth=4    
set expandtab       
set smarttab        
set showcmd         
set number          
set showmatch       
set incsearch       
set ignorecase      
set smartcase       
set backspace=2     
set autoindent      
set textwidth=79    
set formatoptions=c,q,r
set ruler
set background=dark
set mouse=a
set noshowmode
set history=200
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

let mapleader = "<SPC>"
let maplocalleader = ","
''
