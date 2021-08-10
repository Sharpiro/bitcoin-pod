FROM ubuntu:18.04

WORKDIR /app

RUN apt-get update
RUN apt-get install -y tor

COPY torrc.conf .

# USER debian-tor
RUN adduser --system -u 2000 bitcoin-pod-user
USER bitcoin-pod-user

# RUN mkdir /var/lib/tor/control_cookie
RUN mkdir control_cookie

CMD ["tor", "-f", "/app/torrc.conf"]
