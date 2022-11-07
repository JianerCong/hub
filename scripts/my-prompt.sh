dayrmd_dir="/home/me/Templates/scripts/dayrmd"
python3 $dayrmd_dir/dayrmd.py
msg=$(cat $dayrmd_dir/msg.txt)
s_green="\e[0;32m"
s_blue="\e[0;36m"
s_gray="\e[0;37m"
s_nor="\e[0m"
# • 30 – Black
# • 31 – Red
# • 32 – Green
# • 33 – Brown
# • 34 – Blue
# • 35 – Purple
# • 36 – Cyan
# • 37 – Light gray

# It seems like the the new prompt should start in a new line
# export PS1="\e[0;32m [$msg] \w \e[0m \$\n"
export PS1="\e[0;32m [$msg] \w\e[0m \n"
# ${s_gray}\nNow it's \D{%Ec} $s_green\n    \u@\h \w${s_nor}\n"

# https://en.cppreference.com/w/c/chrono/strftime
# The last char of $PS1 should not be a control char (don't know why)
