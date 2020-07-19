echo stopping bitcoin_pod containers
podman pod stop bitcoin_pod

echo removing bitcoin_pod containers
podman pod rm bitcoin_pod

echo removing tor_cookie_ephemeral volume
podman volume rm tor_cookie_ephemeral
