function! TransposeWords(...) range
  " if no arg was provided use the count.
  let cnt = a:0 ? a:1 : v:count1
  let cur = getpos('.')
  let pos = searchpos('\%#.', 'wcn')
  if matchstr(getline(line('.'))[(col('.') - 1) :], '^.') =~ '\w'
        \ && col('.') != col('$')
    let pat = '\(\w*\%#\w\+\)\(\_W\+'
          \ . repeat('\w\+\_W\+', cnt - 1)
          \ . '\)\(\w\+\)'
  else
    let pat = '\(\w\+\)\(\_W*\%#\_W\+'
          \ . repeat('\w\+\_W\+', cnt - 1)
          \ . '\)\(\w\+\)'
  endif
  let cur = searchpos(pat, 'wcne')
  exec 's/' . pat . '/\3\2\1/e'
  echom 'cnt '.cnt
  echom string(cur)
  echom 'pattern: '.pat
  if cur[0]
    call cursor(cur[0], cur[1]+1)
  endif
  let g:pattern = pat
endfunction
command! -bar -count=1 TransposeWords call TransposeWords(<count>)
nnore gs :<C-U>call TransposeWords()<CR>
