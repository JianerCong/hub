# get the ethernet interface (should starts with 'en')
x=$(ip -br a | grep '^en' | awk '{print $1}')
# configure the static ipv6 address in /etc/netplan/10-my-ip.yml
a1=fec0::2/64
x="
network:
  version: 2
  ethernets:
    $x:
      dhcp4: false
      dhcp6: false
      addresses: ['$a1']
"
f=/etc/netplan/10-my-ip.yml

# back up and append the file
sudo bash -c "echo \"$x\" > $f"
