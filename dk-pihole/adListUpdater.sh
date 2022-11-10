#!/bin/bash
######################################################################
# name: adListUpdater
# description: Pihole Adlists updater
# author: Cleberson Souza - cleberson.brasil@gmail.com
# version: 0.1
# date: 30/out/22
######################################################################

printf ".timeout 30000\\n.mode csv\\n.import \"%s\" %s\\n" "/etc/pihole/adlists.tmp" "adlist" | sqlite3 "/etc/pihole/gravity.db";
printf ".timeout 30000\\n.mode csv\\n.import \"%s\" %s\\n" "/etc/pihole/adlistsw.tmp" "vw_regex_whitelist" | sqlite3 "/etc/pihole/gravity.db";


crontab -l > adListUpdate
echo "0 2 * * * pihole updateGravity" >> adListUpdate
crontab adListUpdate
rm adListUpdate








