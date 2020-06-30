FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y tor

RUN mv /etc/tor/torrc /etc/tor/torrc.sample
COPY torrc /etc/tor/torrc

CMD ["tor"]
