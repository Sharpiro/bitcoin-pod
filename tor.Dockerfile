FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y tor

CMD ["tor", "-f", "/root/torrc"]
