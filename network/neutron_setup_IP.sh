#!/bin/bash
### SCRIPT NAME : neutron_setup_IP.sh
### Author 	: Imran Ahmed <researcher6@live.com>
### Date	: 15-JULY-2015
### Description	: This script configures the IP addresses on all interfaces of the Neutron/NETWORK Node.

# Load the configuration file
source neutron_config

# Collect Info for each NIC
# !!!!!!!NOTICE!!!!!!!!!!!!
# We need to correctly specify the index number for each NIC. 
# This script assumes that :
# NIC Index for Management network is = 2
# NIC Index for Tunnel network is     = 3
# NIC Index for Public network is     = 4
# This can be confirmed by running the command : ifconfig

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
    if [ "$(cat /sys/class/net/$i/ifindex)" == '3' ]; then
        #create config file for Tunnel NIC
        echo -n "Setup IP configuration for Internal NIC..................."
        echo "HWADDR=\"$myMAC\"" > /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "TYPE=\"Ethernet\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "BOOTPROTO=\"none\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "IPV4_FAILURE_FATAL=\"no\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "NAME=\"$myNIC\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "ONBOOT=\"yes\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "IPADDR=\"$L_HOST_TUNNEL_IP\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "NETMASK=\"$L_HOST_TUNNEL_NETMASK\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "....[DONE]"

    fi        
    if [ "$(cat /sys/class/net/$i/ifindex)" == '4' ]; then
        #create config file for External NIC
        echo -n "Setup IP configuration for external NIC...................."
        echo "HWADDR=\"$myMAC\"" > /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "TYPE=\"Ethernet\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "BOOTPROTO=\"none\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "IPV4_FAILURE_FATAL=\"no\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "NAME=\"$myNIC\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "ONBOOT=\"yes\"" >> /etc/sysconfig/network-scripts/ifcfg-$myNIC
        echo "....[DONE]"
    fi        
done

#Now Setup Hostname
echo -n "Setup the hostname ..........."
echo "$L_HOST_NAME" > /etc/hostname
echo "$L_HOST_IP    $L_HOST_NAME" >> /etc/hosts
echo  "....[DONE]"
