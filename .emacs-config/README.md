# My Emacs Configuration files
This repository contains the some scripts that I used to customize my Emacs.

This folder should be put under the `.emacs.d`. 


## my-buffer-init.el
Sometimes I found it useful to have some *Project-wise configuration*. For
example, inside `folder1` ,I am editing `hi.txt`, and `hi2.txt`, and I just want
some variable definitions (perhaps `addrev` definitions) just for `hi.txt` or
all `.txt` file. This file defines a function `load-buffer-init-file` and binds
it to `<f5>` to help us do it. 

Suppose the current buffer is `hi.txt`. The function will search for the
following `.el` file and load it when it find it:

1. `hi.txt.el` : This file (if exits) should hold the scripts just for `hi.txt`
2. `./txt.el` : This file (if exits) should hold the scripts for all `.txt` files
3. `../txt.el`: Same as above

In short, when we are editing `hi.txt`, and need some configuration, just create
the `hi.txt.el`, put int the script, go back to `hi.txt` and press `f5`.


## my-abbrev-and-expand.el
This file tweaks the default expand behavior. and also defined the
`global-abbrev-table` that allows us to add abbrev definition manually.

## my-default.el 
This file set some common variables and binds some keys. In particular, `f6` to
toggle the `whitespace-mode` and `f8` to open a shell.

## my-hooks.el
This file add some common hooks, such as the `electric-pair-mode` to all Program
mode.

## my-org-config.el
This file add configurations for the `org-mode`. Specifically, it allows
`emacs-lisp` to be run within code block without much worries.

## my-packages.el
This file requests the packages needed. 
## myy-<files>
Files whose name start with `myy` are "internal files" used by `my` files. These
files are `required` by `my` files.
# How to use ?
Each `.el` file will provide a feature same as its file name. For example,
`my-buffer-init.el` has `(provide `my-buffer-init)`. So in the `init` file add 

```
  (add-to-list 'load-path "~/.emacs.d/emacs-config")
  
;; Then require the features accordingly, with
  (require 'my-hooks)
  (require 'my-default)
  (require 'my-buffer-init)
  (require 'my-modes)

  ...
```

If you are using spacemacs, then, in the `.spacemacs` file, these two lines should be added under the `user-load ` section. 

```
  (add-to-list 'load-path "~/.emacs.d/emacs-config")
  (require 'my-hooks)
```

And the following can be added to the `user-config` section:

```
  (require 'my-default)
  (require 'my-buffer-init)
  (require 'my-modes)
```
