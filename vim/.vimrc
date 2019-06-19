" Vim Configuration file
" Interesting ressources :
" http://vimawesome.com
" https://davidosomething.com/blog/vim-for-javascript
" https://github.com/jackfranklin/dotfiles
" Vim Cheat Sheet : https://vim.rtorr.com

syntax on
colorscheme monokai
set t_Co=256
set background=dark
set nocompatible              " be iMproved, required
filetype off                  " required
set guifont=Menlo:h14



"
" standard 
" filetype plugin indent on    " required 
" To ignore plugin indent changes, instead use:
" filetype plugin on"

"
"
" The plugins instlaled below require https://github.com/VundleVim/Vundle.vim
"
"

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Taxi.vim - Liip timetracker
Plugin 'schtibe/taxi.vim'



" plugin on GitHub repo
" Git plugin not hosted on GitHub
Plugin 'tpope/vim-fugitive'

"Command-T Plugin (need compilation)
Plugin 'git://git.wincent.com/command-t.git'

" The Nerd Tree
Plugin 'scrooloose/nerdtree'

" JavaScript 
"
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'maxmellon/vim-jsx-pretty'

" Auto complete
"
Plugin 'vim-scripts/SyntaxComplete'

" CTRL P - full path fuzzy file, buffer, mru, tag finder
Plugin 'kien/ctrlp.vim'

" Indent Line
" Plugin 'yggdroot/indentline'

"Plugin 'jelera/vim-javascript-syntax'
"Plugin 'othree/yajs.vim'
"Plugin 'othree/javascript-libraries-syntax.vim'
"Plugin 'nathanaelkane/vim-indent-guides'

" Easymotion to jump around
" Buggy with Nerd Tree ?
"Plugin 'easymotion/vim-easymotion'

" Vim git gutter
"Plugin 'airblade/vim-gitgutter'

" ES6 Snippets and syntax highlighting
"Plugin 'garbas/vim-snipmate' " requirement
"Plugin 'SirVer/ultisnips'
"Plugin 'MarcWeber/vim-addon-mw-utils'
"Plugin 'tomtom/tlib_vim'
Plugin 'isruslan/vim-es6'

" JSON support
Plugin 'leshill/vim-json'

" Async Lint Engine
Plugin 'w0rp/ale'

" EditorConfig 
Plugin 'editorconfig/editorconfig-vim'

" Jumping between CommonJS modules
Plugin 'moll/vim-node'

" Add other pair automatically
Plugin 'jiangmiao/auto-pairs'

" Ggutentags - automatic tag generation
Plugin 'ludovicchabant/vim-gutentags'

" Suround
Plugin 'tpope/vim-surround' 

" Status bar
Plugin 'bling/vim-airline'

" Enhance %
Plugin 'matchit.zip'

" Amazing code completion
"Plugin 'Valloric/YouCompleteMe' " Needs Vim 7.4+
"Plugin 'marijnh/tern_for_vim'


" All of your Plugins must be added before the following line
call vundle#end()            " required

" Configure pangloss/vim-javascript 
let g:javascript_plugin_jsdoc = 1 " Enables syntax highlighting for JSDocs.
let g:javascript_plugin_flow = 1

"set foldmethod=syntax

" Configure mxw/vim-jsx plugin
let g:jsx_ext_required = 0 " Allow JSX in normal JS files
let g:vim_jsx_pretty_enable_jsx_highlight = 1 " default
let g:vim_jsx_pretty_colorful_config = 1 " default 0, vim-javascript only
set number

" Configure Indent Line
"let g:indentLine_char = 'c'
let g:indentLine_enabled = 1

" Shortcuts 
map <C-p> :CommandT<enter>
map <C-t> :tabnew<enter> 
let mapleader=','

" Open VIMRC
map <Leader>v :e ~/.vimrc<enter>

map <Leader>q :NERDTreeToggle<CR>

" Auto open Nerd Tree
"autocmd vimenter * NERDTree

" Snipet and ES6 highlight config
" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Async Lint Engine config
let &runtimepath.=',~/.vim/bundle/ale'
filetype plugin on

" Easy Motion (jump around)
"let g:EasyMotion_do_mapping = 1 " Disable default mappings
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
"nmap f <Plug>(easymotion-overwin-f)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
"map <Leader>j <Plug>(easymotion-j)
"map <Leader>k <Plug>(easymotion-k)
