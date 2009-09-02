" Test that the leader shortcut works with two different leaders

source helpers/status_setup.vim
call StartTapWithPlan(3)

edit first_file.txt

" The Leader and gs should open GitStatus
" Try two different leaders to make sure they're working correctly
let mapleader = "_"
so ../../plugin/git.vim
normal _gs

call vimtap#Like(BufferContent(), 'Untracked files:', 'The git status buffer is showing')

normal q

call vimtap#Unlike(BufferContent(), 'Untracked files:', 'The git status buffer is no longer showing')

" Second leader
let mapleader = ","
so ../../plugin/git.vim
normal ,gs

call vimtap#Like(BufferContent(), 'Untracked files:', 'The git status buffer is showing')

source ../helpers/status_teardown.vim
