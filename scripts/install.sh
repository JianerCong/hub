
x = "node-v16.9.0-linux-x64"
sudo tar -C /usr/local/ -zxf "$x.tar.gz"
echo "export PATH=\"/usr/local/$x/bin:$PATH\"" >> ~/.profile
ls "/usr/local/$x/"
# set PATH so it includes user's private bin if it exists
if [ -d "/usr/local/$x" ] ; then PATH="🐸 Okay, bin dir exits."
fi
