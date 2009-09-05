" Test the internal functions (don't create a git directory)

source helpers/setup_functions.vim
call StartTapWithPlan(4)

let opts_files = GitParseOptsAndFiles("-i -p -- file1.txt")
call vimtap#Ok(opts_files == [['-i', '-p'],['file1.txt']], "Two options and a file")
call vimtap#Ok(opts_files != [['-p'],['file1.txt']], "Two options and a file - negative test")

let opts_files = GitParseOptsAndFiles("-i -p -- file1.txt file2.txt")
call vimtap#Ok(opts_files == [['-i', '-p'],['file1.txt', 'file2.txt']], "Two options and two files")
call vimtap#Ok(opts_files != [['-p'],['file1.txt']], "Two options and two files - negative test")

source helpers/teardown.vim
