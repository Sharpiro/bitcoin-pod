FROM ubuntu:18.04

# ARG wallet_master_pub
# RUN echo ${wallet_master_pub}
# ENV wallet_master_pub=xpub_required
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
# RUN read -p "enter wallet master public key: " wallet_master_pub && echo $wallet_master_pub
# RUN read -p "enter wallet master public key: " wallet_master_pub
# RUN echo $wallet_master_pub
# RUN sed "s/#any_name_works.*/wallet1 = $wallet_master_pub/" config.ini_sample > /root/config.ini
# RUN sed -i "s/wallet_filename =/wallet_filename = electrumpersonalserver/" /root/config.ini
RUN pip3 install --user .

WORKDIR /root

CMD [".local/bin/electrum-personal-server", ".bitcoin/eps_config.ini"]
