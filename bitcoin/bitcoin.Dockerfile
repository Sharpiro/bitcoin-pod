FROM ubuntu:18.04

ARG BITCOIN_VERSION

RUN apt-get update
RUN apt-get install -y gpg wget

RUN adduser --system -u 2000 bitcoin_pod_user

USER bitcoin_pod_user
WORKDIR /home/bitcoin_pod_user

RUN mkdir .bitcoin

RUN wget https://bitcoincore.org/bin/bitcoin-core-0.20.0/SHA256SUMS.asc
RUN wget https://bitcoincore.org/bin/bitcoin-core-0.20.0/${BITCOIN_VERSION}
RUN sha256sum --check --ignore-missing SHA256SUMS.asc
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 01EA5486DE18A882D4C2684590C8019E36C2E964
RUN gpg --verify SHA256SUMS.asc

RUN tar -xzf ${BITCOIN_VERSION} && rm ${BITCOIN_VERSION}

COPY bitcoin.conf .

CMD [ "./bitcoin-0.20.0/bin/bitcoind", "-conf=/home/bitcoin_pod_user/bitcoin.conf" ]
