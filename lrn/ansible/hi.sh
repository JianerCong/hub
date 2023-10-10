# list
inv=my-first-inventory.yaml
ansible-inventory -i $inv --list

# ping
ansible my_vms -i $inv -m ping
# 🦜 : We got

# vm01 | SUCCESS => {
#         "ansible_facts": {
#             "discovered_interpreter_python": "/usr/bin/python3"
#         },
#         "changed": false,
#         "ping": "pong"
#     }
# vm02 | SUCCESS => {
#         "ansible_facts": {
#             "discovered_interpreter_python": "/usr/bin/python3"
#         },
#         "changed": false,
#         "ping": "pong"
#     }
ansible my_vms -i my-bad-inventory.yaml -m ping

# vm02 | SUCCESS => {
#         "ansible_facts": {
#             "discovered_interpreter_python": "/usr/bin/python3"
#         },
#         "changed": false,
#         "ping": "pong"
#     }
# vm01 | SUCCESS => {
#         "ansible_facts": {
#             "discovered_interpreter_python": "/usr/bin/python3"
#         },
#         "changed": false,
#         "ping": "pong"
#     }
# bad_vm | UNREACHABLE! => {
#         "changed": false,
#         "msg": "Failed to connect to the host via ssh: ssh: connect to host 10.65.108.250 port 22: No route to host",
#         "unreachable": true
#     }

inv=my-first-inventory.yaml
pb=my-first-playbook.yaml
ansible-playbook -i $inv $pb


# 🦜 : It turns out ourselve can also be a manged node.

inv=inv-nodes-and-me.yaml
pb=my-first-playbook.yaml
ansible-playbook -i $inv $pb
