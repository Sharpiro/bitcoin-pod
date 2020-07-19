echo creating bitcoin pod
podman pod create --name bitcoin_pod -p 8332:8332 -p 50002:50002

echo creating tor container
podman run -d --pod bitcoin_pod --name tor_container \
  -v ./config/torrc:/root/torrc \
  -v tor_cookie_ephemeral:/root/.tor \
  -v /tmp/tor:/var/log/tor tor

echo creating bitcoin container
podman run -d --pod bitcoin_pod --name bitcoin_container \
  -v ~/b_node_ssd/podman_volumes/b_node_home/_data:/root/.bitcoin \
  -v tor_cookie_ephemeral:/root/.tor bitcoin

echo creating eps container
podman run -d --pod bitcoin_pod --name electrum_server_container \
  -v ~/b_node_ssd/podman_volumes/b_node_home/_data:/root/.bitcoin \
  -v /tmp:/tmp electrum_server
