#! /bin/zsh
#Run sudo nmap -sP "IP RANGE"/24 > file beforehand


#addrList="3c:a9:f4:49:97:ed"
addrList=$(cat file | grep -v Unknown | grep MAC Address | awk '{print $3}')
echo "$addrList"

while read ether; do
        echo $ether
        sudo ifconfig wlan0 down
        sudo ifconfig wlan0 hw ether $ether
        sudo ifconfig wlan0 up
        #ip link
        sudo dhclient -r
        #ps -ax | grep wpa | awk '{print $1}' | xargs sudo kill -v
        #sudo wpa_supplicant -D nl80211 -i wlp2s0 -c /etc/wpa_supplicant/royal.conf -B
        sudo dhclient -v wlan0
        if [ $(curl -I www.google.com >/dev/null | grep -ic "200") != "0" ]; then
                exit 0
        else
             wpa_cli reassociate

        fi
done <<< "$addrList"
exit 1;


#original hardware permanent address:
#ethtool -P wlan0

#do not trust? dat interface is spoofing or not
#http://www.cs.fsu.edu/~baker/devices/lxr/http/source/linux/drivers/net/ucc_geth.c

#disable network-manager
#sudo stop network-manager

#enable wpa_supplicant in background
#sudo wpa_supplicant -Dnl80211 -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf -B
