" Test adding the file you are currently editing

source helpers/add_setup.vim
call StartTapWithPlan(2)

edit third_file.txt

execute "normal :GitStatus\<cr>"
call vimtap#Like(BufferContent(), 'Untracked', 'There should be an untracked file, third_file.txt based on the setup')
normal q

" [tag:feature_or_bug:gem] [tag:todo:gem] The % in GitAdd is required.  Should it be?
execute "normal :GitAdd %\<cr>"
execute "normal :GitStatus\<cr>"

call vimtap#Unlike(BufferContent(), 'Untracked', 'There should be no untracked files, since you just added third_file.txt')

source ../helpers/add_teardown.vim
