#!/bin/bash
# Simplified by me, Tiago Carrondo <tcarrondo@ubuntu.com>
# Thanks to: Romain Fluttaz <romain@botux.fr>
# Thanks to: Wayne Ward <info@wayneward.co.uk>
# Thanks to: Mitchell Reese <mitchell@curiouslegends.com.au>
# --------------- [ Server ] ---------------- #
CONTACTS_URL="https://drive.confuzer.cloud/remote.php/dav/"           # add the carddav URL here
USERNAME="johanv"               # you know this one
PASSWORD="`cat password`"               # lots of ******

# ----------------- [ Phone ] ----------------- #
CONFIG_NAME="mycloud"            # I use "mycloud" (only lowercase allowed)
CONTACTS_NAME="personalcontacts"          # I use "personalcontacts"
CONTACTS_VISUAL_NAME="ConfuzerContacts"   # you can choose a nice name to show on the contacts app like "OwnContacts"
CRON_FREQUENCY="hourly"        # I use "hourly"


#Create contact list
syncevolution --create-database backend=evolution-contacts database=$CONTACTS_VISUAL_NAME
#Create Peer
syncevolution --configure --template webdav username=$USERNAME password=$PASSWORD syncURL=$CONTACTS_URL keyring=no target-config@$CONFIG_NAME
#Create New Source
syncevolution --configure backend=evolution-contacts database=$CONTACTS_VISUAL_NAME @default $CONTACTS_NAME
#Add remote database
syncevolution --configure database=$CONTACTS_URL backend=carddav target-config@$CONFIG_NAME $CONTACTS_NAME
#Connect remote contact list with local databases
syncevolution --configure --template SyncEvolution_Client Sync=None syncURL=local://@$CONFIG_NAME $CONFIG_NAME $CONTACTS_NAME
#Add local database to the source
syncevolution --configure sync=two-way backend=evolution-contacts database=$CONTACTS_VISUAL_NAME $CONFIG_NAME $CONTACTS_NAME
#Start first sync
syncevolution --sync refresh-from-remote $CONFIG_NAME $CONTACTS_NAME

#Add Sync Cronjob
sudo mount / -o remount,rw
CRON_LINE="@$CRON_FREQUENCY export DISPLAY=:0.0 && export DBUS_SESSION_BUS_ADDRESS=$(ps -u phablet e | grep -Eo 'dbus-daemon.*address=unix:abstract=/tmp/dbus-[A-Za-z0-9]{10}' | tail -c35) && /usr/bin/syncevolution $CONFIG_NAME"
(crontab -u phablet -l; echo "$CRON_LINE" ) | crontab -u phablet -
sudo mount / -o remount,ro
sudo service cron restart
