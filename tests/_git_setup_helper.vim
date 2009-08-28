" Reset the simplegit_test folder to its fixture state and cd into it
silent !rm -rf simplegit_test
silent !mkdir simplegit_test
cd simplegit_test
silent !git init
silent !echo blah >> first_file.txt; git add .
silent !git commit -m "Committed the first_file"
silent !echo blah >> second_file.txt; git add .
" Not going to commit the second file
