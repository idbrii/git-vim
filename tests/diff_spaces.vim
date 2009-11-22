" Test diffing the current file using the space syntax

source helpers/diff_setup.vim
call StartTapWithPlan(1)

" Append another line to the first file so you'll be able to diff it
edit first_file.txt
normal oThis is another line of text
write

execute "normal :git diff\<cr>"

call vimtap#Like(BufferContent(), '+This is another line of text', 'The diff shows up properly')

source ../helpers/diff_teardown.vim
