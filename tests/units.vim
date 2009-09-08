' Test the internal functions (doesn't create a git directory)

source helpers/setup_functions.vim
call StartTapWithPlan(8)

let opts_files = GitParseOptsAndFiles('-i -p -- file1.txt')
call vimtap#Ok(opts_files == [['-i', '-p'],['file1.txt']], 'Two options and a file')
call vimtap#Ok(opts_files != [['-p'],['file1.txt']], 'Two options and a file - intentional failure')

let opts_files = GitParseOptsAndFiles('-i -p -- file1.txt file2.txt')
call vimtap#Ok(opts_files == [['-i', '-p'],['file1.txt', 'file2.txt']], 'Two options and two files')
call vimtap#Ok(opts_files != [['-p'],['file1.txt']], 'Two options and two files - intentional failure')

let opts_files = GitParseOptsAndFiles('-i --cached -p -- file1.txt file2.txt')
call vimtap#Ok(opts_files == [['-i', '--cached', '-p'],['file1.txt', 'file2.txt']], 'long option')

let [opts, files] = GitParseOptsAndFiles('-i --cached -p -- file1.txt file2.txt')
call vimtap#Is(index(opts, '--cached'),1, '--cached is an option')
call vimtap#Is(index(opts, '-p'), 2, '-p is an option')
call vimtap#Is(index(opts, '-h'), -1, '-h is not an option')

source helpers/teardown.vim
