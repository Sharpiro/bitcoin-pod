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
  "data-root": "/home/{{user}}/mnt/encrypted_drive/docker_root"
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
