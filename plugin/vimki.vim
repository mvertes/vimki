" vimki.vim

if exists('g:vimki_loaded')
  finish
endif
let g:vimki_loaded = 1

let s:cpo_save = &cpo
set cpo&vim

let s:revision = '0.2'

" Configuration
function! s:default(varname,value)
  if !exists('g:vimki_' . a:varname)
    let g:vimki_{a:varname} = a:value
  endif
endfunction

call s:default('suffix', '.md')
call s:default('home', '~/Wiki/home_page' . g:vimki_suffix)
call s:default('home_dir', fnamemodify(g:vimki_home, ':p:h'))
call s:default('autowrite', 1)
call s:default('open', '!open')

" Functions
function! s:VimkiInit()
  " A link is containing no space character and at least one / character
  let s:urlrx = '\S*\/\S*'
  " A VimkiLink is between square brackets
  let s:linkrx = '\[[^\]]*\]'

  call s:VimkiMap()
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

function! s:Link2File(link)
  let fname = tolower(a:link)
  let fname = tr(fname, 'åäáàâãçéèêëîíìïôöóõòùûüúÿñ', 'aaaaaaceeeeiiiiooooouuuuyn')
  let fname = substitute(fname, '\W\+', '_', 'g')
  return fname
endfunction

function! s:VimkiDefineSyntax()
  syntax clear
  syntax case match
  execute 'syntax match VimkiLinkNotFound "' . s:linkrx . '"'
  execute 'syntax match VimkiUrl "' . s:urlrx . '"'
  execute 'syntax match VimkiHeader /^\#\+.*$/'

  call s:VimkiDefineLinks()

  " Define the default highlighting.
  hi def link VimkiLinkNotFound Tag
  hi def link VimkiLink         Identifier
  hi def link VimkiUrl          Type
  hi VimkiHeader cterm=underline ctermfg=blue

  let b:current_syntax = 'vimki'
endfunction

" External interface
function! VimkiSyntax()
  call s:VimkiDefineSyntax()
endfunction

function! s:Rename(...) abort
  let link = s:GetLink()
  let ask = printf("vimki: rename '%s' to: ", link)
  let to = input(ask)
  redraw!
  if empty(to)
    return
  endif
  execute '!vimki rename "' . link . '" "' . to . '"'
endfunction

function! s:VimkiDefineLinks()
  let files = globpath(s:VimkiDir(), '*')
  while files != ''
    let pos = stridx(files, "\n")
    if pos < 0
      let pos = strlen(files)
    endif
    let file = strpart(files, 0, pos)
    let files = strpart(files, pos + 1)
    let link = fnamemodify(file, ':t:r')
    if link != ''
      if filereadable(file)
        execute "syntax match VimkiLink " . '"\c\[' . s:LinkMatch(link)  . '\]"'
      endif
    endif
  endwhile
endfunction

function! s:LinkMatch(link)
  let m = substitute(a:link, '_', '\\W\\+', 'g')
  let m = substitute(m, 'a', '[aåäáàâã]', 'g')
  let m = substitute(m, 'c', '[cç]', 'g')
  let m = substitute(m, 'e', '[eéèêë]', 'g')
  let m = substitute(m, 'i', '[iîíìï]', 'g')
  let m = substitute(m, 'o', '[oôöóõò]', 'g')
  let m = substitute(m, 'u', '[uùûüú]', 'g')
  let m = substitute(m, 'y', '[yÿ]', 'g')
  let m = substitute(m, 'n', '[nñ]', 'g')
  return m
endfunction

function! s:VimkiEdit(file)
  if isdirectory(a:file)
    echo a:file . ' is a directory'
    return
  endif
  execute 'e ' . a:file
  if &filetype != 'vimki'
    setlocal filetype = vimki
  endif
endfunction

function! s:VimkiAutowrite()
  if &filetype == 'vimki' && g:vimki_autowrite
    if !isdirectory(g:vimki_home_dir)
      call mkdir(g:vimki_home_dir, 'p')
    endif
    execute 'update'
  endif
endfunction

" Autocommands
function! s:VimkiAutoCommands()
  execute 'au BufNewFile,BufReadPost ' . g:vimki_home_dir . '/*' . g:vimki_suffix . ' setlocal filetype=vimki'
endfunction

" Maps
function! s:VimkiMap()
  noremap <unique> <script> <SID>Home    :call <SID>Home()<CR>
  noremap <unique> <script> <SID>Index   :call <SID>Index()<CR>
  noremap <unique> <script> <SID>CR      :call <SID>CR()<CR>
  noremap <unique> <script> <SID>Follow  :call <SID>Follow()<CR>
  noremap <unique> <script> <SID>Close   :call <SID>Close()<CR>
  noremap <unique> <script> <SID>Reload  :call <SID>Reload()<CR>
  noremap <unique> <script> <SID>Rename  :call <SID>Rename()<CR>
  noremap <unique> <script> <SID>NextLink :call <SID>NextLink()<CR>
  noremap <unique> <script> <SID>PrevLink :call <SID>PrevLink()<CR>
  execute 'noremap <unique> <script> <SID>Edit ' .
        \ ':call <SID>VimkiAutowrite()<CR>' .
        \ ':e ' . g:vimki_home_dir . '/'

  map <unique> <script> <Plug>VimkiHome   <SID>Home
  map <unique> <script> <Plug>VimkiIndex  <SID>Index
  map <unique> <script> <Plug>VimkiCR     <SID>CR
  map <unique> <script> <Plug>VimkiFollow <SID>Follow
  map <unique> <script> <Plug>VimkiClose  <SID>Close
  map <unique> <script> <Plug>VimkiReload <SID>Reload
  map <unique> <script> <Plug>VimkiRename <SID>Rename
  map <unique> <script> <Plug>VimkiEdit   <SID>Edit
  map <unique> <script> <Plug>VimkiNext   <SID>NextLink
  map <unique> <script> <Plug>VimkiPrev   <SID>PrevLink

  if !hasmapto('<Plug>VimkiHome')
    map <unique> <Leader>ww <Plug>VimkiHome
  endif
  if !hasmapto('<Plug>VimkiIndex')
    map <unique> <Leader>wi <Plug>VimkiIndex
  endif
  if !hasmapto('<Plug>VimkiFollow')
    map <unique> <Leader>wf <Plug>VimkiFollow
  endif
endfunction

function! s:VimkiBufferMap()
  if exists('b:did_vimki_buffer_map')
    return
  endif
  let b:did_vimki_buffer_map = 1

  map <buffer> <silent> <Tab>            <Plug>VimkiNext
  map <buffer> <silent> <S-Tab>          <Plug>VimkiPrev
  map <buffer>          <CR>             <Plug>VimkiCR
  map <buffer> <silent> <Leader><Leader> <Plug>VimkiClose
  map <buffer> <silent> <Leader>wl       <Plug>VimkiReload
  map <buffer> <silent> <Leader>wr       <Plug>VimkiRename
endfunction

" Functions suitable for global mapping
function! s:Home()
  call s:VimkiAutowrite()
  call s:VimkiEdit(g:vimki_home)
endfunction

function! s:Index()
  call s:VimkiAutowrite()
  execute 'e ' . g:vimki_home_dir
endfunction

function! s:Follow()
  let link = s:GetLink()
  let file = s:VimkiDir() . '/' . s:Link2File(link) . g:vimki_suffix
  call s:VimkiAutowrite()
  call s:VimkiEdit(file)
endfunction

function! s:GetLink()
  let line = getline('.')
  if line =~ s:linkrx
    let ch = line[col('.') - 1]
    if ch == ']'
      execute "normal! k"
    endif
    execute "normal! /]yT["
    return @"
  endif
  return ''
endfunction

" Functions suitable for buffer mapping
function! s:CR()
  let link = s:GetLink()
  if empty(link)
     execute "normal! \n"
     return
  endif
  let file = s:VimkiDir() . '/' . s:Link2File(link) . g:vimki_suffix
  call s:VimkiAutowrite()
  call s:VimkiEdit(file)
endfunction

function! s:Close()
  call s:VimkiAutowrite()
  " execute 'bd'
  let cnt = 0
  for i in range(0, bufnr("$"))
    if buflisted(i)
      let cnt += 1
    endif
  endfor
  if cnt <= 1
    execute 'q'
  else
    execute 'bd'
  endif
endfunction

function! s:Reload()
  syntax clear
  au Syntax vimki call <SID>VimkiDefineSyntax()
  do Syntax vimki
endfunction

function! s:SearchLink(cmd)
  let hl = &hls
  let lasts = @/
  let @/ = s:linkrx
  set nohls
  try
    :silent exe 'normal! ' a:cmd
  catch /Pattern not found/
    echoh WarningMsg
    echo 'No WikiLink found.'
    echoh None
  endt
  let @/ = lasts
  let &hls = hl
endfunction

function! s:NextLink()
  call s:SearchLink('n')
endfunction

function! s:PrevLink()
  call s:SearchLink('N')
endfunction

" Main
call s:VimkiInit()

command! VRemame call <SID>Rename()

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
