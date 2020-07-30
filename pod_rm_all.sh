echo removing bitcoin_pod containers
podman pod rm -f bitcoin_pod

echo removing tor_cookie_ephemeral volume
podman volume rm tor_cookie_ephemeral
