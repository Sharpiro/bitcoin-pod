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

## misc

- create symlinks so docker daemon doesn't auto-create its `data-root`
