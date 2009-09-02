" The setup creates a git_tmpdir directory and adds several files to it.  It
" commits one, adds another, and leaves one untracked.  Having files in three
" different stages allows us to test different types of functionality.

" Make the git_tmpdir
silent ! test -d git_tmpdir && rm -rf git_tmpdir
silent ! mkdir git_tmpdir

" Move into the directory and start adding files
" All tests are run from within the git_tmpdir directory
cd git_tmpdir
silent ! git init

" The first file is added and committed
silent ! echo first_file_contents >> first_file.txt; git add .
silent ! git commit -m "Committed the first_file"

" The nested file is added and committed
silent ! mkdir directory
silent ! echo nested_file_contents >> directory/nested_file.txt; git add .
silent ! git commit -m "Committed the nested_file"

" The second file is added but not committed
silent ! echo second_file_contents >> second_file.txt; git add .

" The third file is created, but untracked
silent ! echo third_file_contents >> third_file.txt;

"----------------------------------------------------------------------------
" We also have a few helper functions which make reading the tests a bit
" easier.
"

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
