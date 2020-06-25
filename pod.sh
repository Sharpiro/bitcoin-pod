podman build -t tor -f Dockerfile.tor .
podman build -t bitcoin_runner -f Dockerfile.bitcoin .

podman pod create --name bitcoin_pod -p 8332:8332
podman run -d --pod bitcoin_pod tor
podman run -d --pod bitcoin_pod bitcoin_runner
