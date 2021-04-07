set nocompatible
let g:vimsyn_embed = 'l'

set noequalalways
set hidden
set splitbelow
set nowrap
set exrc
set guicursor=
set nohlsearch

filetype plugin on

set path+=**

let mapleader = " "
set wildmenu

set tabstop=4
set virtualedit=onemore
set shiftwidth=4
set smarttab
set expandtab
set mouse=a
set autoindent

"set cindent
set smartindent

"fix issue with # symbol not using smartindent
inoremap # X<c-h>#

"dont ever want to enter Ex mode
nnoremap Q <nop>

"too many typos....
command W w
command Wq wq

set laststatus=2
set showmode

" relative line numbers
set relativenumber
set rnu

syntax enable
set noerrorbells

" map esc to jj, stop vim from moving cursor to the left
" after leaving insert mode
inoremap jj <Esc>l

"swap the curly brackets so they mimic j and k
nnoremap { }
nnoremap } {
vnoremap { }
vnoremap } {

"swap the double brackets to jump between functions to mimic j and k
"this doesnt work for some reason
nnoremap [[ ]]
nnoremap ]] [[

" indent the last pasted block
nnoremap <leader>> '[V']>
nnoremap <leader>< '[V']<

"easy switching between files
nnoremap ! <c-^>

" search settings
set smartcase
set incsearch

" easier char finding with f
nnoremap <right> ;
nnoremap <left> ,
nnoremap < ,
nnoremap > ;

" enter/leave paste mode w/ <F8>
set pastetoggle=<F8>

" allow for undos after closing file
set undodir=~/.vimdid
set undofile

" disable arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

"move to the beginning of a line with ` instead of ^
nnoremap ` ^
"move to end of line with = instead of $
nnoremap = $

"set yank to work like c and d
nnoremap Y y$

"easy access to system register
nnoremap sr "+
vnoremap sr "+

"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

"navigation around windows
nnoremap <silent> <leader>h :wincmd h<CR>
nnoremap <silent> <leader>j :wincmd j<CR>
nnoremap <silent> <leader>k :wincmd k<CR>
nnoremap <silent> <leader>l :wincmd l<CR>
nnoremap <silent> <leader>q :wincmd q<CR>

"navigation around buffers
nnoremap <leader>n :bn<CR>
nnoremap <leader>p :bp<CR>
nnoremap <leader>b :b

"set shortcut for opening terminal
nnoremap <silent> <leader>tr :bo terminal ++close<CR>

"exit from terminal mode to normal mode
tnoremap <C-d><C-d> <C-w><C-c>

"switch to terminal normal mode
tnoremap QQ <C-\><C-n>

"changes size of windows
nnoremap <silent> <leader>+ :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>
nnoremap <silent> <leader>) :resize +5<CR>
nnoremap <silent> <leader>( :resize -5<CR>

"visual
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=blue

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""PLUGINS""""""""""""""""""""""""""
call plug#begin('/home/mmr/.local/share/nvim/site/autoload')
"color scheme
Plug 'gruvbox-community/gruvbox'

"python linting
Plug 'nvie/vim-flake8'

"surround - change quote types etc
Plug 'tpope/vim-surround'

"targets -- ci( works like ci", can change beginning of line
Plug 'wellle/targets.vim'

"fast grep
Plug 'jremmen/vim-ripgrep'

"man pages
Plug 'vim-utils/vim-man'

"tags viewer
Plug 'preservim/tagbar'

"nice file finding
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

"lsp config
Plug 'neovim/nvim-lspconfig'

"autocomplete
Plug 'nvim-lua/completion-nvim'

"undo tree
Plug 'mbbill/undotree'

"git integeration
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'

"NERDTree
Plug 'preservim/nerdtree'

"NERDcommenter
Plug 'preservim/nerdcommenter'

call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""END PLUGINS"""""""""""""""""""""""""""

set background=dark
colorscheme gruvbox

nnoremap <C-p> :Telescope find_files<cr>
nnoremap <C-b> :Telescope buffers<cr>
nnoremap <leader>rg :Telescope live_grep<cr>

"opens undo tree
nnoremap <leader>u :UndotreeShow<CR>

"opens file tree
nnoremap <leader>tt :NERDTreeToggle<CR>

"git integration
nnoremap <silent> <leader>gs :G<CR>

lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
local servers = { "pyright", "clangd"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
EOF

lua << EOF
require('lsp_diags').diags_off()
EOF

" lsp config
lua << EOF
require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.clangd.setup{on_attach=require'completion'.on_attach}
vim.lsp.set_log_level("debug")
EOF

" autocomplete settings
au Filetype lua setl omnifunc=v:lua.vim.lsp.omnifunc
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy = ['exact', 'substring', 'fuzzy']

command! LspDiagsOn lua require('lsp_diags').diags_on()
nnoremap <leader>do :LspDiagsOn<CR>

command! LspDiagsOff lua require('lsp_diags').diags_off()
nnoremap <leader>df :LspDiagsOff<CR>

"set tags bar
nnoremap <leader>tb :TagbarToggle<CR>

"goto def in new window
nnoremap <silent>gW :wincmd s<CR> :lua vim.lsp.buf.definition()<CR>

"vim-airline config
set list          " Display unprintable characters f12 - switches
set listchars=tab:•\ ,trail:•,extends:»,precedes:« " Unprintable chars mapping
set invlist
"don't distingusih between insert and insert complete
let g:airline_mode_map = {}
let g:airline_mode_map['ic'] = 'INSERT'

"nerdcommenter config
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1
