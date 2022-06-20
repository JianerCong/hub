# conf
Some configuration files and scripts for my emacs.

This repository should be put in your `home` and should be named as the
`Templates` (Make sure you don't have one already). Do the following: 
    
    cd ~
    git clone https://github.com/JianerCong/conf.git ~/Templates/
    
This folder contains 
* Some tiny c++/c functions that I use.
* A folder named `.emacs-config` which contains some configurations that customize my emacs

## emacs configurations

The folder `.emacs-config`  holds some emacs-lisp `.el` files to source when you start your emacs.

If you are using spacemacs, you also do this(_Make sure you don't have a `.spacemacs` file in your home already._): 

    ln -s ~/Templates/.emacs-config/.spacemacs ~/.spacemacs

This makes the `.spacemacs` file available in your home. Alternatively, you can
just copy the `.spacemacs` file into your home.


