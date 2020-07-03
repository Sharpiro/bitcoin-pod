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

You probably want to ensure that podman will save its data to an encryption portion of your disk.  If your entire disk is encrypted, then you can skip this.

The simplest way I've found to have podman create its data on a separate encrypted device is to use a symbolic link.

```sh
cp -rp ~/.local/share/containers ~/mounts/encrypted_drive
ln -s ~/mounts/encrypted_drive/containers ~/.local/share/containers
```

### Tor Prerequisites

* copy `torrc.sample` to `torrc`
* update `torrc` if you don't want the default tor configuration

### Bitcoin Prerequisites

* copy `bitcoin.conf.sample` to `bitcoin.conf`
* update `bitcoin.conf` if you don't want the default tor configuration

### Electrum Personal Server Prerequisites

### Setup config

* copy `config.ini_sample` to `config.ini`
* update `config.ini` with at least your master public keys

### Setup wallet

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

```sh
podman build -t tor -f tor.Dockerfile .
podman build -t bitcoin -f bitcoin.Dockerfile .
podman build -t electrum_server -f electrum_server.Dockerfile
```

These containers are intended to be ephemeral.  By default if you need to modify a configuration file, you will need to rebuild the images.  An alternative to this is to provide your configs as volume mounts to allow them to persist outside of the container.  Then they can be modified and the container would only need to be restarted.
