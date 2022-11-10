#!/bin/bash
######################################################################
# name: start.sh
# description: Manager docker containers using docker-compose
# author: Cleberson Souza - cleberson.brasil@gmail.com
# version: 0.1
# date: 28/out/22
######################################################################
PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\e[0;33m'

if [ ! -f .env ]; then
    echo -e "[${RED}ERROR${RESTORE}] .env file not found!"
    exit 1
fi

source .env

case "$1" in
	install)
        echo 
        cd dk-tor
        docker build -t dk-tor .
        cd ..
        echo -e "[${GREEN}OK${RESTORE}] Starting instalation..."
        docker-compose up -d
    ;; 
    adlist)
        echo -e "[${GREEN}OK${RESTORE}] ${CONTAINER_PIHOLE_NAME} Updating adList..."
        docker exec -it ${CONTAINER_PIHOLE_NAME} pihole updateGravity
        mkdir /etc/pihole
        curl --url ${adListSource} --output ${adListFile}
        curl --url ${adListSource2} --output ${adListFile2}

        if [ -e "${adListFile}" ]; then
            rowid=$(docker exec ${CONTAINER_PIHOLE_NAME} sqlite3 /etc/pihole/gravity.db "SELECT MAX(id) FROM adlist;")
        if [[ -z "$rowid" ]]; then
            rowid=0
        fi
            rowid=$((rowid+1))
        grep -v '^ *#' < "${adListFile}" | while IFS= read -r domain
        do
            if [[ -n "${domain}" ]]; then
            echo "${rowid},\"${domain}\",1,${timestamp},${timestamp},\"Added by adListUpdater.sh\",,0,0,0" >> ${tmpFile}
            rowid=$((rowid+1))
            fi
        done

        if [ -e "${adListFile2}" ]; then
            rowidw=$(docker exec ${CONTAINER_PIHOLE_NAME} sqlite3 /etc/pihole/gravity.db "SELECT MAX(id) FROM vw_regex_whitelist;")
        if [[ -z "$rowidw" ]]; then
            rowidw=0
        fi
            rowidw=$((rowidw+1))
        grep -v '^ *#' < "${adListFile2}" | while IFS= read -r domain2
        do
            if [[ -n "${domain2}" ]]; then
            echo "\"(\.|^)\",${domain2},\"$\",${rowidw},0" >> ${tmpFilew}
            rowidw=$((rowidw+1))
            fi
        done
        
        cp dk-pihole/adListUpdater.sh ${PIHOLE_DIR_ETC}/.
        docker exec -it ${CONTAINER_PIHOLE_NAME} sudo bash /etc/pihole/adListUpdater.sh
        docker exec -it ${CONTAINER_PIHOLE_NAME} pihole updateGravity
        rm ${adListFile}
        rm ${tmpFile}
        fi        

    ;;
    stop)
        echo -e "[${GREEN}-${RESTORE}] All docker will be ${RED}STOPPED${RESTORE}"
        read -r -p "Are you sure? [Y/N] " response
        case ${response:0:1} in
            y|Y )
                echo -e "[${GREEN}-${RESTORE}] Stoping..."
                docker-compose down
            ;;
            * )
                echo -e "[${GREEN}-${RESTORE}] canceled!"
                exit 0
            ;;
        esac

    ;;
    *)
        echo
        echo "dk-pihole-tor-grafana-telegraf-influxdb tools"
        echo "How to use:"
        echo
        echo "$0 { install | adlist | stop }"
        echo
        echo "More information please read README file of the project"
        echo "https://github.com/cleber-son/dk-pihole-tor-grafana-telegraf-influxdb"
        exit 1
    ;;
esac



