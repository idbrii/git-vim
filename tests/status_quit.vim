" Test that hitting the q key in the GitStatus buffer will quit it.

source helpers/status_setup.vim
call StartTapWithPlan(2)

GitStatus

call vimtap#Like(BufferContent(), 'Untracked files', 'We are in GitStatus')

normal q

call vimtap#Unlike(BufferContent(), 'Untracked files', 'We are no longer in GitStatus')

source ../helpers/status_teardown.vim
