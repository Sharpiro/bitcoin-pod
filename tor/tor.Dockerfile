FROM ubuntu:18.04

RUN apt-get update && \
  apt-get install -y tor

RUN adduser --system -u 2000 bitcoin_pod_user
USER bitcoin_pod_user
WORKDIR /home/bitcoin_pod_user

RUN mkdir .tor

COPY torrc.conf .

CMD ["tor", "-f", "torrc.conf"]
