# Bitcoin Pod

The purpose of bitcoin_pod is to setup a [bitcoin](https://github.com/bitcoin/bitcoin) full node configured to run behind [Tor](https://www.torproject.org/) by default, running inside rootless containers.

All containers are intended to be ephemeral.
By default if you need to modify a configuration file, you will then need to restart that container for the change to take affect.

## Prerequisites

### Dependencies

* [podman](https://podman.io/getting-started/installation.html) (tested with v2.0.3)
  * currently only supports podman for "pods" support, but could be modified to use docker
* debian-based host
  * only tested successfully on raspbian hosts

### Remote access via ssh tunnels (optional)

if you want to access exposed bitcoin_pod ports from a local machine, but your containers are running on a remote server, a good way to accomplish this is by setting setup a secure connection with a background SSH tunnel.
You can then access bitcoin_pod exposed ports as if the container host was running locally.

```sh
ssh -fNT -L localhost:{port}:{host-or-ip}:{port} {host-or-ip}
```

### Encrypted disk (optional)

You probably want to ensure that podman will save its data to an encrypted portion of your disk.
If your entire disk is encrypted, then you can skip this.

The simplest way I've found to have podman create its data on a separate encrypted device is to use a symbolic link.

```sh
cp -rp ~/.local/share/containers ~/my_mounts/my_encrypted_drive
ln -s ~/my_mounts/my_encrypted_drive/containers ~/.local/share/containers
```

## Create Pod

Create the bitcoin_pod to house the various containers and allow them to selectively share resources.

* 8332 is default bitcoin RPC server
* 50002 is default electrum personal server

Add or remove ports exposed to the host as needed.
The below command is the default.

```sh
podman pod create --name bitcoin_pod -p 8332:8332 -p 50002:50002
```

## Logs

Default log volume mounts have been setup so that logs can be viewed from the host machine and will persist between container restarts and deletions.
See individual `Logs` sections for details.

## Tor

### Prerequisites

* copy `torrc.sample` to `torrc`
* update `torrc` if you don't want the default tor configuration

### Build

```sh
podman build -t tor -f tor.Dockerfile
```

### Run

```sh
podman run -d --pod bitcoin_pod --name tor_container \
  -v ./torrc:/root/torrc \
  -v tor_cookie_ephemeral:/root/.tor \
  -v /tmp/tor:/var/log/tor tor
```

### Logs

```sh
/tmp/tor_notices.log
/tmp/tor_debug.log
```

## Bitcoin

### Prerequisites

* copy `bitcoin.conf.sample` to `bitcoin.conf`
* update `bitcoin.conf` if you don't want the default bitcoin configuration

### Build

Setup `bitcoin_arch` to choose your machine's architecture.
With no argument, arm-32 will be the default.

The following are currently supported:

* `bitcoin-0.20.0-arm-linux-gnueabihf.tar.gz`
* `bitcoin-0.20.0-x86_64-linux-gnu.tar.gz`

```sh
podman build -t bitcoin -f bitcoin.Dockerfile --build-arg $bitcoin_arch
```

### Run

```sh
podman run -d --pod bitcoin_pod --name bitcoin_container \
  -v ./bitcoin.conf:/root/bitcoin.conf \
  -v ~/bitcoin_data:/root/.bitcoin \
  -v tor_cookie_ephemeral:/root/.tor bitcoin
```

### Logs

```sh
bitcoin_data/debug.log
```

## Electrum Personal Server

### Prerequisites

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

### Build

```sh
podman build -t electrum_server -f electrum_server.Dockerfile
```

### Run

```sh
podman run -d --pod bitcoin_pod --name electrum_server_container \
  -v ./eps-config.ini:/root/eps-config.ini \
  -v ~/bitcoin_data:/root/.bitcoin \
  -v /tmp:/tmp electrum_server
```

* currently EPS needs to be run twice to get it working.
  * the first run does the imports of addresses and then exits
  * the second run actually starts the server
* re-scanning
  * if you need to load in historical transactions you will need to run the container with a one-time alternative command
    * `.local/bin/electrum-personal-server --rescan config.ini`

### Logs

```sh
/tmp/electrumpersonalserver.log
```

## FAQ

* "Requested wallet does not exist or is not loaded.  Wallet related RPC call failed, possibly the bitcoin node was compiled with the disable wallet flag"
  * run the following on your full node:
  * `bitcoin-cli loadwallet electrumpersonalserver`
  * if the above doesn't work, your node's wallet may be corrupt and will need to be re-created, and then re-scanned.

## Todo/Limitations

* probe no scripts, readme copy/paste only
* app versions are hard-coded
