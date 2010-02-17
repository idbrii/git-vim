"=============================================================================
" FILE: git.vim
" AUTHOR: motemen <motemen@gmail.com>(Original)
"         Shougo Matsushita <Shougo.Matsu@gmail.com>(Modified)
" Last Modified: 15 Feb 2010
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Version: 1.3, for Vim 7.0
"=============================================================================

" Ensure b:git_dir exists.
function! s:get_git_dir()"{{{
  if !exists('b:git_dir')
    let b:git_dir = s:system('rev-parse --git-dir')
    if !s:get_error_status()
      let b:git_dir = fnamemodify(split(b:git_dir, "\n")[0], ':p') . '/'
    endif
  endif
  return b:git_dir
endfunction"}}}

" Returns current git branch.
" Call inside 'statusline' or 'titlestring'.
function! git#get_current_branch()"{{{
  let l:git_dir = s:get_git_dir()

  if l:git_dir != '' && filereadable(l:git_dir . '/HEAD')
    let l:lines = readfile(l:git_dir . '/HEAD')
    if empty(l:lines)
      return ''
    else
      return matchstr(l:lines[0], 'refs/heads/\zs.\+$')
    endif
  else
    return ''
  endif
endfunction"}}}

" List all git local branches.
function! git#list_branches(arg_lead, cmd_line, cursor_pos)"{{{
  let l:branches = split(s:system('branch'), '\n')
  if s:get_error_status()
    return []
  endif

  return map(l:branches, 'matchstr(v:val, ''^[* ] \zs.*'')')
endfunction"}}}

" List all git commits.
function! git#list_git_commits(arg_lead, cmd_line, cursor_pos)"{{{
  let l:commits = split(s:system('log --pretty=format:%h'))
  if s:get_error_status()
    return []
  endif

  let l:commits = ['HEAD'] + git#list_branches(a:arg_lead, a:cmd_line, a:cursor_pos) + l:commits

  if a:cmd_line =~ '^GitDiff'
    " GitDiff accepts <commit>..<commit>
    if a:arg_lead =~ '\.\.'
      let l:pre = matchstr(a:arg_lead, '.*\.\.\ze')
      let l:commits = map(l:commits, 'pre . v:val')
    endif
  endif

  return filter(l:commits, 'match(v:val, ''\v'' . a:arg_lead) == 0')
endfunction"}}}

" List all git commands.
function! git#list_commands(arg_lead, cmd_line, cursor_pos)"{{{
  let l:cmd = split(a:cmd_line)
  let l:len_cmd = len(l:cmd)

  if l:len_cmd <= 1
    " Commands name completion.
    let l:filter_cmd = printf('v:val =~ "^%s"', a:arg_lead)
    return filter(['add', 'bisect', 'branch', 'checkout', 'clone', 'commit', 'diff', 'fetch',
          \'grep', 'init', 'log', 'merge', 'mv', 'pull', 'push', 'rebase', 'reset', 'rm', 
          \'show', 'status', 'tag'], l:filter_cmd)
  else
    " Commands argments completion.
    let l:cmdname = l:cmd[1]
    if l:cmdname == 'add' || l:cmdname == 'mv' || l:cmdname == 'rm'
      let l:arg = get(l:cmd, 2, '')
      return split(glob(l:arg.'*'), '\n')
    elseif l:cmdname == 'branch'
      return ListGitBranches(a:arg_lead, a:cmd_line, a:cursor_pos)
    elseif l:cmdname == 'checkout' || l:cmdname == 'diff'
      return ListGitCommits(a:arg_lead, a:cmd_line, a:cursor_pos)
    elseif l:cmdname == 'clone'
      return []
    elseif l:cmdname == 'commit'
      return []
    elseif l:cmdname == 'fetch'
      return []
    elseif l:cmdname == 'grep'
      return []
    elseif l:cmdname == 'init'
      return []
    elseif l:cmdname == 'log'
      return []
    elseif l:cmdname == 'merge'
      return []
    elseif l:cmdname == 'pull'
      return []
    elseif l:cmdname == 'push'
      return []
    elseif l:cmdname == 'rebase'
      return []
    elseif l:cmdname == 'reset'
      return []
    elseif l:cmdname == 'show'
      return []
    elseif l:cmdname == 'status'
      return []
    elseif l:cmdname == 'tag'
      return []
    else
      let l:filter_cmd = printf('v:val =~ "^%s"', a:arg_lead)
      return filter(['add', 'bisect', 'branch', 'checkout', 'clone', 'commit', 'diff', 'fetch',
            \'grep', 'init', 'log', 'merge', 'mv', 'pull', 'push', 'rebase', 'reset', 'rm', 
            \'show', 'status', 'tag'], l:filter_cmd)
    endif
  endif
endfunction"}}}

" Show diff.
function! git#diff(args)"{{{
  let l:git_output = s:system('diff ' . a:args . ' -- ' . s:expand('%'))
  if !strlen(git_output)
    echo "No output from git command"
    return
  endif

  call s:open_git_buffer(l:git_output)
  setlocal filetype=git-diff
endfunction"}}}

" Show Status.
function! git#status()"{{{
  let l:git_output = s:system('status')
  call s:open_git_buffer(l:git_output)
  setlocal filetype=git-status
  nnoremap <buffer> <Enter> :<C-u>call <SID>add_cursor_file()<Enter>
  nnoremap <buffer> -       :<C-u>call <SID>remove_cursor_file()<Enter>
endfunction"}}}

function! s:add_cursor_file()"{{{
  call git#add(s:expand('<cfile>'))
  call s:refresh_git_status()
endfunction"}}}
function! s:remove_cursor_file()"{{{
  call s:system('git reset HEAD -- ' . s:expand('<cfile>'))
  call s:refresh_git_status()
endfunction"}}}
function! s:refresh_git_status()"{{{
  let l:pos_save = getpos('.')
  call git#status()
  call setpos('.', l:pos_save)
endfunction"}}}

" Show Log.
function! git#log(args)"{{{
  let l:git_output = s:system('log ' . a:args . ' -- ' . s:expand('%'))
  call s:open_git_buffer(l:git_output)
  setlocal filetype=git-log
endfunction"}}}

" Add file to index.
function! git#add(expr)"{{{
  let l:file = s:expand(a:expr != '' ? a:expr : '%')

  call git#do_command('add ' . l:file)
endfunction"}}}

" Commit.
function! git#commit(args)"{{{
  let l:git_dir = s:get_git_dir()

  let l:args = a:args
  if l:args !~ '\v\k@<!(-a|--all)>' && s:system('diff --cached --stat') =~ '^\(\s\|\n\)*$'
    let l:args .= ' -a'
  endif

  " Create COMMIT_EDITMSG file
  let l:editor_save = $EDITOR
  let $EDITOR = ''
  let l:git_output = s:system('git commit ' . l:args)
  let $EDITOR = l:editor_save

  execute printf('%s %sCOMMIT_EDITMSG', g:git_command_edit, git_dir)
  setlocal filetype=git-status bufhidden=wipe
  augroup GitCommit
    autocmd!
    autocmd BufWritePre  <buffer> g/^\s*#/d | setlocal fileencoding=utf-8
    execute printf("autocmd BufWritePost <buffer> call git#do_command('commit %s -F ' . expand('%%')) | autocmd! GitCommit * <buffer>", args)
  augroup END
endfunction"}}}

" Checkout.
function! GitCheckout(args)"{{{
  call git#do_command('checkout ' . a:args)
endfunction"}}}

" Push.
function! git#push(args)"{{{
  "   call git#do_command('push ' . a:args)
  " Wanna see progress...
  let l:args = a:args
  if l:args =~ '^\s*$'
    let l:args = 'origin ' . git#branch()
  endif
  
  echo s:system(join([g:git_bin, 'push'] + l:args))
endfunction"}}}

" Pull.
function! git#pull(args)"{{{
  "   call git#do_command('pull ' . a:args)
  " Wanna see progress...
  echo s:system(join([g:git_bin, 'pull'] + a:args))
endfunction"}}}

" Show commit, tree, blobs.
function! git#cat_file(file)"{{{
  let l:file = s:expand(a:file)
  let l:git_output = s:system('cat-file -p ' . l:file)
  if l:git_output == ''
    echo "No output from git command"
    return
  endif

  call s:open_git_buffer(l:git_output)
endfunction"}}}

" Show revision and author for each line.
function! git#blame()"{{{
  let l:git_output = s:system('blame -- ' . expand('%'))
  if l:git_output == ''
    echo "No output from git command"
    return
  endif

  setlocal noscrollbind

  " :/
  let l:git_command_edit_save = g:git_command_edit
  let g:git_command_edit = 'leftabove vnew'
  call s:open_git_buffer(l:git_output)
  let g:git_command_edit = l:git_command_edit_save

  setlocal modifiable
  silent %s/\d\d\d\d\zs \+\d\+).*//
  vertical resize 20
  setlocal nomodifiable
  setlocal nowrap scrollbind

  wincmd p
  setlocal nowrap scrollbind

  syncbind
endfunction"}}}

function! git#do_command(args)"{{{
  let l:git_output = substitute(s:system(a:args), '\n*$', '', '')
  if s:get_error_status()
    echohl Error
    echo l:git_output
    echohl None
  else
    echo l:git_output
  endif
endfunction"}}}

function! s:system(args)"{{{
  let l:command = g:git_bin . ' ' . a:args
  return g:git_use_vimproc ? vimproc#system(l:command) : system(l:command)
endfunction"}}}
function! s:get_error_status()"{{{
  return g:git_use_vimproc ? vimproc#get_last_status() : v:shell_error
endfunction"}}}

" Show vimdiff for merge. (experimental)
function! git#vimdiff_merge()"{{{
  let l:file = s:expand('%')
  let l:filetype = &filetype
  let t:git_vimdiff_original_bufnr = bufnr('%')
  let t:git_vimdiff_buffers = []

  topleft new
  setlocal buftype=nofile
  file `=':2:' . l:file`
  call add(t:git_vimdiff_buffers, bufnr('%'))
  execute 'silent read!git show :2:' . l:file
  0d
  diffthis
  let &filetype = l:filetype

  rightbelow vnew
  setlocal buftype=nofile
  file `=':3:' . l:file`
  call add(t:git_vimdiff_buffers, bufnr('%'))
  execute 'silent read!git show :3:' . l:file
  0d
  diffthis
  let &filetype = l:filetype
endfunction"}}}

function! git#vimdiff_merge_done()"{{{
  if exists('t:git_vimdiff_original_bufnr') && exists('t:git_vimdiff_buffers')
    if getbufline(t:git_vimdiff_buffers[0], 1, '$') == getbufline(t:git_vimdiff_buffers[1], 1, '$')
      execute 'sbuffer ' . t:git_vimdiff_original_bufnr
      0put=getbufline(t:git_vimdiff_buffers[0], 1, '$')
      normal! jdG
      update
      execute 'bdelete ' . t:git_vimdiff_buffers[0]
      execute 'bdelete ' . t:git_vimdiff_buffers[1]
      close
    else
      echohl Error
      echo 'There still remains conflict'
      echohl None
    endif
  endif
endfunction"}}}

function! s:open_git_buffer(content)"{{{
  if exists('b:is_git_msg_buffer') && b:is_git_msg_buffer
    enew!
  else
    execute g:git_command_edit
  endif

  setlocal buftype=nofile readonly modifiable
  execute 'setlocal bufhidden=' . g:git_bufhidden

  silent put=a:content
  keepjumps 0d
  setlocal nomodifiable

  let b:is_git_msg_buffer = 1
endfunction"}}}

function! s:expand(expr)"{{{
  if has('win32') || has('win64')
    " Substitute path.
    return substitute(expand(a:expr), '\\', '/', 'g')
  else
    return expand(a:expr)
  endif
endfunction"}}}
