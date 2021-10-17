FROM ubuntu:18.04

RUN apt-get update && \
  apt-get install -y gpg wget

RUN adduser --system -u 2000 bitcoin_pod_user
USER bitcoin_pod_user
WORKDIR /home/bitcoin_pod_user

RUN mkdir .bitcoin

ARG BITCOIN_VERSION
ARG BITCOIN_PLATFORM
ENV BITCOIN_TARBALL=bitcoin-${BITCOIN_VERSION}-${BITCOIN_PLATFORM}.tar.gz

RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc
RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/${BITCOIN_TARBALL}
RUN sha256sum --check --ignore-missing SHA256SUMS.asc
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 01EA5486DE18A882D4C2684590C8019E36C2E964
RUN gpg --verify SHA256SUMS.asc

RUN tar -xzf ${BITCOIN_TARBALL} && rm ${BITCOIN_TARBALL}

RUN mv bitcoin-${BITCOIN_VERSION} bitcoin

COPY bitcoin.conf .

CMD [ "./bitcoin/bin/bitcoind", "-conf=/home/bitcoin_pod_user/bitcoin.conf" ]
