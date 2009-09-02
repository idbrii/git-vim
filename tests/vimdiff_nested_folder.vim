" Test if you can do GitVimDiff on a nested file from within the nested folder

source helpers/vimdiff_setup.vim
call StartTapWithPlan(2)

" Move into the nested directory
cd directory
edit nested_file.txt
normal oThis is another line of text
write

GitVimDiff
normal G
call vimtap#Like(LineContent(), 'nested_file_contents', 'The last line is the same as the first')

"Switch to the other window
wincmd w
normal G
call vimtap#Like(LineContent(), 'another line', 'The last line is the appended content')

" Move back out of the nested directory
cd ..
source ../helpers/vimdiff_teardown.vim
