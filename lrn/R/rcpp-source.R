library(Rcpp)
## sourceCpp("r.cpp")

sourceCpp("list.cpp")
mod <- lm(mpg ~ wt, data = mtcars)
a <- mpe(mod)

a <- rleC(c(1,2,3))
