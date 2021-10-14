# readme

## setup bitcoin data drive permissions

```sh
chmod -R 750 ~/mnt/encrypted_drive/bitcoin_node/data
chown -R .`whoami` ~/mnt/encrypted_drive/bitcoin_node/data
podman unshare chown -R 2000 ~/mnt/encrypted_drive/bitcoin_node/data
```

## daemon configuration

### locations

root:
`/etc/docker/daemon.json`

rootless:
`~/.config/docker/daemon.json`

### example daemon.json

```json
{
  "data-root": "/home/{{user}}/.encrypted_docker_root"
}
```

<!-- ## symlinks

- create symlinks so docker won't auto-create directories in unencrypted areas

### encrypted data

```sh
ln -s ~/mnt/encrypted_drive ~/encrypted_drive
``` -->

<!-- ### docker data

```sh
ln -s ~/mnt/encrypted_drive/docker_crypt ~/docker_crypt
```

### bitcoin data

```sh
ln -s ~/mnt/encrypted_drive/app_data/bitcoin_data ~/bitcoin_data
``` -->

## todo

- `data-root` and symlinks setup could likely be removed if all disks were fully encrypted instead of the OS disk unencrypted
- would be nice to not have to depend on `podman unshare` to setup rootless volume permissions
  - there is a way to to do it just with `unshare` but not much documentation on that command
  - the uidmaps are different per machine, so can't use static numbers

## container platform comparison

- docker
  - pros
    - still seems more robust
  - cons
- podman
  - pros
    - gain "pods" feature which would remove some networking warnings and awkwardness
    - gain kubernetes feature
    - better rootless tooling like `podman unshare`, though this command is compatible w/ docker containers as well
  - cons
    - docker-compose hitting aarch64 ubuntu podman 3.2.3 gave errors
      - error on container exit
      - error about podman daemon not returning image ids
