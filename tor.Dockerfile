FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y tor

COPY config/torrc /root/torrc

CMD ["tor", "-f", "/root/torrc"]
