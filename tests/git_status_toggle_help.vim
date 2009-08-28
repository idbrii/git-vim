" Test the options toggling using the ? key

source helpers/git_status_setup.vim

call vimtest#StartTap()

call vimtap#Plan(3)

GitStatus

normal gg
call vimtap#Like(LineContent(), 'type ? for options', 'help is not shown by default')

normal ?
call vimtap#Unlike(LineContent(), 'type ? for options', 'the message does not appear because the options are now being shown')

normal ?
call vimtap#Like(LineContent(), 'type ? for options', 'help is not shown by default')

source ../helpers/git_status_teardown.vim

call vimtest#Quit()
