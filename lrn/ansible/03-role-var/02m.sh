# 🦜 : Here we see how to overwrite vars.

ansible-playbook -i ../inv-me.yml p.yml # x-in-play

ansible-playbook -i ../inv-me.yml p2.yml # x-in-default

ansible-playbook -i ../inv-me.yml p.yml -e "x=x-in-cmd" # x-in-cmd
