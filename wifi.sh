#!/bin/bash
#https://gitlab.com/ubports/community-ports/pinephone/issues/16
sudo nmcli radio wifi off
sudo nmcli radio wifi on
nmcli r

#maybe works without reboot:
#sudo nmcli radio all off
#sudo rmmod 8723cs
#sudo modprobe 8723cs
#sudo nmcli radio all on
