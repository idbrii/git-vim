" Test the options toggling using the ? key

source helpers/git_status_setup.vim

call vimtest#StartTap()

call vimtap#Plan(3)

GitStatus

normal ggVG"ayy
call vimtap#Like(getreg('a'), 'Untracked files:', 'There is at least one untracked file')

" Move to the last line and check that the file is right
normal G"ayy
call vimtap#Like(getreg('a'), 'third_file.txt', 'The last line contains the untracked file')

" Add the untracked file
normal a
normal ggVG"ayy
call vimtap#Unlike(getreg('a'), 'Untracked files:', 'There are no untracked files')

source ../helpers/git_status_teardown.vim

call vimtest#Quit()
