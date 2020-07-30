pushd tor
./build.sh
popd

pushd bitcoin
./build.sh
popd
  
pushd electrum_personal_server
./build.sh
popd
