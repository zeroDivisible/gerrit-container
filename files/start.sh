#!/bin/bash
set -x
set -e

# initialize gerrit
sudo -u $GERRIT_USER java -jar $GERRIT_WAR init --batch --no-auto-start -d $GERRIT_SITE
sudo -u $GERRIT_USER java -Xmx256m -jar $GERRIT_WAR reindex -d $GERRIT_SITE

supervisord -n -c /etc/supervisord.conf
