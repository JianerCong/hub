# 1. add the public key to allow access (🦜: let me in)
pk='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGhyRIycklSutg/Y8XsC6sMipaPXVfl7PpwEwZNA6h5t me@mypc'
echo $pk >> /home/me/.ssh/authorized_keys

# 2. set the http_proxy in /etc/environment --------------------------------------------------
sudo bash -c "echo 'http_proxy=http://[fec0::1]:7890' >> /etc/environment"
sudo bash -c "echo 'https_proxy=http://[fec0::1]:7890' >> /etc/environment"
sudo bash -c "echo 'no_proxy=localhost' >> /etc/environment"

# 🦜 : see conf-ipv6.sh


# 🦜 : remember to add the
#     - 'IP-CIDR6,fec1::/10,DIRECT'
# in your proxy rule

# 3. set the apt source
x="# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse

# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
"
f=/etc/apt/sources.list
sudo bash -c "echo \"$x\" > $f"

# 4. set the pip mirror 
x='[global]
index-url = http://pip.example.org/simple'
f=/root/.pydistutils.cfg
sudo bash -c "echo \"$x\" > $f"
echo "\nResult---------------\n"
sudo cat $f

x='[easy_install]
index_url = https://pip.example.org/simple'
f=/root/.pydistutils.cfg
sudo bash -c "echo \"$x\" > $f"
echo "\nResult---------------\n"
sudo cat $f

# 5. set the user variable in /etc/openstack_deploy/user_variables.yml
m1=https://mirrors.tuna.tsinghua.edu.cn/ubuntu/
m2=https://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/
m3=https://mirrors.tuna.tsinghua.edu.cn/debian/
x="
lxc_container_cache_files_from_host:
  - /etc/pip.conf
  - /root/.pydistutils.cfg
lxc_ubuntu_mirror: \"{{ (ansible_facts['architecture'] == 'x86_64') | ternary('$m1', '$m2') }}\"
lxc_apt_mirror: \"{{ (ansible_facts['distribution'] == 'Ubuntu') | ternary(lxc_ubuntu_mirror, '$m3') }}\" 
"
f=/etc/openstack_deploy/user_variables.yml
sudo mkdir /etc/openstack_deploy
sudo bash -c "echo '$x' > $f"
echo "\nResult---------------\n"
sudo cat $f


# 6. update and upgrade
sudo apt update
sudo apt upgrade
