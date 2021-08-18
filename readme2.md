# readme

## setup bitcoin data drive permissions

<!-- 2000 == 101999 always/sometimes? -->

```sh
chmod -R 750 ~/encrypted_drive/bitcoin_data
chown -R .`whoami` ~/encrypted_drive/bitcoin_data
podman unshare chown -R 2000 ~/encrypted_drive/bitcoin_data
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
  "data-root": "/home/{{user}}/docker_crypt"
}
```

## symlinks

- create symlinks so docker won't auto-create directories in unencrypted areas

### encrypted data

```sh
ln -s ~/mnt/encrypted_drive ~/encrypted_drive
```

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