FROM ubuntu:18.04

EXPOSE 9050

RUN apt-get update
RUN apt-get install -y tor

CMD ["tor"]
