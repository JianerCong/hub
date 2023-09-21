# get the ethernet interface (should starts with 'en')
x=$(ip -br a | grep '^en' | awk '{print $1}')
# configure the static ipv6 address and store that in /etc/network/interfaces
a1=fec0::2
a0=fec0::1
x="[Match]
Name=$x

[Network]
Gateway=$a0
DNS=$a0

[Address]
Address=$a1/64

[Route]
Destination=$a0/64
Scope=link
"
f=/etc/systemd/network/my-ipv6.network

# back up and append the file
sudo bash -c "echo \"$x\" > $f"
