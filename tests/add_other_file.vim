" Test adding a file that you are not currently editing

source helpers/add_setup.vim
call StartTapWithPlan(2)

edit first_file.txt

execute "normal :GitStatus\<cr>"
call vimtap#Like(BufferContent(), 'Untracked', 'There should be an untracked file, third_file.txt based on the setup')
normal q

" Note: third_file.txt is not the one you are editing
execute "normal :GitAdd third_file.txt\<cr>"
execute "normal :GitStatus\<cr>"

call vimtap#Unlike(BufferContent(), 'Untracked', 'There should be no untracked files, since you just added third_file.txt')

source ../helpers/add_teardown.vim
