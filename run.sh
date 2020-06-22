#! /bin/bash

# tor & bash
tor & \
bitcoin-0.20.0/bin/bitcoind -onlynet=onion -proxy=127.0.0.1:9050 -txindex=1
