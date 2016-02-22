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


function! s:GetPrevNonCommentLineNum( line_num )
   let nline = a:line_num
   let SKIP_LINES = '^\s*//'
   while nline > 0
      let nline = prevnonblank(nline-1)
      if getline(nline) !~? SKIP_LINES
         break
      endif
      " call input("*")
   endwhile
   return nline
endfunction

function! jsbasicindent#JSBasicIndent( line_num )
    let prev_line_num = s:GetPrevNonCommentLineNum( a:line_num )
    let prev_line = getline( prev_line_num )
    let ind = indent( prev_line_num )
    if prev_line =~ ';\s*$'
        return ind
    endif
    return ind + &shiftwidth
endfunction
