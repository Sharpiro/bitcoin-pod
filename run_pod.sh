podman pod rm -f bitcoin_pod
podman pod create --name bitcoin_pod -p 8332:8332
podman run -d --pod bitcoin_pod tor
podman run -d --pod bitcoin_pod bitcoin_runner
