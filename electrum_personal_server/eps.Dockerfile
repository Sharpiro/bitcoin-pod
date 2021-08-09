FROM ubuntu:18.04

EXPOSE 50002
WORKDIR /root/app

RUN apt-get update
RUN apt-get install -y python3 python3-pip wget

RUN wget https://github.com/chris-belcher/electrum-personal-server/releases/download/eps-v0.2.1.1/eps-v0.2.1.1.tar.gz.asc
RUN wget https://github.com/chris-belcher/electrum-personal-server/archive/eps-v0.2.1.1.tar.gz

RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 0A8B038F5E10CC2789BFCFFFEF734EA677F31129
RUN gpg --verify eps-v0.2.1.1.tar.gz.asc

RUN tar -xzf eps-v0.2.1.1.tar.gz && rm eps-v0.2.1.1.tar.gz
WORKDIR /root/app/electrum-personal-server-eps-v0.2.1.1
RUN pip3 install --user .

WORKDIR /root

CMD [".local/bin/electrum-personal-server", "/root/eps-config.ini"]
