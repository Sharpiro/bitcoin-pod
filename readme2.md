# readme

## setup bitcoin data drive permissions

<!-- 2000 == 101999 always/sometimes? -->

```sh
chmod -R 750 ~/encrypted_drive/bitcoin_data
chown -R .`whoami` ~/encrypted_drive/bitcoin_data
podman unshare chown -R 2000 ~/encrypted_drive/bitcoin_data
```
