function! LineContent()
    normal "ayy
    return getreg('a')
endfunction

function! BufferContent()
    normal ggVG"ayy
    return getreg('a')
endfunction

