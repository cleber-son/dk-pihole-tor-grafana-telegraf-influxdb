#!/bin/bash
#!/bin/bash
######################################################################
# name: adListUpdater
# description: Pihole Adlists updater
# author: Cleberson Souza - cleberson.brasil@gmail.com
# version: 0.1
# date: 30/out/22
######################################################################

printf ".timeout 30000\\n.mode csv\\n.import \"%s\" %s\\n" "/etc/pihole/adlists.tmp" "adlist" | sqlite3 "/etc/pihole/gravity.db";










