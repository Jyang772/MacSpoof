#! /bin/zsh

IP=$(ifconfig wlan0 | grep "inet addr:" | tr -d A-z: | awk {'print $1'})

echo $IP

sudo nmap -sP $IP/24 > lol
cat lol

echo "done!"
#exit 0;

addrList="e4:ce:5a:6a:14:c8:68"
#addrList=$(cat lol | grep "MAC Address" | grep -v Unknown | grep -v Clear | awk '{print $3}')
echo "$addrList"

while read ether; do
        echo $ether
        #sudo ifconfig wlan0 down hw ether $ether
        #sudo ifconfig wlan0 up
	sudo ip link set wlan0 down
	sudo ip link set wlan0 address $ether
	sudo ip link set wlan0 up
	sudo killall -9 wpa_supplicant
	sleep 5
	sudo wpa_supplicant -D nl80211 -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf -B
        sudo dhclient -r
        sudo dhclient -v wlan0
        if [ $(curl -I www.google.com >/dev/null | grep -ic "200") != "0" ]; then
                exit 0
        #else
         #     wpa_cli reassociate

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
