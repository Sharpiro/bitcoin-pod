# Bitcoin Pod

The purpose of bitcoin_pod is to setup a [bitcoin](https://github.com/bitcoin/bitcoin) full node, configured to run behind [Tor](https://www.torproject.org/), managed by [Electrum Personal Server](https://github.com/chris-belcher/electrum-personal-server), all while running inside rootless containers.

## Dependencies

* docker
* podman
* Ubuntu
  * tested on 21.04
  * may work with other distros

## Prerequisites

This setup can be greatly simplified by not using an external encrypted disk and rootless containers.

* copy `.env.sample` to `.env`

## Tor

### Application Config

* copy `tor/torrc.sample.conf` to `tor/torrc.conf`

## Bitcoin

### Application Config

* copy `bitcoin/bitcoin.sample.conf` to `bitcoin/bitcoin.conf`

### Environment Variables

update `.env` file.

* BITCOIN_DATA_ROOT
  * path to bitcoin data directory
* BITCOIN_VERSION
  * version to install
* BITCOIN_PLATFORM
  * target platform
  * examples
    * aarch64-linux-gnu
    * arm-linux-gnueabihf
    * x86_64-linux-gnu

## Electrum Personal Server (EPS)

### Application Config

* copy `electrum_personal_server/eps-config.sample.ini` to `electrum_personal_server/eps-config.ini`
* update `eps-config.ini` with your master public key(s) in the `[master-public-keys]` section

### Environment Variables

update `.env` file.

* EPS_VERSION
  * version to install

### Create wallet (optional)

EPS recommends creating an EPS specific wallet in your full node if you haven't already created one.

The following can be executed on your running bitcoin full node container:

```sh
docker-compose exec bitcoin bitcoin/bin/bitcoin-cli createwallet electrumpersonalserver true
```

### Rescan wallet (optional)

if you need to load in historical transactions you will need to run the container with a one-time command with the blockheight of your earliest transaction.

Run EPS' rescan script which determines blockheight based upon date input.
Bitcoin should already be running, see `Run` section below.

```sh
docker-compose --profile bitcoin run --rm eps .local/bin/electrum-personal-server --rescan eps-config.ini
```

## Run

### Run Tor profile

Run Tor only.

```sh
docker-compose --profile tor up --build -d
```

### Run Bitcoin profile

Run Bitcoin and its dependencies.

```sh
docker-compose --profile bitcoin up --build -d
```

### Run Electrum Personal Server profile

Run Electrum Personal Server and its dependencies.

```sh
docker-compose --profile eps up --build -d
```

## Optional configurations

### Remote access via ssh tunnels

if you want to access exposed bitcoin_pod ports from a local machine, but your containers are hosted on a remote server, a good way to accomplish this is by setting setup a secure connection with a background SSH tunnel.
You can then access bitcoin_pod exposed ports as if the container host was running locally.

Run the following on the local machine:

```sh
ssh -fNT -L localhost:{port}:localhost:{port} {ssh-name-or-host-or-ip}
```

### Encrypted disk

If your entire disk is encrypted, then you can skip this.
You probably want to ensure that podman will save its data to an encrypted portion of your disk.

#### Setup folders and links

```sh
# setup mount
mkdir ~/mnt/encrypted_drive
mount /dev/mapper/{encrypted_drive} ~/mnt/encrypted_drive

# setup encrypted bitcoin dirs and permissions
mkdir ~/mnt/encrypted_drive/bitcoin_node
git clone https://{host}/bitcoin-pod.git \
  ~/mnt/encrypted_drive/bitcoin_node/bitcoin-pod
mkdir ~/mnt/encrypted_drive/bitcoin_node/data
sudo chmod -R 750 ~/mnt/encrypted_drive/bitcoin_node/data
sudo chown -R .$USER ~/mnt/encrypted_drive/bitcoin_node/data
podman unshare chown -R 2000 ~/mnt/encrypted_drive/bitcoin_node/data

# force docker daemon to fail when encrypted disk is unmounted
mkdir ~/mnt/encrypted_drive/docker_root
ln -s $HOME/mnt/encrypted_drive/docker_root $HOME/.encrypted_docker_root
```

#### Configure daemon

rootful: `/etc/docker/daemon.json`

rootless: `~/.config/docker/daemon.json`

```json
{
  "data-root": "/home/{{user}}/.encrypted_docker_root"
}
```

## FAQ

* Why am I getting EPS error "Requested wallet does not exist or is not loaded.  Wallet related RPC call failed, possibly the bitcoin node was compiled with the disable wallet flag"?
  * see bitcoin configuration file for example on how to auto load wallets
  * manually load wallet
    * run the following on your full node:
      * `docker-compose exec bitcoin bitcoin/bin/bitcoin-cli loadwallet electrumpersonalserver`
    * if the above doesn't work, your node's wallet may be corrupt and may need to be re-created, and then re-scanned.

## Todo/Limitations

* using docker instead of podman means way more networking headaches
* if podman supports latest docker-compose, may want to use it
  * didn't support `--profile` option
  * returned container errors sometimes

## container platform comparison

* docker
  * pros
    * still seems more robust
  * cons
* podman
  * pros
    * gain "pods" feature which would remove some networking warnings and awkwardness
    * gain kubernetes feature
    * better rootless tooling like `podman unshare`, though this command is compatible w/ docker containers as well
  * cons
    * docker-compose hitting aarch64 ubuntu podman 3.2.3 gave errors
      * error on container exit
      * error about podman daemon not returning image ids

## rootless containers

* `podman unshare` is required to set permissions on rootless containers
  * the uid maps are different per machine, so can't use static numbers