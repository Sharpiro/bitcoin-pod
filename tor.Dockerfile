FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y tor

WORKDIR /root

CMD ["tor", "-f", "/root/torrc"]
