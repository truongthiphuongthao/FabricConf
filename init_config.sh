apt install curl
set -x

mkdir -p ~/go
echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
echo 'export PATH=$GOROOT/bin:$PATH' >> ~/.bashrc
echo 'export GOPATH=~/go/' >> ~/.bashrc
set +x

echo 'Installing nvm ...'
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

echo 'Use nvm to install node 12.15'
~/.nvm/nvm.sh install 12.15

CURR=$PWD
cd ~/
curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.0.1 1.4.6 0.4.18
cp -r $CURR ~/fabric-samples/
set -x
echo 'export PATH=~/fabric-samples/bin:$PATH' >> ~/.bashrc # where peer, cryptotxgen are located
set +x
# now, exit the current terminal and then open new one at dir: ~/fabric-samples/FabricConf

