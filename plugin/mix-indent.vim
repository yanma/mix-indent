" Author: yanma <PastelParasol@gmail.com>
" License: MIT License

if exists('g:loaded_mix_indent') && g:loaded_shadeline
    finish
endif

let g:loaded_mix_indent = 1
" let g:mix_indent_debug = 1

if !exists('g:mix_indent_debug')
    let g:mix_indent_debug = 0
endif

if g:mix_indent_debug
    if !exists('g:mix_indent_log_filename')
        let g:mix_indent_log_filename = "/tmp/test.log"
    endif
endif

function! MixIndent_FindSoftIndent()
    let s:c_like_langs = [ 'c', 'cpp', 'cuda', 'go', 'javascript', 'ld', 'php' ]
    if index(s:c_like_langs, &ft) > -1
        " for C-like languages: allow /** */ comment style with one space before the '*'
        let s:head_spc = '\v(^ +\*@!)'
    else
        let s:head_spc = '\v(^ +)'
    endif
    return search(s:head_spc, 'nW')
endfunction

function! MixIndent_FindHardIndent()
    return search('\v(^\t+)', 'nW')
endfunction

function! MixIndent_OutputDebugLog(list, flag)
    if g:mix_indent_debug
        call writefile(a:list, g:mix_indent_log_filename, a:flag)
    endif
endfunction

function! MixIndent_ExecHighlight()
    let s:pos = getpos(".")
    call cursor(1, 0)
    let s:indent_tabs = MixIndent_FindHardIndent()
    let s:indent_spaces  = MixIndent_FindSoftIndent()
    call MixIndent_OutputDebugLog([s:indent_spaces . ", " . s:indent_tabs], "a")
    while s:indent_tabs > 0 && s:indent_spaces > 0
        call cursor(s:indent_tabs, 0)
        let s:indent_tabs = MixIndent_FindHardIndent()
        call cursor(s:indent_spaces, 0)
        let s:indent_spaces  = MixIndent_FindSoftIndent()
        if s:indent_tabs >= 0 && s:indent_spaces == 0
            syn clear MixedTab
            syn match MixedSpace excludenl /\v(^ +)/
        elseif s:indent_tabs == 0 && s:indent_spaces > 0
            syn clear MixedSpace
            syn match MixedTab excludenl /\v(^\t+)/
        endif
    endwhile
    call setpos('.', s:pos)
endfunction

highlight MixedTab   ctermbg=203 guibg=#e27878
highlight MixedSpace ctermbg=216 guibg=#e2a478

call MixIndent_OutputDebugLog(["Debug Log"], "")
autocmd InsertEnter,InsertLeave,CursorMoved,CursorMovedI,BufEnter,BufReadPost,BufWritePost * call MixIndent_ExecHighlight()

