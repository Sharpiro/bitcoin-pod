FROM ubuntu:18.04

EXPOSE 8332

RUN apt-get update
RUN apt-get install -y vim gpg wget less

RUN gpg --recv-keys 01EA5486DE18A882D4C2684590C8019E36C2E964

# arm 32
ENV bitcoin_tarball=bitcoin-0.20.0-arm-linux-gnueabihf.tar.gz
## x86_64
#ENV bitcoin_tarball=bitcoin-0.20.0-x86_64-linux-gnu.tar.gz

WORKDIR /app

RUN wget https://bitcoincore.org/bin/bitcoin-core-0.20.0/SHA256SUMS.asc
RUN wget https://bitcoincore.org/bin/bitcoin-core-0.20.0/${bitcoin_tarball}
RUN sha256sum --check --ignore-missing SHA256SUMS.asc
RUN gpg --verify SHA256SUMS.asc

RUN tar -xzf ${bitcoin_tarball}

CMD [ "bitcoin-0.20.0/bin/bitcoind", "-onlynet=onion", "-proxy=127.0.0.1:9050", "-txindex=1", "-walletbroadcast=0" ]
