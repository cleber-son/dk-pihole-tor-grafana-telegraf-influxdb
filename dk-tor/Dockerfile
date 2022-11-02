FROM ubuntu:latest
LABEL maintainer "Cleberson Souza <cleberson.brasil@gmail.com>"

RUN apt-get update && \
    apt-get -y install tor obfs4proxy curl

COPY torrc /etc/tor/torrc

HEALTHCHECK --timeout=10s --start-period=60s \
    CMD curl --proxy 127.0.0.1:9150 https://api.my-ip.io/ip || exit 1

COPY exec.sh /
RUN chmod +x /exec.sh

EXPOSE 9150

CMD ["./exec.sh"]


