ansible-playbook -i inv.yml pb.yml


ansible -i inv.yml all \
        -m ansible.builtin.reboot -a '{"msg": "rebooting the host"}' \
        --become --become-password-file ~/secret/my-pswd.txt


