## Image to ascii art

run <- function(){
  source("i2a.R")
}

cat("Welcome 🐸\n")

library(tidyverse)
library(imager)

im <- load.image("glaxy-eyes2.jpg")
## plot(im)

asc <- gtools::chr(38:126) #We use a subset of ASCII, R doesn't render the rest
## asc <- c("*", "o" , " ", "/", "\\" , "\"")

txt <- imfill(50,50,val=1) %>% implot(text(20,20,"What"))
## Ascii only ^^^
## txt <- imfill(50,50,val=1) %>% implot(text(20,20,"集いし願いが、新たに輝く星となる\n光差す道となれ"))
## txt <- imfill(50,50,val=1) %>% implot(text(20,20,"集いし願い"))
## plot(txt, interp=FALSE)

g.chr <- function(chr) implot(imfill(50,50,val=1),text(25,25,chr,cex=5)) %>% grayscale %>% mean
g <- map_dbl(asc,g.chr)
n <- length(g)
## plot(1:n,sort(g),type="n",xlab="Order",ylab="Lightness")
## text(1:n,sort(g),asc[order(g)])


## One char per pix
##Sort the characters by increasing lightness
char <- asc[order(g)]
##Convert image to grayscale, resize, convert to data.frame
d <- grayscale(im) %>% imresize(.1)  %>% as.data.frame
##Quantise
d <- mutate(d,qv=cut_number(value,n) %>% as.integer)
##Assign a character to each quantised level
d <- mutate(d,char=char[qv])
##Plot
p <- ggplot(d,aes(x,y))+geom_text(aes(label=char),size=1)+scale_y_reverse()

#### One char per patch
##psize is the patch size in pixels (we'll use odd patch sizes for simplicity)
psize <- 5
##center of the patch
cen <- ceiling(psize/2)

##produces a grid of coordinates for the center of each patch
gr <- grayscale(im) %>% pixel.grid %>%
  filter((x %% psize)==cen,(y %% psize) == cen)

p <- plot(im,xlim=c(200,250),ylim=c(200,250))
with(gr,points(x,y,cex=1,col="red"))

ptch <- extract_patches(im,gr$x,gr$y,psize,psize)
syms <- 1:25

render <- function(sym) implot(imfill(psize,psize,val=1),points(cen,cen,pch=sym,cex=1)) %>% grayscale
ptch.c <- map(syms,render)
plot(render("o"),interp=FALSE)
                                        #Convert patches to a long matrix 
Pim <- map(ptch,as.vector) %>% do.call(rbind,.) 
Pc <- map(ptch.c,as.vector) %>% do.call(rbind,.)
nn <- nabor::knn(Pc,Pim,1)$nn.idx
mutate(gr,sym=syms[nn]) %$% plot(x,y,pch=sym,cex=.2,ylim=c(height(im),1))
