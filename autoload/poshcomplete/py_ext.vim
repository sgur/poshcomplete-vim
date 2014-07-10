
function! poshcomplete#py_ext#init(script_path)
python << EOF
import sys, vim
scr_path = vim.eval("a:script_path")
sys.path.insert(0, scr_path)
import getcandidates
sys.path.remove(scr_path)
EOF
endfunction

function! poshcomplete#py_ext#complete(line)
    let temp = tempname()
    let bytes = len(join(getline(1, line('.')-1), "\n")) + col('.')
    call writefile(getline(1, '.'), temp)
    python getcandidates.complete(vim.eval("temp"), vim.eval("bytes"))
    return []
endfunction

" vim:set et ts=4 sts=0 sw=4 ff=unix:
