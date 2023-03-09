#!/usr/bin/env sh

set -e
version="1.6.3-dev"
echo "Installing kubectl-sniff v${version} ..."

unameOut="$(uname -s)"

case "${unameOut}" in
    Linux*)     os=linux;;
    Darwin*)    os=darwin;;
#    CYGWIN*)    os=cygwin;;
    MINGW*)     os=windows;;
    *)          os="UNKNOWN:${unameOut}"
esac

arch=$(uname -m)

if [ "$arch" = "x86_64" ]; then
  arch="amd64"
else
  arch="arm64"
fi

url="https://github.com/Noksa/ksniff-binaries/releases/download/${version}/ksniff_${version}_${os}_${arch}.tar.gz"
if [ "$url" = "" ]; then
  echo "Unsupported OS / architecture: ${os}_${arch}"
  exit 1
fi

filename="ksniff_${version}.tar.gz"


if [ -z "$(command -v tar)" ]; then
  echo "tar is required, install it first"
  exit 1
fi

# Download archive
if [ -n "$(command -v curl)" ]; then
  curl -sSL "$url" -o "$filename"
elif [ -n "$(command -v wget)" ]; then
  wget -q "$url" -o "$filename"
else
  echo "Need curl or wget"
  exit 1
fi

trap 'rm -rf $filename' EXIT

# Install bin
sudo mkdir -p /usr/local/bin && sudo tar xzvf "$filename" -C /usr/local/bin > /dev/null && rm -f "$filename"

if [ "$?" != "0" ]; then
  echo "an error has occured"
  exit 1
fi

echo "ksniff ${version} has been installed"
