# echo bitcoin_container
# podman rm electrum_server_container

# echo bitcoin_container
# podman rm bitcoin_container

# echo bitcoin_contor_containertainer
# podman rm -v tor_container

echo stopping bitcoin_pod containers
podman pod stop bitcoin_pod

echo removing bitcoin_pod containers
podman pod rm bitcoin_pod

echo removing tor_cookie_ephemeral volume
podman volume rm tor_cookie_ephemeral
