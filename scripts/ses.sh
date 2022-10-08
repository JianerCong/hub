
# new-session -c '/home/me/work/ses/dia' -s 'my-session'
# attach -t 'my-session'

cd /home/me/work/ses/dia/
tmux rename-window 'this-win'
tmux new-window -n 'work'
emacs d3.tex &
tmux new-window -an 'view'
firefox m.pdf &
tmux new-window -an 'lrn' -c '/home/me/Templates/lrn'
tmux kill-window -t 'this-win'
