" Create the git_status_tmpdir directory and bring its contents to a known
" state.
silent ! test -d git_status_tmpdir && rm -rf git_status_tmpdir
silent ! mkdir git_status_tmpdir

" Move into the directory and start adding files
cd git_status_tmpdir
silent ! git init
silent ! echo blah >> first_file.txt; git add .
silent ! git commit -m "Committed the first_file"
silent ! echo blah >> second_file.txt; git add .
" Not going to commit the second file

" Move back out of the git_status_tmpdir directory so the rest of the script
" runs in the test directory.
cd ..
