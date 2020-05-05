function! s:list2str(lst)
    if len(a:lst)==0
        return '[]'
    endif

    let res='[\"'.a:lst[0]
    for s in a:lst
        if s
            let res.='\",\"'.s
        endif
    endfor
    let res.='\"]'
    return res
endfunction

function! netranger#asyncCallBack(job_id, data, event)
   if a:event == "exit"
        exec g:_NETRPY.'netranger.Vim.VimAsyncCallBack("'.a:job_id.'","'.a:event.'","[]")'
    else
        if has("nvim")
            let data = escape(join(a:data,'\n'),'"')
        else
            let data = escape(a:data, '"')
        endif
        let data = substitute(data, '', '\\n', 'g')
        exec g:_NETRPY.'netranger.Vim.VimAsyncCallBack("'.a:job_id.'","'.a:event.'","'.data.'")'
   endif
endfunction

function! netranger#termAsyncCallBack(job_id, data, event, cmd_win_id)
   call assert_true(a:event == "exit", "termAsyncCallBack should only handle exit")
   call win_gotoid(a:cmd_win_id)
   if a:data==0
       wincmd c
   endif
   exec g:_NETRPY.'netranger.Vim.VimAsyncCallBack("'.a:job_id.'","'.a:event.'","[]")'
endfunction

function! netranger#vimAsyncCallBack(job_id, data, event)
   if a:event == "exit"
        exec g:_NETRPY.'netranger.Vim.VimAsyncCallBack("'.a:job_id.'","'.a:event.'","[]")'
    else
        let data = escape(a:data, '"')
        exec g:_NETRPY.'netranger.Vim.VimAsyncCallBack("'.a:job_id.'","'.a:event.'","'.data.'")'
   endif
endfunction

function! netranger#AsyncDisplayCallBack(job_id, exit_code, event, ori_win_nr, cmd_win_nr)
  call assert_true(a:event == "exit", "nvimAsyncDisplayCallBack should only handle exit")
  call win_gotoid(a:cmd_win_nr)
  if a:exit_code==0
      bwipeout!
  else
    call win_gotoid(a:ori_win_nr)
  endif
  exec g:_NETRPY.'netranger.Vim.VimAsyncCallBack("'.a:job_id.'","'.a:event.'","[]")'
endfunction



"""""""" APIs """"""""

function! netranger#cur_node_name()
    " return the basename of the current node
    return py3eval('NETRApi.cur_node_name()')
endfunction

function! netranger#cur_node_path()
    " return the full path of the current node
    return py3eval('NETRApi.cur_node_path()')
endfunction

function! netranger#render()
    " redraw the highlight of all nodes
    return py3eval('NETRApi.render()')
endfunction

function! netranger#cp(src, dst)
    " src: full path of the source file/directory
    " dst: full path of the target directory
    return py3eval('NETRApi.cp("'.a:src.'","'.a:dst.'")')
endfunction

function! netranger#mv(src, dst)
    " src: full path of the source file/directory
    " dst: full path of the target directory
    return py3eval('NETRApi.mv("'.a:src.'","'.a:dst.'")')
endfunction

function! netranger#rm(src)
    " src: full path of the file/directory to be removed
    return py3eval('NETRApi.rm("'.a:src.'")')
endfunction

function! netranger#mapvimfn(key, fn)
    " key: key to be mapped, can be vim's special key, e.g. <esc>
    " fn: the name of a vim's user defined function
    return py3eval('NETRApi.mapvimfn("'.a:key.'","'.a:fn.'")')
endfunction

function! netranger#registerHookerVimFn(hooker, fn)
    return py3eval('NETRApi.RegisterHookerVimFn("'.a:hooker.'","'.a:fn.'")')
endfunction
