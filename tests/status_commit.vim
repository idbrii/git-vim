" Turn the status buffer into a commit buffer by hitting the c key

source helpers/status_setup.vim

call vimtest#StartTap()

call vimtap#Plan(2)

GitStatus

call vimtap#Unlike(BufferContent(), 'enter the commit message', 'It should not ask for a commit message when you are in GitStatus')

normal c

call vimtap#Like(BufferContent(), 'enter the commit message', 'It should ask for a commit message when you are in GitCommit')

source ../helpers/status_teardown.vim

call vimtest#Quit()
