" Create the status_tmpdir directory

" First, add the global helper methods
source helpers/setup.vim

silent ! test -d status_tmpdir && rm -rf status_tmpdir
silent ! mkdir status_tmpdir

" Move into the directory and start adding files
cd status_tmpdir
silent ! git init

"----------------------------------------------------------------------------

" The first file is added and committed
silent ! echo first_file_contents >> first_file.txt; git add .
silent ! git commit -m "Committed the first_file"

" The second file is added but not committed
silent ! echo second_file_contents >> second_file.txt; git add .

" The third file is created, but untracked
silent ! echo third_file_contents >> third_file.txt;

