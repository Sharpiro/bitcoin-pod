FROM ubuntu:18.04

EXPOSE 8332

RUN apt-get update
RUN apt-get install -y gpg wget

ARG bitcoin_tarball=bitcoin-0.20.0-arm-linux-gnueabihf.tar.gz

WORKDIR /root/app

RUN wget https://bitcoincore.org/bin/bitcoin-core-0.20.0/SHA256SUMS.asc
RUN wget https://bitcoincore.org/bin/bitcoin-core-0.20.0/${bitcoin_tarball}
RUN sha256sum --check --ignore-missing SHA256SUMS.asc
RUN gpg --keyserver keys.gnupg.net --recv-keys 01EA5486DE18A882D4C2684590C8019E36C2E964
RUN gpg --verify SHA256SUMS.asc

RUN tar -xzf ${bitcoin_tarball} && rm ${bitcoin_tarball}

WORKDIR /root

CMD [ "app/bitcoin-0.20.0/bin/bitcoind", "-conf=/root/bitcoin.conf" ]
