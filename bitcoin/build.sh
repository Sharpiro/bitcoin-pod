echo building bitcoin image
bitcoin_arch=bitcoin_tarball=bitcoin-0.20.0-arm-linux-gnueabihf.tar.gz
podman build -t bitcoin -f bitcoin.Dockerfile --build-arg $bitcoin_arch
