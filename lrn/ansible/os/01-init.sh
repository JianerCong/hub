# 1. add the public key to allow access (🦜: let me in)
pk='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGhyRIycklSutg/Y8XsC6sMipaPXVfl7PpwEwZNA6h5t me@mypc'
echo $pk >> /home/me/.ssh/authorized_keys

# 2. set the http_proxy in /etc/environment --------------------------------------------------
sudo bash -c "echo 'http_proxy=http://[fec0::1]:7890' >> /etc/environment"
sudo bash -c "echo 'https_proxy=http://[fec0::1]:7890' >> /etc/environment"
sudo bash -c "echo 'no_proxy=localhost' >> /etc/environment"

# 🦜 : see conf-ipv6.sh


