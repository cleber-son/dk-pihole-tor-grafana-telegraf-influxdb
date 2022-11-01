FROM bitnami/minideb:latest
LABEL maintainer "Cleberson Souza <cleberson.brasil@gmail.com>"

RUN apt-get update && \
    apt-get install apt-transport-https gnupg1 dirmngr lsb-release python3 -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L https://packagecloud.io/ookla/speedtest-cli/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/speedtestcli-archive-keyring.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/speedtestcli-archive-keyring.gpg] https://packagecloud.io/ookla/speedtest-cli/debian/ $(lsb_release -cs) main" | sudo tee  /etc/apt/sources.list.d/speedtest.list && \
    apt-get update && \
    apt-get speedtest && \
    mkdir /speedtest

COPY speedtest.py /speedtest.py

VOLUME /speedtest

ENTRYPOINT ["/speedtest.py"]

