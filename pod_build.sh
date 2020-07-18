podman build -t tor -f tor.Dockerfile .
podman build -t bitcoin -f bitcoin.Dockerfile .
podman build -t electrum_server -f electrum_server.Dockerfile
