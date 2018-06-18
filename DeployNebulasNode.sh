#!/bin/sh

### Supported OS: Ubuntu 16.04 


## Set environment paths for GO
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go

## create GO Folder
mkdir -p $GOPATH/src

### Update System and install dependencies
apt-get update
apt-get -y install build-essential libgflags-dev libsnappy-dev zlib1g-dev libbz2-dev liblz4-dev libzstd-dev git make automake build-essential cmake curl

### Install go
echo "########################"
echo "Installing go"
echo "########################"
cd ~
wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.10.3.linux-amd64.tar.gz
chmod +x /usr/local/go/bin/go
rm go1.10.3.linux-amd64.tar.gz

### Install RocksDB
echo "########################"
echo "Installing RocksDB"
echo "########################"
cd ~
git clone https://github.com/facebook/rocksdb.git
cd rocksdb && make shared_lib && make install-shared

### Install dep
echo "########################"
echo "Installing dep"
echo "########################"
cd /usr/local/bin/
wget https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64
ln -s dep-linux-amd64 dep
chmod +x /usr/local/bin/*


### Install Nebulas
echo "########################"
echo "Installing Nebulas"
echo "########################"
cd ~
mkdir -p $GOPATH/src/github.com/nebulasio
cd $GOPATH/src/github.com/nebulasio
git clone https://github.com/nebulasio/go-nebulas.git
cd go-nebulas
git checkout master
make dep
make deploy-v8
make build
mkdir conf/local
cd conf/local
wget https://raw.githubusercontent.com/mirei83/Nebulas/master/LocalTestNet/local/config.conf
wget https://raw.githubusercontent.com/mirei83/Nebulas/master/LocalTestNet/local/genesis.conf
wget https://raw.githubusercontent.com/mirei83/Nebulas/master/LocalTestNet/local/miner.conf
cd ~


### Create StartUp-Script

echo "########################"
echo "Creating Startup Miner Script"
echo "########################"
cd
echo '#!/bin/bash' >> ./start-nebulas-LocalNode.sh
echo "cd $GOPATH/src/github.com/nebulasio/go-nebulas"  >> ./start-nebulas-LocalNode.sh
echo "$GOPATH/src/github.com/nebulasio/go-nebulas/neb -c $GOPATH/src/github.com/nebulasio/go-nebulas/conf/local/config.conf > /dev/null 2>&1 & " >> ./start-nebulas-LocalNode.sh
echo "$GOPATH/src/github.com/nebulasio/go-nebulas/neb -c $GOPATH/src/github.com/nebulasio/go-nebulas/conf/local/miner.conf > /dev/null 2>&1 & " >> ./start-nebulas-LocalNode.sh
chmod +x ./start-nebulas-LocalNode.sh

