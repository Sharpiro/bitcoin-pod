FROM ubuntu:18.04

EXPOSE 50002
WORKDIR /app

RUN apt-get update
RUN apt install -y python3 python3-pip

RUN gpg --recv-keys 0A8B038F5E10CC2789BFCFFFEF734EA677F31129

RUN apt install -y wget
RUN apt install -y vim less curl

RUN wget https://github.com/chris-belcher/electrum-personal-server/releases/download/eps-v0.2.1.1/eps-v0.2.1.1.tar.gz.asc
RUN wget https://github.com/chris-belcher/electrum-personal-server/archive/eps-v0.2.1.1.tar.gz

RUN gpg --verify eps-v0.2.1.1.tar.gz.asc

RUN tar -xzf eps-v0.2.1.1.tar.gz
RUN rm eps-v0.2.1.1.tar.gz
RUN cp electrum-personal-server-eps-v0.2.1.1/config.ini_sample /root/config.ini
WORKDIR /app/electrum-personal-server-eps-v0.2.1.1
RUN pip3 install --user .

WORKDIR /root

# CMD ["/root/.local/bin/electrum-personal-server", "config.ini"]
CMD ["bash"]
