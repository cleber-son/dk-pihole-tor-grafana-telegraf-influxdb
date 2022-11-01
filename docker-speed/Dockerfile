FROM grafana/grafana:latest
LABEL maintainer "Cleberson Souza <cleberson.brasil@gmail.com>"

RUN apt-get update && \
    apt-get install apt-transport-https gnupg1 dirmngr lsb-release -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L https://packagecloud.io/ookla/speedtest-cli/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/speedtestcli-archive-keyring.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/speedtestcli-archive-keyring.gpg] https://packagecloud.io/ookla/speedtest-cli/debian/ $(lsb_release -cs) main" | sudo tee  /etc/apt/sources.list.d/speedtest.list && \
    apt-get update && \
    apt-get speedtest && \
    mkdir /PASTA-SPEED
