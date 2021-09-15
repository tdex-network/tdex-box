#!/bin/bash
### Run this on your local computer

case $OSTYPE in
darwin*) OS="darwin" ;;
linux-gnu*) OS="linux" ;;
*)
  echo "OS $OSTYPE not supported by the installation script"
  exit 1
  ;;
esac

case $(uname -m) in
armv7l) ARCH="arm" ;;
amd64) ARCH="amd64" ;;
x86_64) ARCH="amd64" ;;
*)
  echo "Architecture $ARCH not supported by the installation script"
  exit 1
  ;;
esac

#Get latest version
VERSION=$(curl --silent "https://api.github.com/repos/tdex-network/tdex-daemon/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')

TCLI=tdex-$VERSION-$OS-$ARCH 
URL="https://github.com/tdex-network/tdex-daemon/releases/download/$VERSION/$TCLI"
echo Downloading: $TCLI
wget $URL || curl -LJO $URL

chmod +x $TCLI 
sudo ln -s $PWD/$TCLI /usr/bin/tdex
/usr/bin/tdex --help