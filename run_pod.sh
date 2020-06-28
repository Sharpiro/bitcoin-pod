podman pod rm -f bitcoin_pod
podman pod create --name bitcoin_pod -p 8332:8332
podman run -d --pod bitcoin_pod --name tor_container tor
podman run -d --pod bitcoin_pod --name bitcoin_container \
  -v ~/b_node_ssd/podman_volumes/b_node_home/_data:/root/.bitcoin bitcoin
podman exec bitcoin_container bitcoin-0.20.0/bin/bitcoin-cli createwallet electrumpersonalserver true
podman run -d --pod bitcoin_pod --name electrum_server_container \
  -v ~/b_node_ssd/podman_volumes/b_node_home/_data/:/root/.bitcoin/ electrum_server
