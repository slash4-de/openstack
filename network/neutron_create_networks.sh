#!/bin/bash

### SCRIPT NAME : neutron_create_networks.sh
### Author 	: Imran Ahmed <researcher6@live.com>
### Date	: 15-JULY-2015
### Description	: This script creates neutron networks and subnets to be used in OpenStack.
source neutron_creds

neutron net-create ext-net --shared --router:external True \
--provider:physical_network external --provider:network_type flat

neutron subnet-create ext-net --name ext-subnet \
--allocation-pool start=192.168.10.135,end=192.168.10.140 \
--disable-dhcp --gateway 192.168.10.1 192.168.10.0/24

neutron net-create admin-net

neutron subnet-create admin-net --name admin-subnet \
--dns-nameserver 8.8.4.4 \
--gateway 10.0.1.1 10.0.1.0/24

neutron router-create admin-router

neutron router-interface-add admin-router admin-subnet

neutron router-gateway-set admin-router ext-net
