# ping and reboot
ansible-playbook -i inv.yml p-hi.yml --become --become-pass-file ~/secret/my-pswd.txt


# reboot all
ansible -i inv.yml all \
        -m ansible.builtin.reboot -a '{"msg": "rebooting the host"}' \
        --become --become-password-file ~/secret/my-pswd.txt


