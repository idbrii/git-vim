" Test using the 'd' key to show a diff of the file on the current line

source helpers/status_setup.vim
call StartTapWithPlan(2)

" Append another line to the first file so you'll be able to diff it
edit first_file.txt
normal oThis is another line of text
write

GitStatus

" Go to the line and hit 'r' to remove it from the git
/first_file
call vimtap#Like(LineContent(), 'first_file.txt', 'The first file has some changes made to it')
normal d

call vimtap#Like(BufferContent(), '+This is another line of text', 'The diff shows up properly')

source ../helpers/status_teardown.vim
