echo creating bitcoin container

# podman pod create --name bitcoin_pod -p 8332:8332 -p 50002:50002 &> /dev/null
# if (($? == 0)); then
#   echo "'bitcoin_pod' created"
# else
#   echo "'bitcoin_pod' exists"
# fi

podman run -d --pod bitcoin_pod --name bitcoin_container \
  -v ./bitcoin.conf:/root/bitcoin.conf \
  -v ~/bitcoin_data:/root/.bitcoin \
  -v tor_cookie_ephemeral:/root/.tor bitcoin
