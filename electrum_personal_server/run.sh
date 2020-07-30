echo creating electrum personal server container

# podman pod create --name bitcoin_pod -p 8332:8332 -p 50002:50002 &> /dev/null
# if (($? == 0)); then
#   echo "'bitcoin_pod' created"
# else
#   echo "'bitcoin_pod' exists"
# fi

podman run -d --pod bitcoin_pod --name electrum_server_container \
  -v ./eps-config.ini:/root/eps-config.ini \
  -v ~/bitcoin_data:/root/.bitcoin \
  -v /tmp:/tmp electrum_server
