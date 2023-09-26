library(brew)

x <- 456
## open the input file
fin <- file('brew-in.txt', 'r')
## open the output file
fout <- file('brew-out.txt', 'w')
brew(file=fin,
     output=fout)

## close the files
close(fin)
close(fout)


## --------------------------------------------------
## 🦜 : Try inline:

brew(text='Here is <%= c(1,2,3) %>')
