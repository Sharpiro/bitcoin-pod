FROM ubuntu:18.04

WORKDIR /app

RUN apt-get update
RUN apt-get install -y tor

COPY torrc.conf .

CMD ["tor", "-f", "/app/torrc.conf"]
