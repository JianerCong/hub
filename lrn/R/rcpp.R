library(Rcpp)

sumR <- function(x) {
  total <- 0
  for (i in seq_along(x)) {
    total <- total + x[i]
  }
  total
}

sumC <- cppFunction('double sumC(NumericVector x) {
  int n = x.size();
  double total = 0;
  for(int i = 0; i < n; ++i) {
    total += x[i];
  }
  return total;
}')
x <- runif(1e3)

df <- bench::mark(
         sum(x),
         sumC(x),
         sumR(x)
       )[1:6]
## expression      min   median `itr/sec` mem_alloc `gc/sec`
## <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
## 1 sum(x)     859.03ns 906.06ns   975571.        0B        0
## 2 sumC(x)      2.07µs   2.17µs   411768.    2.49KB        0
## 3 sumR(x)     25.01µs  26.35µs    36912.   19.23KB        0

pdistR <- function(x, ys) {
  sqrt((x - ys) ^ 2)
}

pdistC <- cppFunction('NumericVector pdistC(double x, NumericVector ys) {
  int n = ys.size();
  NumericVector out(n);

  for(int i = 0; i < n; ++i) {
    out[i] = sqrt(pow(ys[i] - x, 2.0));
  }
  return out;
}')
y <- runif(1e6)
df <- bench::mark(
         pdistR(0.5, y),
         pdistC(0.5, y)
       )[1:6]

print(df)
                                        # A tibble: 2 × 6
## expression          min   median `itr/sec` mem_alloc `gc/sec`
## <bch:expr>     <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
## 1 pdistR(0.5, y)    4.1ms   4.12ms      240.    7.63MB     98.6
## 2 pdistC(0.5, y)   2.05ms   3.17ms      326.    7.63MB    150. 
