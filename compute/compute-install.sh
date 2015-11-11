#!/bin/bash
### SCRIPT NAME : compute_node_install.sh
### Author 	: Imran Ahmed <researcher6@live.com>
### Date	: 15-JULY-2015
### Description	: This script installs the OpenStack COMPUTE Node.
source compute.conf

echo "Installing NTP service...................................................."
yum -y install ntp
echo -n "Starting NTP service..................................................."
systemctl enable ntpd.service
systemctl start ntpd.service
echo "[DONE]"

echo "Installing OpenStack repos................................................"
yum -y install yum-plugin-priorities
yum -y install epel-release
yum -y install http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm
yum -y upgrade


echo "Disabling Firewall service................................................"
systemctl stop firewalld.service
systemctl disable firewalld.service
sed -i 's/enforcing/disabled/g' /etc/selinux/config
echo 0 > /sys/fs/selinux/enforce

echo 'net.ipv4.conf.all.rp_filter=0' >> /etc/sysctl.conf
echo 'net.ipv4.conf.default.rp_filter=0' >> /etc/sysctl.conf
sysctl -p

echo -n "obtaining primary NIC information ....................................."
for i in $(ls /sys/class/net); do
    if [ "$(cat /sys/class/net/$i/ifindex)" == '2' ]; then
        NIC=$i
        MY_MAC=$(cat /sys/class/net/$i/address)
        echo "$i ($MY_MAC)"
    fi
done
echo "[DONE]"

echo "Installing nova compute .................................................."
yum -y install openstack-nova-compute sysfsutils libvirt-daemon-config-nwfilter
echo -n "Editing /etc/nova/nova.conf ..........................................."
sed -i.bak "/\[DEFAULT\]/a \
rpc_backend = rabbit\n\
rabbit_host = $CONTROLLER_IP\n\
auth_strategy = keystone\n\
my_ip = $THISHOST_IP\n\
vnc_enabled = True\n\
vncserver_listen = 0.0.0.0\n\
vncserver_proxyclient_address = $THISHOST_IP\n\
novncproxy_base_url = http://$CONTROLLER_IP:6080/vnc_auto.html\n\
network_api_class = nova.network.neutronv2.api.API\n\
security_group_api = neutron\n\
linuxnet_interface_driver = nova.network.linux_net.LinuxOVSInterfaceDriver\n\
firewall_driver = nova.virt.firewall.NoopFirewallDriver" /etc/nova/nova.conf

sed -i "/\[keystone_authtoken\]/a \
auth_uri = http://$CONTROLLER_IP:5000/v2.0\n\
identity_uri = http://$CONTROLLER_IP:35357\n\
admin_tenant_name = service\n\
admin_user = nova\n\
admin_password = $SERVICE_PWD" /etc/nova/nova.conf

sed -i "/\[glance\]/a host = $CONTROLLER_IP" /etc/nova/nova.conf

#if compute node is virtual - change virt_type to qemu
if [ $(egrep -c '(vmx|svm)' /proc/cpuinfo) == "0" ]; then
    sed -i '/\[libvirt\]/a virt_type = qemu' /etc/nova/nova.conf
fi
echo "[DONE]"

echo "Installing Neutron services required by compute .........................."
yum -y install openstack-neutron-ml2 openstack-neutron-openvswitch

echo "Editing /etc/neutron/neutron.conf ........................................"
sed -i '0,/\[DEFAULT\]/s//\[DEFAULT\]\
rpc_backend = rabbit\n\
rabbit_host = '"$CONTROLLER_IP"'\
auth_strategy = keystone\
core_plugin = ml2\
service_plugins = router\
allow_overlapping_ips = True/' /etc/neutron/neutron.conf

sed -i "/\[keystone_authtoken\]/a \
auth_uri = http://$CONTROLLER_IP:5000/v2.0\n\
identity_uri = http://$CONTROLLER_IP:35357\n\
admin_tenant_name = service\n\
admin_user = neutron\n\
admin_password = $SERVICE_PWD" /etc/neutron/neutron.conf

echo "Editing /etc/neutron/plugins/ml2/ml2_conf.ini ............................"
sed -i "/\[ml2\]/a \
type_drivers = flat,gre\n\
tenant_network_types = gre\n\
mechanism_drivers = openvswitch" /etc/neutron/plugins/ml2/ml2_conf.ini

sed -i "/\[ml2_type_gre\]/a \
tunnel_id_ranges = 1:1000" /etc/neutron/plugins/ml2/ml2_conf.ini

sed -i "/\[securitygroup\]/a \
enable_security_group = True\n\
enable_ipset = True\n\
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver\n\
[ovs]\n\
local_ip = $THISHOST_TUNNEL_IP\n\
enable_tunneling = True\n\
[agent]\n\
tunnel_types = gre" /etc/neutron/plugins/ml2/ml2_conf.ini
echo "Starting Open vSwitch service ............................................"
systemctl enable openvswitch.service
systemctl start openvswitch.service

echo "Editing /etc/nova.nova.conf .............................................."

sed -i "/\[neutron\]/a \
url = http://$CONTROLLER_IP:9696\n\
auth_strategy = keystone\n\
admin_auth_url = http://$CONTROLLER_IP:35357/v2.0\n\
admin_tenant_name = service\n\
admin_username = neutron\n\
admin_password = $SERVICE_PWD" /etc/nova/nova.conf


ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

cp /usr/lib/systemd/system/neutron-openvswitch-agent.service \
  /usr/lib/systemd/system/neutron-openvswitch-agent.service.orig
sed -i 's,plugins/openvswitch/ovs_neutron_plugin.ini,plugin.ini,g' \
  /usr/lib/systemd/system/neutron-openvswitch-agent.service
echo "Starting compute services................................................."
systemctl enable libvirtd.service openstack-nova-compute.service
systemctl start libvirtd.service
systemctl start openstack-nova-compute.service
systemctl enable neutron-openvswitch-agent.service
systemctl start neutron-openvswitch-agent.service

echo "Creating a physical volume for cinder storage ............................"
pvcreate /dev/sdb
vgcreate cinder-volumes /dev/sdb
echo "Installling Cinder packages..............................................."
yum -y install openstack-cinder targetcli python-oslo-db MySQL-python
echo -n "Editing /etc/cinder/cinder.conf ......................................."
sed -i.bak "/\[database\]/a connection = mysql://cinder:$SERVICE_PWD@$CONTROLLER_IP/cinder" /etc/cinder/cinder.conf
sed -i '0,/\[DEFAULT\]/s//\[DEFAULT\]\
rpc_backend = rabbit\
rabbit_host = '"$CONTROLLER_IP"'\
auth_strategy = keystone\
my_ip = '"$L_HOST_IP"'\
iscsi_helper = lioadm/' /etc/cinder/cinder.conf
sed -i "/\[keystone_authtoken\]/a \
auth_uri = http://$CONTROLLER_IP:5000/v2.0\n\
identity_uri = http://$CONTROLLER_IP:35357\n\
admin_tenant_name = service\n\
admin_user = cinder\n\
admin_password = $SERVICE_PWD" /etc/cinder/cinder.conf
echo "[DONE]"
echo "Starting cinder services.................................................."
systemctl enable openstack-cinder-volume.service target.service
systemctl start openstack-cinder-volume.service target.service
echo "Creating Compute crediantials ............................................"
echo 'export OS_TENANT_NAME=admin' > compute_creds
echo 'export OS_USERNAME=admin' >> compute_creds
echo 'export OS_PASSWORD='"$ADMIN_PWD" >> compute_creds
echo 'export OS_AUTH_URL=http://'"$CONTROLLER_IP"':35357/v2.0' >> compute_creds
source compute_creds

echo " Rebooting the server to complete the installation........................"
reboot