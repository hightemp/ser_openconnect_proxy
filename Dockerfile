FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y tinyproxy openconnect

COPY ./tinyproxy.conf /etc/tinyproxy/tinyproxy.conf

COPY tinyproxy.conf /etc/tinyproxy.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8888

ENTRYPOINT ["bash", "/entrypoint.sh"]