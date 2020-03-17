#!/bin/bash
# Simplified by me, Tiago Carrondo <tcarrondo@ubuntu.com>
# Thanks to: Romain Fluttaz <romain@botux.fr>
# Thanks to: Wayne Ward <info@wayneward.co.uk>
# Thanks to: Mitchell Reese <mitchell@curiouslegends.com.au>
# --------------- [ Server ] ---------------- #
CAL_URL="https://drive.confuzer.cloud/remote.php/dav/"                # add the caldav URL here
USERNAME="johanv"               # you know this one
PASSWORD="`cat password`"               # lots of ******

# ----------------- [ Phone ] ----------------- #
CONFIG_NAME="mycloud"            # I use "mycloud" (only lowercase allowed)
CALENDAR_NAME="personalcalendar"          # I use "personalcalendar"
CALENDAR_VISUAL_NAME="ConfuzerCalendar"   # you can choose a nice name to show on the calendar app like "OwnCalendar"
CRON_FREQUENCY="hourly"        # I use "hourly"


#Create Calendar
syncevolution --create-database backend=evolution-calendar database=$CALENDAR_VISUAL_NAME
#Create Peer
syncevolution --configure --template webdav username=$USERNAME password=$PASSWORD syncURL=$CAL_URL keyring=no target-config@$CONFIG_NAME
#Create New Source
syncevolution --configure backend=evolution-calendar database=$CALENDAR_VISUAL_NAME @default $CALENDAR_NAME
#Add remote database
syncevolution --configure database=$CAL_URL backend=caldav target-config@$CONFIG_NAME $CALENDAR_NAME
#Connect remote calendars with local databases
syncevolution --configure --template SyncEvolution_Client syncURL=local://@$CONFIG_NAME $CONFIG_NAME $CALENDAR_NAME
#Add local database to the source
syncevolution --configure sync=two-way database=$CALENDAR_VISUAL_NAME $CONFIG_NAME $CALENDAR_NAME
#Start first sync
syncevolution --sync refresh-from-remote $CONFIG_NAME $CALENDAR_NAME

#Add Sync Cronjob
sudo mount / -o remount,rw
CRON_LINE="@$CRON_FREQUENCY export DISPLAY=:0.0 && export DBUS_SESSION_BUS_ADDRESS=$(ps -u phablet e | grep -Eo 'dbus-daemon.*address=unix:abstract=/tmp/dbus-[A-Za-z0-9]{10}' | tail -c35) && /usr/bin/syncevolution $CONFIG_NAME"
(crontab -u phablet -l; echo "$CRON_LINE" ) | crontab -u phablet -
sudo mount / -o remount,ro
sudo service cron restart
