FROM ubuntu:18.04

EXPOSE 50002
WORKDIR /app

RUN apt-get update
RUN apt install -y python3 python3-pip wget
# dev
RUN apt install -y vim less curl

RUN wget https://github.com/chris-belcher/electrum-personal-server/releases/download/eps-v0.2.1.1/eps-v0.2.1.1.tar.gz.asc
RUN wget https://github.com/chris-belcher/electrum-personal-server/archive/eps-v0.2.1.1.tar.gz

RUN gpg --recv-keys 0A8B038F5E10CC2789BFCFFFEF734EA677F31129
RUN gpg --verify eps-v0.2.1.1.tar.gz.asc

RUN tar -xzf eps-v0.2.1.1.tar.gz && rm eps-v0.2.1.1.tar.gz
WORKDIR /app/electrum-personal-server-eps-v0.2.1.1
RUN pip3 install --user .

WORKDIR /root

COPY config/eps-config.ini /root/eps-config.ini

CMD [".local/bin/electrum-personal-server", "/root/eps-config.ini"]
