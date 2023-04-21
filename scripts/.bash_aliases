alias l="pwd & ls"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
# shutdown in 1min
alias bye="sudo shutdown -h +1"

# Use nano -L (--nonewlines to edit pat1.txt and tap2.txt)
alias cppat="cat $HOME/Templates/scripts/pat1.txt  $HOME/Templates/scripts/tap2.txt | xclip -i -selection clipboard"
alias cppat2="paste -d'\0' $HOME/Templates/scripts/pat1.txt $HOME/Templates/scripts/tap2.txt | xclip -i -selection clipboard"

alias cpmail="echo congjianer@xinhuaxia.com | xclip -i -selection clipboard"

alias g="git log --oneline --decorate --all -n"
alias ga="git add -A && git status"
alias jpp=". ~/Templates/lrn/cpp/ygo/json/comp.sh"
alias jcc=". ~/Templates/lrn/c/comp.sh"
alias got=". ~/Templates/scripts/got.sh"
alias tses=". /home/me/Templates/scripts/ses.sh"
alias gpsh=". ~/Templates/scripts/gpsh.sh"
alias pyenv=". ~/work/lcode/myenv/bin/activate"
alias cb=". ~/Templates/scripts/cmakebuild.sh"

. ~/Templates/scripts/my-prompt.sh

export PATH="/usr/local/blender-3.5.0-linux-x64/:/usr/local/texlive/2022/bin/x86_64-linux:$PATH"
export MANPATH="/usr/local/texlive/2022/texmf-dist/doc/man:$MANPATH"
#  Local Variables:
#  mode: shell-script
#  End:
