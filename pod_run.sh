# todo: add prompt to optionally call /pod_rm if it exists

echo creating bitcoin pod
podman pod create --name bitcoin_pod -p 8332:8332 -p 50002:50002

# todo test if this volume works on start/restart of container
# todo test if only 'control_auth_cookie' is required
echo creating tor container
podman run -d --pod bitcoin_pod --name tor_container \
  -v tor_cookie_ephemeral:/root/.tor tor

echo creating bitcoin container
podman run -d --pod bitcoin_pod --name bitcoin_container \
  -v ~/b_node_ssd/podman_volumes/b_node_home/_data:/root/.bitcoin \
  -v tor_cookie_ephemeral:/root/.tor tor
  # --volumes-from tor_container bitcoin

echo creating eps container
podman run -d --pod bitcoin_pod --name electrum_server_container \
  -v ~/b_node_ssd/podman_volumes/b_node_home/_data/.cookie:/root/.bitcoin/.cookie electrum_server
