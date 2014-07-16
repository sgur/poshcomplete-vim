let s:script_path = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

function! poshcomplete#CompleteCommand(findstart, base)
    if a:findstart
        let line = getline('.')
        let start = col('.') - 1

        while (start > 0 && line[start - 1] =~ '[[:alpha:]-$]')
            let start -= 1
        endwhile

        return start
    else
        let baseword = (a:base == '0') ? '-' : a:base " Bacause dash is replaced by zero
        let currentline = getline('.') . baseword

        if currentline == ''
            return []
        endif

        let path = s:prepare_buffer(currentline)

        if has('python')
            return poshcomplete#py_ext#complete(path)
        else
            return s:complete(path, index)
        endif
    endif
endfunction

function! s:prepare_buffer(line)
    let temp_path = tempname()
    call writefile(add(getline(1, line('.')-1), a:line), temp_path)
    return temp_path
endfunction

function! s:complete(path, index)
    let result = system("powershell -NoProfile -NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command \"" . fnameescape(s:script_path)  . "/completions.ps1 '" . a:path . "' " . a:index . "\"")
    return map(split(result, "\n"), 'eval(v:val)')
endfunction

if has('python')
    call poshcomplete#py_ext#init(s:script_path)
endif

" vim:set et ts=4 sts=0 sw=4 ff=unix:

