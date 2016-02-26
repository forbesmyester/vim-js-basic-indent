" prev line is either
"   - opener
"       if (a) {     <-
"       it(does, function() {     <-
"   - closer 
"       }     <-
"       });     <-
"   - incomplete statement start
"       this.doX()     <-
"   - incomplete statement middle (also opener)
"       this.doX()
"         .then(function() {   <-
"   - incomlete statement middle (also closer)
"       this.doX()
"         .then(function() {
"         })   <-

function! s:GetLastStatement( line_num )
    let nline = a:line_num
    let SKIP_LINES = '^\s*//'
    let SEMI_SEARCH = ';\s*$'
    let lines = []
    while nline > 0
        let nline = prevnonblank(nline-1)
        if (nline < 1)
            let nline = nline + 1
            break
        endif
        let line = getline(nline)
        if line =~ SKIP_LINES
            continue
        endif
        " call input("LS: (" . line . ")>" . join(lines, "\n"))
        if line =~ SEMI_SEARCH
            break
        endif
        call add(lines, line)
    endwhile
    call reverse(lines)
    return [nline, lines]
endfunction

function! jsbasicindent#JSBasicIndent( line_num )
    let prev_statement = s:GetLastStatement( a:line_num )
    " call input("FIN" . prev_statement[0] . "/" . len(prev_statement[1]) . ": " . join(prev_statement[1], "\n"))
    echo prev_statement
    " let prev_line = getline( prev_line_num )
    let ind = indent( prev_statement[0] )
    if len(prev_statement[1]) == 0
        return ind
    endif
    return ind + &shiftwidth
endfunction
