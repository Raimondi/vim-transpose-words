""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim global plugin for short description
" Maintainer:	Israel Chauca F. <israelchauca@gmail.com>
" Version:	0.1
" Description:	Long description.
" Last Change:	2012-04-29
" License:	Vim License (see :help license)
" Location:	plugin/transpose_words.vim
" Website:	https://github.com/vim-transpose_words
"
" See transpose_words.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help transpose_words
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:transpose_words_version = '0.1'

" Vimscript Setup: {{{1
" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

" load guard
" uncomment after plugin development
"if exists("g:loaded_transpose_words")
"      \ || v:version < 700
"      \ || &compatible
"  let &cpo = s:save_cpo
"  finish
"endif
"let g:loaded_transpose_words = 1

" Public Interface: {{{1
function! TransposeWords(...) range
  let cnt = a:0 ? a:1 : v:count1
  " Get cursor position on [line, column] format.
  let current = getpos('.')[1:-2]
  " Find the words to be swapped.
  let pos1 = searchpos('\k\+', 'cWb')
  if !pos1[0]
    let pos1 = searchpos('\k\+', 'cW')
  endif
  let pos2 = map(range(cnt),
        \ 'searchpos(''\k\+\%(\k\@!\_.\)\{-1,}\zs\k'', ''W'')')[-1]
  if !pos1[0] || !pos2[0]
    " At least one word wasn't found.
    return cursor(current)
  endif
  " Restore cursor position.
  call cursor(current)
  let line1 = getline(pos1[0])
  let line2 = pos1[0] == pos2[0] ? line1 : getline(pos2[0])
  let word1 = matchstr(line1[pos1[1] - 1 :], '^\k\+')
  let word2 = matchstr(line2[pos2[1] - 1 :], '^\k\+')
  if pos1[0] == pos2[0] && (pos1[1] + len(word1) >= pos2[1])
    " Didn't find two separate words.
    return cursor(current)
  endif
  let partial1 = line1[ : pos1[1] == 1 ? - (len(line1) + 1) : pos1[1] - 2]
  if pos1[0] < pos2[0]
    " Words are on different lines.
    let partial2 = line1[pos1[1] + len(word1) - 1 : ]
    let partial3 = line2[ : pos2[1] == 1 ? - (len(line2) + 1) : pos2[1] - 2]
    let partial4 = line2[pos2[1] + len(word2) - 1 : ]
    let final_line1 = partial1 . word2 . partial2
    let final_line2 = partial3 . word1 . partial4
  else
    " Words are on the same line.
    let partial2 = line1[ pos1[1] + len(word1) - 1 : pos2[1] - 2]
    let partial3 = line1[ pos2[1] + len(word2) - 1 : ]
    let final_line1 = partial1 . word2 . partial2 . word1 . partial3
  endif
  if setline(pos1[0], final_line1)
        \ || (exists('final_line2')
        \     && setline(pos2[0], final_line2))
    " There was a problem setting the line.
    return cursor(current)
  endif
  " Make repeating with . possible.
  " Do not re-attempt to use repeat#set() if not available.
  if !exists('s:repeat') || s:repeat
    silent! call repeat#set("\<Plug>TransposeWords", cnt)
    let s:repeat = exists('*repeat#set')
  endif
  " Place the cursor in front of the word.
  return !cursor(pos2[0], pos2[1] + len(pos1[0] == pos2[0] ? word2 : word1))
endfunction

" Maps: {{{1
nnoremap <Plug>TransposeWords :<C-U>call TransposeWords()<CR>

if !hasmapto('<Plug>TransposeWords')
  nmap <unique><silent> <leader>tw <Plug>TransposeWords
endif

" Commands: {{{1
command! -bar -count=1 TransposeWords call TransposeWords(<Count>)

" Teardown: {{{1
"reset &cpo back to users setting
let &cpo = s:save_cpo

" vim: set sw=2 sts=2 et fdm=marker:
