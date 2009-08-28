" Test the options toggling using the ? key

source git_status_helper_setup.vim

call vimtest#StartTap()

call vimtap#Plan(3)

GitStatus

normal gg"ayy
call vimtap#Like(getreg('a'), 'type ? for options', 'help is not shown by default')

normal ?gg"ayy
call vimtap#Unlike(getreg('a'), 'type ? for options', 'the message does not appear because the options are now being shown')

normal ?gg"ayy
call vimtap#Like(getreg('a'), 'type ? for options', 'help is not shown by default')

source git_status_helper_teardown.vim

call vimtest#Quit()
