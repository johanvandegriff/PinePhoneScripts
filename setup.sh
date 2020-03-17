#!/bin/bash
# https://forum.pine64.org/showthread.php?tid=8923

#update the system
sudo apt update && apt upgrade -y

#enable sound
sudo modprobe snd_soc_simple_amplifier
sudo modprobe snd_soc_simple_card_utils

#unmute the mic
amixer -c 0 set 'AIF1 Slot 0 Digital DAC' unmute

#amixer: Unable to find simple control 'AIF1 Slot 0 Digital DAC',0
#phablet@ubuntu-phablet:~$ amixer | grep 'AIF1'|grep 'DAC'
#Simple mixer control 'AIF1 AD0 Mixer AIF2 DAC',0
#Simple mixer control 'AIF1 AD0 Mixer AIF2 DAC Rev',0
#Simple mixer control 'DAC Mixer AIF1 DA0',0

amixer -c 0 set 'DAC Mixer AIF1 DA0' unmute


#unmute the speaker and set volume to 100%
amixer -c 0 set 'Line Out' unmute
amixer sset 'Line Out' 100%

#start the modem
sudo /usr/share/ofono/scripts/enable-modem
sudo /usr/share/ofono/scripts/online-modem
