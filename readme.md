# Bitcoin Pod

The purpose is to setup a [bitcoin](https://github.com/bitcoin/bitcoin) full node with [electrum personal server](https://github.com/chris-belcher/electrum-personal-server) all configured to run behind [Tor](https://www.torproject.org/) by default, and all running inside rootless containers.

## Prerequisites

### Dependencies

* [podman](https://podman.io/getting-started/installation.html) version 1.9.3
  * currently only supports podman for "pods" support, but could be modified to use docker
* debian-based host
  * only tested successfully on debian-based hosts
  * on fedora there seems to be a bug with podman and volume mount permissions

### Encrypted disk (optional)

You probably want to ensure that podman will save its data to an encrypted portion of your disk.  If your entire disk is encrypted, then you can skip this.

The simplest way I've found to have podman create its data on a separate encrypted device is to use a symbolic link.

```sh
cp -rp ~/.local/share/containers ~/my_mounts/my_encrypted_drive
ln -s ~/my_mounts/my_encrypted_drive/containers ~/.local/share/containers
```

### Tor Prerequisites

* copy `torrc.sample` to `torrc`
* update `torrc` if you don't want the default tor configuration

### Bitcoin Prerequisites

* copy `bitcoin.conf.sample` to `bitcoin.conf`
* update `bitcoin.conf` if you don't want the default bitcoin configuration

### Electrum Personal Server Prerequisites

#### Setup config

* copy `config.ini_sample` to `config.ini`
* update `config.ini` with at least your master public keys

#### Setup wallet

EPS recommends creating an EPS specific wallet in your full node.

The following can be executed on your running bitcoin full node container

```sh
podman exec bitcoin_container bitcoin-0.20.0/bin/bitcoin-cli createwallet electrumpersonalserver true
```

Your EPS `config.ini` will need to be updated with the correct wallet name or empty if you intend to use your bitcoin node's default wallet

```properties
wallet_filename = electrumpersonalserver
```

## Building Images

Once all configurations have been setup, the following can be executed individually or all together depending on your setup

### tor

```sh
podman build -t tor -f tor.Dockerfile .
```

### bitcoin

Setup `bitcoin_arch` to choose your machine's architecture.
With no argument, arm-32 will be the default.

The following are currently supported:

* bitcoin-0.20.0-arm-linux-gnueabihf.tar.gz
* bitcoin-0.20.0-x86_64-linux-gnu.tar.gz

```sh
podman build -t bitcoin -f bitcoin.Dockerfile --build-arg $bitcoin_arch
```

### electrum personal server

```sh
podman build -t electrum_server -f electrum_server.Dockerfile
```

These images and containers are intended to be ephemeral.  By default if you need to modify a configuration file, you will need to rebuild the images.  An alternative to this is to provide your configs as volume mounts to allow them to persist outside of the container.  Then they can be modified and the container would only need to be restarted.

## Running Containers

### create pod

```sh
podman pod create --name bitcoin_pod -p 8332:8332 -p 50002:50002
```

### create tor container

```sh
podman run -d --pod bitcoin_pod --name tor_container -v /root/.tor tor
```

### create bitcoin container

```sh
podman run -d --pod bitcoin_pod --name bitcoin_container \
  -v ~/bitcoin_data:/root/.bitcoin \
  --volumes-from tor_container bitcoin
```

### create Electrum Personal Server container

```sh
podman run -d --pod bitcoin_pod --name electrum_server_container \
  -v ~/bitcoin_data/.cookie:/root/.bitcoin/.cookie electrum_server
```

* currently EPS needs to be run twice to get it working.
  * the first run does the imports of addresses and then exits
  * the second run actually starts the server
* re-scanning
  * if you need to load in historical transactions you will need to run the container with a one-time alternative command
    * `.local/bin/electrum-personal-server --rescan config.ini`

## Logging

```sh
# tor
/tmp/tor
# bitcoin
bitcoin_data/debug.log
#electrum personal server
/tmp/electrumpersonalserver.log
```

## Todo/Limitations

* refactor readme to be grouped by app
* app versions hard-coded
* add prompt to `pod_run.sh` to optionally call `pod_rm.sh` if it already exists

## FAQ

* "Requested wallet does not exist or is not loaded. Wallet related RPC call failed, possibly the bitcoin node was compiled with the disable wallet flag"
  * run the following on your full node:
  * `bitcoin-cli loadwallet electrumpersonalserver`
  * if the above doesn't work, your node's wallet may be corrupt and will need to be re-created, and then re-scanned.
