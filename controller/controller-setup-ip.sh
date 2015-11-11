#!/bin/bash
### SCRIPT NAME : controller_setup_IP.sh
### Author 	: rootguy1 <researcher6@live.com>
### Date		: 15-JULY-2015
### Description	: This script configures the IP addresses on all interfaces of the CONTROLLER Node.

# Load the configuration file
source controller.conf

#Collect Info for each NIC
echo " !!!!!!!NOTICE!!!!!!!!!!!! "
echo " We need to correctly specify the index number for each NIC. "
echo " This script assumes that NIC Index for Management network is = 2 " 


for i in $(ls /sys/class/net); do
    myNIC=$i
    myMAC=$(cat /sys/class/net/$i/address)
    if [ "$(cat /sys/class/net/$i/ifindex)" == '2' ]; then
        #Setup the IP configuration for management NIC
        echo -n "Setup IP configuration for Management NIC................"
        sed -i.bak "s/dhcp/none/g" /etc/sysconfig/network-scripts/ifcfg-$myNIC
        sed -i "s/HWADDR/#HWADDR/g" /etc/sysconfig/network-scripts/ifcfg-$myNIC
        sed -i "/#HWADDR/a HWADDR=\"$myMAC\"" /etc/sysconfig/network-scripts/ifcfg-$myNIC
        sed -i "s/UUID/#UUID/g" /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "IPADDR=\"$L_HOST_IP\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "NETMASK=\"$L_HOST_NETMASK\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "GATEWAY=\"$L_HOST_GATEWAY\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "DNS1=\"$L_HOST_DNS\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        mv /etc/sysconfig/network-scripts/ifcfg-$myNIC.bak .
        echo " ..[DONE]"
    fi
done

#Now Setup Hostname
echo -n "Setup the hostname ..........."
echo "$L_HOST_NAME" > /etc/hostname
echo "$L_HOST_IP    $L_HOST_NAME" >> /etc/hosts
echo  "....[DONE]"
