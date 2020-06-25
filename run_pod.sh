podman pod rm -f bitcoin_pod
podman pod create --name bitcoin_pod -p 8332:8332
podman run -d --pod bitcoin_pod --name tor_container tor
podman run -d --pod bitcoin_pod --name bitcoin_container -v b_node_home:/root/.bitcoin bitcoin_runner
