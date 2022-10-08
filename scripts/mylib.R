## library(tidyverse)
library(stringr)
library(rlang)
## library(assertthat)

S_RED     <- "\x1b[31m"
S_GREEN   <- "\x1b[32m"
S_YELLOW  <- "\x1b[33m"
S_BLUE    <- "\x1b[34m"
S_MAGENTA <- "\x1b[35m"
S_CYAN    <- "\x1b[36m"
S_NOR <- "\x1b[0m"

message(S_BLUE,'Hi, mylib.R is loaded ◉_◉',S_NOR)

rule <- function(s, level=0, n=50){
  ## tab <- paste0(rep('\t',level), collapse="")
  ## cat(S_GREEN, tab, s, ' ',
  ##     paste0(rep('-',n - str_length(s)), collapse=""),
  ##     S_NOR, '\n')
  if (level == 0){
    cli::cli_h1(s)
  }else{
    cli::cli_h2(s)
  }
}

vw2 <- function(n, x, long =FALSE){
  if (long){
    cat('\t', n ,'\n:', x ,'\n')
  }else{
    cat('\t', n ,'\t:', x ,'\n')
  }
}

vw <- function(x, long =FALSE){
  e <- enexpr(x) #e is an expression object

  ## cat('In vw: the env is: \n')
  ## env_print(current_env())
  ## cat('In vw: the caller env is: \n')
  ## env_print(caller_env())
  if (long){
    ## eval in caller_env
    s <- paste0('\t', as_string(e),'\n:',eval(e, NULL, caller_env()),'\n')
  }else{
    s <- paste0('\t', as_string(e),'\t:',eval(e, NULL, caller_env()),'\n')
  }
  cat(s)
}

vw3 <- function(s,o){
  cat(s);print(o)
}

check_smaller <- function(x,y,nx,ny){
  msg = gettextf('%s [%10.3g] should be smaller than %s [%10.3g]: ',
                 nx,  x, ny, y)
  if (x < y){
    msg <- str_c(msg,S_GREEN, 'OK 🐸', S_NOR)
  }else{
    msg <- str_c(msg,S_RED,'NOT OK 😭', S_NOR)
  }
  cat(msg,'\n')
}

deg2rad <- function(d){d * pi / 180}
cot <- function(x){1 / tan(x)}
make_d <- function(f){
  function(d){f(deg2rad(d))}
}
sind <- make_d(sin)
cosd <- make_d(cos)
tand <- make_d(tan)
cotd <- make_d(cot)

area_circ <- function(d){
  pi * d^2 / 4
}
