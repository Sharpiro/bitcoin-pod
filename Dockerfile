FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y vim gpg wget tor

RUN gpg --recv-keys 01EA5486DE18A882D4C2684590C8019E36C2E964

# # arm 32
# ENV bitcoin_tarball=bitcoin-0.20.0-arm-linux-gnueabihf.tar.gz
# x86_64
ENV bitcoin_tarball=bitcoin-0.20.0-x86_64-linux-gnu.tar.gz

WORKDIR /app

RUN wget https://bitcoincore.org/bin/bitcoin-core-0.20.0/SHA256SUMS.asc
RUN wget https://bitcoincore.org/bin/bitcoin-core-0.20.0/${bitcoin_tarball}
RUN sha256sum --check --ignore-missing SHA256SUMS.asc
RUN gpg --verify SHA256SUMS.asc

RUN tar -xzf ${bitcoin_tarball}

COPY run.sh .
RUN chmod +x run.sh
# CMD ["bash"]
ENTRYPOINT [ "./run.sh" ]

# podman build -t bitcoin_runner .
# podman run -it --rm --name bitcoin_runner_test -v ~/b_node_ssd/dot_bitcoin:/root/.bitcoin:Z bitcoin_runner
# podman run -d --rm --name bitcoin_runner_test -v ~/b_node_ssd/dot_bitcoin:/root/.bitcoin:Z bitcoin_runner
# podman run -d --name bitcoin_runner_test -v ~/b_node_ssd/dot_bitcoin:/root/.bitcoin:Z bitcoin_runner
# podman run -d --name bitcoin_runner_test -v b_node_home:/root/.bitcoin bitcoin_runner
# podman exec -it bitcoin_runner_test bash
# podman exec -it bitcoin_runner_test tail -f ~/.bitcoin/debug.log
