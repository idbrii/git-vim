" Test that GitVimDiff works correctly when adding a single line to a file.

source helpers/vimdiff_setup.vim
call StartTapWithPlan(2)

" Append another line to the first file so you'll be able to diff it
edit first_file.txt
normal oThis is another line of text
write

GitVimDiff
normal G
call vimtap#Like(LineContent(), 'first_file_contents', 'The last line is the same as the first')

"Switch to the other window
wincmd w
normal G
call vimtap#Like(LineContent(), 'another line', 'The last line is the appended content')

source ../helpers/vimdiff_teardown.vim
