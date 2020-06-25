podman build -t tor -f tor.Dockerfile .
podman build -t bitcoin_runner -f bitcoin.Dockerfile .

podman pod create --name bitcoin_pod -p 8332:8332
podman run -d --pod bitcoin_pod tor
podman run -d --pod bitcoin_pod bitcoin_runner
