" Test the options toggling using the ? key

source helpers/status_setup.vim
call StartTapWithPlan(3)

GitStatus

normal gg
call vimtap#Like(LineContent(), 'type ? for options', 'help is not shown by default')

normal ?
call vimtap#Unlike(LineContent(), 'type ? for options', 'the message does not appear because the options are now being shown')

normal ?
call vimtap#Like(LineContent(), 'type ? for options', 'help is not shown by default')

source ../helpers/status_teardown.vim
