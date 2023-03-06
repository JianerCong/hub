library(tibble)
library(ggplot2)

n = 3
N = 100
t = n*(-N:N)/(2*N)
df <- tibble(t=t,x = 3*t/(1+t^3),y = x*t)
p <- ggplot(df,aes(x,y)) +
  geom_point()
