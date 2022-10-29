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
        echo -e "[${GREEN}OK${RESTORE}] Starting instalation..."
        docker-compose up -d
    ;; 
    adlist)
        echo -e "[${GREEN}OK${RESTORE}] $PROJ_NAME Updating adList..."
        docker exec -it ${CONTAINER_PIHOLE_NAME} pihole updateGravity
        curl --url ${adListSource} --output ${adListFile}
        if [ -e "${adListFile}" ]; then
            rowid="$(sqlite3 "${gravityDBfile}" "SELECT MAX(id) FROM ${table};")"
        if [[ -z "$rowid" ]]; then
            rowid=0
        fi
            rowid=$((rowid+1))

        grep -v '^ *#' < "${adListFile}" | while IFS= read -r domain
        do
            if [[ -n "${domain}" ]]; then
            echo "${rowid},\"${domain}\",1,${timestamp},${timestamp},\"Added by Updater\",,0,0,0" >> "${tmpFile}"
            rowid=$((rowid+1))
            fi
        done
        output=$( { printf ".timeout 30000\\n.mode csv\\n.import \"%s\" %s\\n" "${tmpFile}" "${table}" | sqlite3 "${gravityDBfile}"; } 2>&1 )
        status="$?"

        rm ${tmpFile}

        if [[ "${status}" -ne 0 ]]; then
            echo "Warning: Some warnings in table ${table} in database ${gravityDBfile}:"
            echo "${output}"
        else
            echo "Info: Successfull inserted the adlists list"
        fi
        fi
        docker exec -it ${CONTAINER_PIHOLE_NAME} pihole updateGravity

    ;;
	stop)
		echo -e "[${GREEN}-${RESTORE}] Pihole will be ${RED}STOPPED${RESTORE}"
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

	*)
        echo "Manager docker tool"
		echo "$0 usage:"
		echo
		echo "$0 { install | adlist | stop }"
		echo
        echo "More information please read README file of the project"
		exit 1
	;;
esac
