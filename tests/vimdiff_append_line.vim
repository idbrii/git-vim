" Test that GitVimDiff works correctly when adding a single line to a file.

source helpers/vimdiff_setup.vim
call StartTapWithPlan(3)

edit first_file.txt

call vimtap#Like(BufferContent(), 'another line', 'The another line has been appended by the setup')

GitVimDiff
normal G
call vimtap#Like(LineContent(), 'first_file_contents', 'The last line is the same as the first')

"Switch to the other window
wincmd w
normal G
call vimtap#Like(LineContent(), 'another line', 'The last line is the appended content')

source ../helpers/vimdiff_teardown.vim
