library(rlang)

f <- function(x){
  e <- enexpr(x) #e is an expression object
  cat(as_string(e),'\t:',eval(e),'\n')
}

a <- 2
f(a)
