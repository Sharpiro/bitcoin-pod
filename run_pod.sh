echo removing old pod and containers
#podman rm electrum_server_container
podman rm bitcoin_container
podman rm -v tor_container
podman pod rm bitcoin_pod

echo creating bitcoin pod
podman pod create --name bitcoin_pod -p 8332:8332 -p 50002:50002

echo creating tor container
podman run -d --pod bitcoin_pod --name tor_container \
  -v /root/.tor tor

echo creating bitcoin container
podman run -d --pod bitcoin_pod --name bitcoin_container \
  -v ~/b_node_ssd/podman_volumes/b_node_home/_data:/root/.bitcoin \
  --volumes-from tor_container bitcoin

#echo creating eps container
#podman run -d --pod bitcoin_pod --name electrum_server_container \
#  -v ~/b_node_ssd/podman_volumes/b_node_home/_data/:/root/.bitcoin/.cookie electrum_server

#echo creating eps wallet in bitcoin core
#podman exec bitcoin_container bitcoin-0.20.0/bin/bitcoin-cli createwallet electrumpersonalserver true
