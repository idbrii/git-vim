" Create the git_status_tmpdir directory and bring its contents to a known
" state.
silent ! test -d git_status_tmpdir && rm -rf git_status_tmpdir
silent ! mkdir git_status_tmpdir

" Move into the directory and start adding files
cd git_status_tmpdir
silent ! git init

"----------------------------------------------------------------------------

" The first file is added and committed
silent ! echo first_file_contents >> first_file.txt; git add .
silent ! git commit -m "Committed the first_file"

" The second file is added but not committed
silent ! echo second_file_contents >> second_file.txt; git add .

" The third file is created, but untracked
silent ! echo third_file_contents >> third_file.txt;

function! LineContent()
    normal "ayy
    return getreg('a')
endfunction

function! BufferContent()
    normal ggVG"ayy
    return getreg('a')
endfunction

