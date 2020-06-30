echo removing old pod and containers
podman pod rm -f bitcoin_pod

echo creating bitcoin pod
podman pod create --name bitcoin_pod -p 8332:8332 -p 50002:50002

echo creating tor container
podman run -d --pod bitcoin_pod --name tor_container tor

echo creating bitcoin container
podman run -d --pod bitcoin_pod --name bitcoin_container \
  -v ~/b_node_ssd/podman_volumes/b_node_home/_data:/root/.bitcoin bitcoin

#echo creating eps container
podman run -d --pod bitcoin_pod --name electrum_server_container \
  -v ~/b_node_ssd/podman_volumes/b_node_home/_data/:/root/.bitcoin/ electrum_server

#echo creating eps wallet in bitcoin core
podman exec bitcoin_container bitcoin-0.20.0/bin/bitcoin-cli createwallet electrumpersonalserver true
