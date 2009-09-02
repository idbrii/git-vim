" Test if you can do GitVimDiff on a nested file from the root

source helpers/vimdiff_setup.vim
call StartTapWithPlan(2)

edit nested_directory/nested_file.txt
normal oThis is another line of text
write

GitVimDiff
normal G
call vimtap#Like(LineContent(), 'nested_file_contents', 'The last line is the same as the first')

"Switch to the other window
wincmd w
normal G
call vimtap#Like(LineContent(), 'another line', 'The last line is the appended content')

source ../helpers/vimdiff_teardown.vim
