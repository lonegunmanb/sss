FROM ubuntu:18.04 

ENV PORT=443 SSPASSWORD=password CRYPTOR_METHOD=aes-256-cfb AUTH_METHOD=auth_aes128_md5 OBFS_METHOD=tls1.2_ticket_auth

RUN apt update && \
    apt install -y python git && \
    git clone https://github.com/shadowsocksr-backup/shadowsocksr.git

WORKDIR /shadowsocksr

RUN git checkout manyuser && \
    bash initcfg.sh && \
    rm -rf ./.git

CMD python shadowsocks/server.py -p $PORT -k $SSPASSWORD -m  $CRYPTOR_METHOD -O $AUTH_METHOD -o $OBFS_METHOD start
