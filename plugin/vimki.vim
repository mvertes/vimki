" vimki.vim

if exists('g:vimki_loaded')
  finish
endif
let g:vimki_loaded = 1

let s:cpo_save = &cpo
set cpo&vim

let s:revision = "0.1"

" Configuration
function! s:default(varname,value)
  if !exists('g:vimki_'.a:varname)
    let g:vimki_{a:varname} = a:value
  endif
endfunction

call s:default('suffix','')
call s:default('home',"~/Wiki/HomePage".g:vimki_suffix)
call s:default('home_dir',fnamemodify(g:vimki_home,':p:h'))

call s:default('upper','A-Z')
call s:default('lower','a-z')
call s:default('other','0-9_')

call s:default('autowrite',0)

call s:default('slash',has('unix') ? '/' : '\')

call s:default('ignore','')
call s:default('opendirs',0)

" Functions
function! s:VimkiInit()
  let upp = g:vimki_upper
  let low = g:vimki_lower
  let oth = g:vimki_other
  let nup = low.oth
  let nlo = upp.oth
  let any = upp.nup

  "A VimkiWord must start with an upper case character and contain at
  "least one lower case and another upper case character in that order.
  let inner = '['.upp.']['.nlo.']*['.low.']['.nup.']*['.upp.']['.any.']*'
  call s:VimkiBuildIgnore()
  if s:ignorerx != ""
    let s:wordrx = '\C\<\(\('.s:ignorerx.'\)\>\)\@!'.inner.'\>'
  else
    let s:wordrx = '\C\<'.inner.'\>'
  endif

  call s:VimkiMap()
  call s:VimkiMenu()
  call s:VimkiAutoCommands()

  au Filetype vimki call <SID>VimkiBufferInit()
  au Syntax vimki call <SID>VimkiDefineSyntax()
endfunction

function! s:VimkiBufferInit()
  call s:VimkiBufferMap()
endfunction

function! s:VimkiDir()
  if &filetype == 'vimki'
    return expand('%:p:h')
  endif
  return g:vimki_home_dir
endfunction

function! s:VimkiDefineSyntax()
  syntax clear
  syntax case match
  execute 'syntax match VimkiWordNotFound "'.s:wordrx.'"'

  call s:VimkiDefineWords()

  " Define the default highlighting.
  hi def link VimkiWordNotFound Tag
  hi def link VimkiWord         Identifier

  let b:current_syntax = "vimki"
endfunction

" external interface
function! VimkiSyntax()
  call s:VimkiDefineSyntax()
endfunction

function! s:VimkiBuildIgnore()
  let s:ignorerx = ""
  let words=g:vimki_ignore
  while words != ""
    let pos = stridx(words, ",")
    if pos < 0
      let pos = strlen(words)
    endif
    let word = strpart(words, 0, pos)
    let words = strpart(words, pos+1)
    if s:ignorerx != ""
      let s:ignorerx = s:ignorerx.'\|'
    endif
    let s:ignorerx = s:ignorerx.word
  endwhile
endfunction

function! s:VimkiDefineWords()
  let files=globpath(s:VimkiDir(), "*")
  while files != ""
    let pos = stridx(files, "\n")
    if pos < 0
      let pos = strlen(files)
    endif
    let file = strpart(files, 0, pos)
    let files = strpart(files, pos+1)
    let suffix_len = strlen(g:vimki_suffix)
    let file_len = strlen(file)
    if strpart(file, file_len-suffix_len, suffix_len) == g:vimki_suffix
      let word=strpart(file, 0, file_len-suffix_len)
    else
      let word=""
    endif
    let word = matchstr(word,s:wordrx.'\%$')
    if word != "" 
      if filereadable(file) || (g:vimki_opendirs && isdirectory(file))
        execute "syntax match VimkiWord ".'"\<'.word.'\>"'
      endif
    endif
  endwhile
endfunction

function! s:VimkiEdit(file)
  if isdirectory(a:file) && !g:vimki_opendirs
    echo a:file." is a directory"
    return
  endif
  execute "e ".a:file
  if &filetype != 'vimki'
    setlocal filetype=vimki
  endif
endfunction

function! s:VimkiAutowrite()
  if &filetype == 'vimki' && g:vimki_autowrite
    execute "update"
  endif
endfunction

" Autocommands
function! s:VimkiAutoCommands()
  let dir = g:vimki_home_dir
  if !has('unix')
    let dir = substitute(dir, '\', '/', 'g')
  endif
  " 'setf vimki' is too weak -- we may have to override a wrong filetype:
  execute 'au BufNewFile,BufReadPost '.dir.'/*'.g:vimki_suffix.' setlocal filetype=vimki'
endfunction

" Maps
function! s:VimkiMap()
  noremap <unique> <script> <SID>Home    :call <SID>Home()<CR>
  noremap <unique> <script> <SID>Index   :call <SID>Index()<CR>
  noremap <unique> <script> <SID>CR      :call <SID>CR()<CR>
  noremap <unique> <script> <SID>Follow  :call <SID>Follow()<CR>
  noremap <unique> <script> <SID>Close   :call <SID>Close()<CR>
  noremap <unique> <script> <SID>Reload  :call <SID>Reload()<CR>
  noremap <unique> <script> <SID>NextWord :call <SID>NextWord()<CR>
  noremap <unique> <script> <SID>PrevWord :call <SID>PrevWord()<CR>
  execute "noremap <unique> <script> <SID>Edit ".
        \ ":call <SID>VimkiAutowrite()<CR>".
        \ ":e ".g:vimki_home_dir.g:vimki_slash

  map <unique> <script> <Plug>VimkiHome   <SID>Home
  map <unique> <script> <Plug>VimkiIndex  <SID>Index
  map <unique> <script> <Plug>VimkiCR     <SID>CR
  map <unique> <script> <Plug>VimkiFollow <SID>Follow
  map <unique> <script> <Plug>VimkiClose  <SID>Close
  map <unique> <script> <Plug>VimkiReload <SID>Reload
  map <unique> <script> <Plug>VimkiEdit   <SID>Edit
  map <unique> <script> <Plug>VimkiNext   <SID>NextWord
  map <unique> <script> <Plug>VimkiPrev   <SID>PrevWord

  if !hasmapto('<Plug>VimkiHome')
    map <unique> <Leader>ww <Plug>VimkiHome
  endif
  if !hasmapto('<Plug>VimkiIndex')
    map <unique> <Leader>wi <Plug>VimkiIndex
  endif
  if !hasmapto('<Plug>VimkiFollow')
    map <unique> <Leader>wf <Plug>VimkiFollow
  endif
  if !hasmapto('<Plug>VimkiEdit')
    map <unique> <Leader>we <Plug>VimkiEdit
  endif
endfunction

function! s:VimkiBufferMap()
  if exists('b:did_vimki_buffer_map')
    return
  endif
  let b:did_vimki_buffer_map = 1
  
  map <buffer> <silent> <Tab>            <Plug>VimkiNext
  map <buffer> <silent> <BS>             <Plug>VimkiPrev
  map <buffer>          <CR>             <Plug>VimkiCR
  map <buffer> <silent> <Leader><Leader> <Plug>VimkiClose
  map <buffer> <silent> <Leader>wr       <Plug>VimkiReload
endfunction

" Menu items
function! s:VimkiMenu()
  noremenu <script> Plugin.Wiki\ Home    <SID>Home
  noremenu <script> Plugin.Wiki\ Index   <SID>Index
endfunction

" Functions suitable for global mapping
function! s:Home()
  call s:VimkiAutowrite()
  call s:VimkiEdit(g:vimki_home)
endfunction

function! s:Index()
  call s:VimkiAutowrite()
  execute "e ".g:vimki_home_dir
endfunction

function! s:Follow()
  let word = expand('<cword>')
  if word =~ s:wordrx
    let file = s:VimkiDir().g:vimki_slash.word.g:vimki_suffix
    call s:VimkiAutowrite()
    call s:VimkiEdit(file)
  else
    echoh WarningMsg
    echo "Cursor must be on a WikiWord to follow!"
    echoh None
  endif
endfunction

" Functions suitable for buffer mapping
function! s:CR()
  let word = expand('<cword>')
  if word =~ s:wordrx
    let file = s:VimkiDir().g:vimki_slash.word.g:vimki_suffix
    call s:VimkiAutowrite()
    call s:VimkiEdit(file)
  else
    execute "normal! \n"
  endif
endfunction

function! s:Close()
  call s:VimkiAutowrite()
  execute "bd"
endfunction

function! s:Reload()
  syntax clear
  au Syntax vimki call <SID>VimkiDefineSyntax()
  do Syntax vimki
endfunction

function! s:SearchWord(cmd)
  let hl = &hls
  let lasts = @/
  let @/ = s:wordrx
  set nohls
  try
    :silent exe 'normal! ' a:cmd
  catch /Pattern not found/
    echoh WarningMsg
    echo "No WikiWord found."
    echoh None
  endt
  let @/ = lasts
  let &hls = hl
endfunction

function! s:NextWord()
  call s:SearchWord('n')
endfunction

function! s:PrevWord()
  call s:SearchWord('N')
endfunction

" main
call s:VimkiInit() 

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
