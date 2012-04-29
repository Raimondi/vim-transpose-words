" Funny word
function! TransposeWords(...) range
  let on_word = matchstr(getline(line('.'))[(col('.') - 1) :], '^.') =~ '\w'
  let cnt = a:0 ? a:1 : v:count1
  let current = getpos('.')[1:-2]
  let pos1 = searchpos('\k\+', 'cWb')
  if !pos1[0]
    let pos1 = searchpos('\k\+', 'cW')
  endif
  let pos2 = map(range(cnt), 'searchpos(''\k\+\k\@!\_.\{-1,}\zs\k'', ''W'')')[-1]
  if !pos1[0] || !pos2[0]
    call cursor(current)
    return 0
  endif
  call cursor(current)
  let line1 = getline(pos1[0])
  let line2 = pos1[0] == pos2[0] ? line1 : getline(pos2[0])
  let word1 = matchstr(line1[pos1[1] - 1 :], '^\k\+')
  let word2 = matchstr(line2[pos2[1] - 1 :], '^\k\+')

  echom 'pos1: '.string(pos1)
  echom 'pos2: '.string(pos2)
  echom 'line1: '.line1
  echom 'line2: '.line2
  echom 'word1: '.word1
  echom 'word2: '.word2
  if pos1[0] == pos2[0] && (pos1[1] + len(word1) >= pos2[1])
    call cursor(current)
    return 0
  endif
  if pos1[0] < pos2[0]
    let partial1 = line1[ : pos1[1] == 1 ? - (len(line1) + 1) : pos1[1] - 2]
    let partial2 = line1[pos1[1] + len(word1) - 1 : ]
    let partial3 = line2[ : pos2[1] == 1 ? - (len(line2) + 1) : pos2[1] - 2]
    let partial4 = line2[pos2[1] + len(word2) - 1 : ]
    let final_line1 = partial1 . word2 . partial2
    let final_line2 = partial3 . word1 . partial4
  else
    let partial1 = line1[ : (pos1[1] == 1
          \ ? - (len(line1) + 1)
          \ : pos1[1] - 2)]
    let partial2 = line1[ pos1[1] + len(word1) - 1 : pos2[1] - 2]
    let partial3 = line1[ pos2[1] + len(word2) - 1 : ]
    let final_line1 = partial1 . word2 . partial2 . word1 . partial3
  endif
  echom 'partial1: '.string(partial1)
  echom 'partial2: '.string(partial2)
  echom 'partial3: '.string(partial3)
  echom 'partial4: '.exists('partial4') ? string(partial4) : ''
  if setline(pos1[0], final_line1)
        \ || (exists('final_line2')
        \     && setline(pos2[0], final_line2))
    call cursor(current)
    return 0
  endif
  return !cursor(pos2[0], pos2[1] + len(word1))
endfunction
command! -bar -count=1 TransposeWords call TransposeWords(<Count>)
nnore gs :<C-U>call TransposeWords()<CR>
finish
"xyz, (mn) fgh rst
"uvw%&/cde
opq jkl 123




abc
