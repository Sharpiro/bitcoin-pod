# tor
podman build -t tor -f tor.Dockerfile

# bitcoin
bitcoin_arch=bitcoin_tarball=bitcoin-0.20.0-arm-linux-gnueabihf.tar.gz
podman build -t bitcoin -f bitcoin.Dockerfile --build-arg $bitcoin_arch
  
# electrum personal server
podman build -t electrum_server -f electrum_server.Dockerfile
