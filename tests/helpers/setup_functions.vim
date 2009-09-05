function! StartTapWithPlan(plan)
    call vimtest#StartTap()
    call vimtap#Plan(a:plan)
endfunction

function! LineContent()
    normal "ayy
    return getreg('a')
endfunction

function! BufferContent()
    normal ggVG"ayy
    return getreg('a')
endfunction
