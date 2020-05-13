set encoding=utf-8
scriptencoding utf-8

" we are loading from a different path.
" for some odd reason pathogen refuses to follow symbolic links
set runtimepath+=/home/khenidak/imaginarium/box/.vim/

execute pathogen#infect('bundles/{}')

" kubernetes large files (looking at you validation) uses alot of mempatterns, default is 1k
set mmp=5000

syntax on
filetype plugin indent on

" no vi compat
set nocompatible

" stop annoying preview-window
set completeopt-=preview


" show line # 
set nu

" User undeline
set cursorline

" set color /.vim/colors
" colorscheme vividchalk
colorscheme Chasing_Logic

" colorscheme borland
"highlight search
set hlsearch
hi Search ctermbg=Yellow
hi Search ctermfg=Red

"enter to exit highlight mode
nnoremap <CR> :noh<CR><CR>



" spell check *md files
autocmd FileType markdown setlocal spell
 
" +++non plugin short-cuts 

" save using f2 in insert mode 
inoremap <F3> <c-o>:w<cr>
" map F8 for Tag bar 
nmap <F8> :TagbarToggle<CR>

" ctrlP 
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

let g:ctrlp_working_path_mode = 'ra' " working directory nearest ancestor with .git 

"ignore list for ctrlP
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

let g:ctrlp_working_path_mode = 'ra'

" *************** golang *****
" Golang stuff (go-vim) 
" use goimports for formatting
"let g:go_fmt_command = "goimports"
let g:go_fmt_command ="gofmt"

" turn highlighting on
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_auto_type_info =0 

" fail silent on fmt errors 
"let g:go_fmt_fail_silently = 1


" Open go doc in vertical window, horizontal, or tab
au Filetype go nnoremap <leader>v :vsp <CR>:exe "GoDef" <CR>

au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>i <Plug>(go-info)
au FileType go nmap <leader>s <plug>(go-implements)
au FileType go nmap <leader>l <plug>(go-lint)
au FileType go nmap <leader>e <Plug>(go-rename)
au FileType go nmap <leader>dt <Plug>(go-def-tab)
au FileType go nmap <leader>ds <Plug>(go-def-split)


" Syntastic 

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*



" lightline fix
set laststatus=2



" NERDTree shortcut
map <C-n> :NERDTreeToggle<CR>
" Auto-Start Nerd tree 
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
" open files in new tabs
"let NERDTreeMapOpenInTab='<ENTER>'
"let NERDTreeQuitOnOpen=1 "Close the tree when opening the file  
nmap <leader>x :NERDTreeFind<CR>


let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'lineinfo', 'percent' ], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'filename': 'LightlineFilename',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding',
      \   'mode': 'LightlineMode',
      \   'ctrlpmark': 'CtrlPMark',
      \   'gitbranch' : 'FugitiveHead',
      \ },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

function! LightlineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightlineFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let branch = fugitive#head()
      return branch !=# '' ? mark.branch : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP' && has_key(g:lightline, 'ctrlp_item')
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0


" tag bar + golang
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : '/home/khenidak/code/bin/gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }


" Flag unnecessary white spaces
highlight BadWhitespace ctermbg=red guibg=red

au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
au BufRead,BufNewFile *.go,*.sh,*.c,*.h set tabstop=2


" ******************** PYTHON *******************
au BufNewFile,BufRead *.py set tabstop=4
au BufNewFile,BufRead *.py set softtabstop=4
au BufNewFile,BufRead *.py set shiftwidth=4
au BufNewFile,BufRead *.py set textwidth=120
au BufNewFile,BufRead *.py set expandtab
au BufNewFile,BufRead *.py set autoindent
au BufNewFile,BufRead *.py set smarttab
au BufNewFile,BufRead *.py set fileformat=unix
" open all folds
autocmd Syntax *.py normal zR
let g:pymode_python = 'python3'
let g:pymode_virtualenv = 1 
let python_highlight_all=1

"let g:pymode_lint_ignore="E501,W601"
"" Begin Functions

" format jason via `jj`
nmap jj :%!python -m json.tool<CR>
" select all via `aa`
nmap aa ggVG




" ******************* Type Script ***********
autocmd BufRead,BufNewFile *.ts setlocal filetype=typescript tabstop=4 shiftwidth=4 expandtab
au BufRead,BufNewFile *.ts  match BadWhitespace /\s\+$/

" ******************** rust *************
let g:ycm_rust_src_path = '~/go/src/github.com/rust-lang/rust/src'
let g:rustfmt_autosave = 1 
" note some settings exist in rust-vim plugin

" ******************* C# ***********
" omnisharp rosyln server for auto complete *sigh*
 au BufRead,BufNewFile *.cs set tabstop=4
let g:OmniSharp_server_path = '/home/khenidak/bin/omnisharp/run'

" for vim 8+ use stdio to talk to omnisharp server because it i async
let g:OmniSharp_server_stdio = 1
" fmt like 
autocmd BufWritePre *.cs :OmniSharpCodeFormat

" *ALL*
nnoremap <Leader>] :YcmCompleter GoTo<CR>
nnoremap <Leader>$ :%!astyle<CR>
