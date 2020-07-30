echo creating bitcoin pod
podman pod create --name bitcoin_pod -p 8332:8332 -p 50002:50002

pushd tor
./run.sh
popd

pushd bitcoin
./run.sh
popd

pushd electrum_personal_server
./run.sh
popd
