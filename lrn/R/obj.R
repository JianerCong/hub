
new_data.frame <- function(...){
  args <- list(...)
  a1 <- args[[1]]
  l <- length (a1)
  for (a in args){
    l2 <- length(a)
    if (l2 != l){
      stop(cat("Inconsistant length: ",l2,"and",l," "), .call=FALSE)
    }
  }
  do.call(data.frame,args)
}

df <- new_data.frame(x=c(1,2),y=c(3,4))
new_data.frame(x=c(1,2), y=3)
names(df) # c("a","b")
