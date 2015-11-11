#!/bin/bash
# Name : controller-install.sh
# Author: Imran Ahmed <researcher6@experthelpme.com>
# Description : This script installs the OpenStack CONTROLLER Node.

#Load config file
echo -n "Loading configuration file ............................................"
source controller.conf
echo "[DONE]"

#Install NTP Service...
echo  "Installing NTP service .................................................."
yum -y install ntp
systemctl enable ntpd.service
systemctl start ntpd.service
echo " [DONE]"

#Install OpenStack repos
echo  "Installing OpenStack repos..............................................."
yum -y install yum-plugin-priorities
yum -y install epel-release
yum -y install http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm
yum -y upgrade
echo "[DONE]"

#yum -y install openstack-selinux

# Disabling firewall service
echo -n " Disabling firewall service............................................"
systemctl stop firewalld.service
systemctl disable firewalld.service
sed -i 's/enforcing/disabled/g' /etc/selinux/config
echo 0 > /sys/fs/selinux/enforce
echo "[DONE]"


#Database service installation
echo -n "Installing database service............................................"
yum -y install mariadb mariadb-server MySQL-python
echo "[DONE]"

#Edit /etc/my.cnf
echo -n "Editing 'my.cnf'......................................................."
sed -i.bak "10i\\
bind-address = $CONTROLLER_IP\n\
default-storage-engine = innodb\n\
innodb_file_per_table\n\
collation-server = utf8_general_ci\n\
init-connect = 'SET NAMES utf8'\n\
character-set-server = utf8\n\
" /etc/my.cnf
echo "[DONE]"


echo -n "Starting database service.............................................."
systemctl enable mariadb.service
systemctl start mariadb.service
echo "[DONE]"

echo "Starting MySQL secure installation........................................"
mysql_secure_installation


#create databases
echo "Setting databases........................................................."
echo 'Enter new MySQL root password'
mysql -u root -p <<EOF
CREATE DATABASE keystone;
CREATE DATABASE neutron;
CREATE DATABASE nova;
CREATE DATABASE cinder;
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$SERVICE_PWD';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$SERVICE_PWD';
FLUSH PRIVILEGES;
EOF

echo "Installing messaging services............................................."
yum -y install rabbitmq-server
echo -n "Starting messaging service............................................."
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
echo "[DONE]"

echo "Installing Keystone services.............................................."
yum -y install openstack-keystone python-keystoneclient
echo -n "Editing keystone configuration configuration file......................"
sed -i.bak "s/#admin_token=ADMIN/admin_token=$ADMIN_TOKEN/g" /etc/keystone/keystone.conf
sed -i "/\[database\]/a \
connection = mysql://keystone:$SERVICE_PWD@$CONTROLLER_IP/keystone" /etc/keystone/keystone.conf
sed -i "/\[token\]/a \
provider = keystone.token.providers.uuid.Provider\n\
driver = keystone.token.persistence.backends.sql.Token\n" /etc/keystone/keystone.conf
echo "[DONE]"


echo -n "Finalizing keystone setup ............................................."
keystone-manage pki_setup --keystone-user keystone --keystone-group keystone
chown -R keystone:keystone /var/log/keystone
chown -R keystone:keystone /etc/keystone/ssl
chmod -R o-rwx /etc/keystone/ssl
su -s /bin/sh -c "keystone-manage db_sync" keystone
echo "[DONE]"

echo -n "Starting keystone service.............................................."
systemctl enable openstack-keystone.service
systemctl start openstack-keystone.service
echo "[DONE]"

echo -n "Setting cron job for token purging....................................."
(crontab -l -u keystone 2>&1 | grep -q token_flush) || \
  echo '@hourly /usr/bin/keystone-manage token_flush >/var/log/keystone/keystone-tokenflush.log 2>&1' \
  >> /var/spool/cron/keystone
echo "[DONE]"

echo "Creating keystone tokens , users and tenants.............................."
export OS_SERVICE_TOKEN=$ADMIN_TOKEN
export OS_SERVICE_ENDPOINT=http://$CONTROLLER_IP:35357/v2.0
keystone tenant-create --name admin --description "Admin Tenant"
keystone user-create --name admin --pass $ADMIN_PWD
keystone role-create --name admin
keystone user-role-add --tenant admin --user admin --role admin
keystone role-create --name _member_
keystone user-role-add --tenant admin --user admin --role _member_
keystone tenant-create --name demo --description "Demo Tenant"
keystone user-create --name demo --pass password
keystone user-role-add --tenant demo --user demo --role _member_
keystone tenant-create --name service --description "Service Tenant"
keystone service-create --name keystone --type identity \
  --description "OpenStack Identity"
keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ identity / {print $2}') \
  --publicurl http://$CONTROLLER_IP:5000/v2.0 \
  --internalurl http://$CONTROLLER_IP:5000/v2.0 \
  --adminurl http://$CONTROLLER_IP:35357/v2.0 \
  --region regionOne
unset OS_SERVICE_TOKEN OS_SERVICE_ENDPOINT

echo -n "Creating credientials file............................................."
echo "export OS_TENANT_NAME=admin" > controller_creds
echo "export OS_USERNAME=admin" >> controller_creds
echo "export OS_PASSWORD=$ADMIN_PWD" >> controller_creds
echo "export OS_AUTH_URL=http://$CONTROLLER_IP:35357/v2.0" >> controller_creds
source controller_creds
echo "[DONE]"


echo -n "Creating keystone entries for glance service..........................."
keystone user-create --name glance --pass $SERVICE_PWD
keystone user-role-add --user glance --tenant service --role admin
keystone service-create --name glance --type image \
  --description "OpenStack Image Service"
keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ image / {print $2}') \
  --publicurl http://$CONTROLLER_IP:9292 \
  --internalurl http://$CONTROLLER_IP:9292 \
  --adminurl http://$CONTROLLER_IP:9292 \
  --region regionOne
echo "Created keystone entries for glance successfully."

echo "Installing glance service................................................."
yum -y install openstack-glance python-glanceclient

echo -n "Editing glance-api.conf................................................"
sed -i.bak "/\[database\]/a \
connection = mysql://glance:$SERVICE_PWD@$CONTROLLER_IP/glance" /etc/glance/glance-api.conf

sed -i "/\[keystone_authtoken\]/a \
auth_uri = http://$CONTROLLER_IP:5000/v2.0\n\
identity_uri = http://$CONTROLLER_IP:35357\n\
admin_tenant_name = service\n\
admin_user = glance\n\
admin_password = $SERVICE_PWD" /etc/glance/glance-api.conf

sed -i "/\[paste_deploy\]/a \
flavor = keystone" /etc/glance/glance-api.conf

sed -i "/\[glance_store\]/a \
default_store = file\n\
filesystem_store_datadir = /var/lib/glance/images/" /etc/glance/glance-api.conf
echo ".................[DONE]"

echo -n "Editing /etc/glance/glance-registry.conf..............................."

sed -i.bak "/\[database\]/a \
connection = mysql://glance:$SERVICE_PWD@$CONTROLLER_IP/glance" /etc/glance/glance-registry.conf

sed -i "/\[keystone_authtoken\]/a \
auth_uri = http://$CONTROLLER_IP:5000/v2.0\n\
identity_uri = http://$CONTROLLER_IP:35357\n\
admin_tenant_name = service\n\
admin_user = glance\n\
admin_password = $SERVICE_PWD" /etc/glance/glance-registry.conf
sed -i "/\[paste_deploy\]/a \
flavor = keystone" /etc/glance/glance-registry.conf
echo "[DONE]"
echo "Running DB sync..........................................................."
su -s /bin/sh -c "glance-manage db_sync" glance
echo -n "Starting glance service................................................"
systemctl enable openstack-glance-api.service openstack-glance-registry.service
systemctl start openstack-glance-api.service openstack-glance-registry.service
echo "[DONE]"
echo "Installing wget .........................................................."
yum -y install wget
echo " Downloading cirros image................................................."
wget http://cdn.download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img
echo -n  "Creating a glance image..............................................."
glance image-create --name "cirros-0.3.3-x86_64" --file cirros-0.3.3-x86_64-disk.img \
  --disk-format qcow2 --container-format bare --is-public True --progress
echo "[DONE]"

echo -n "Creating keystone entries for NOVA....................................."
keystone user-create --name nova --pass $SERVICE_PWD
keystone user-role-add --user nova --tenant service --role admin
keystone service-create --name nova --type compute \
  --description "OpenStack Compute"

  keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ compute / {print $2}') \
  --publicurl http://$CONTROLLER_IP:8774/v2/%\(tenant_id\)s \
  --internalurl http://$CONTROLLER_IP:8774/v2/%\(tenant_id\)s \
  --adminurl http://$CONTROLLER_IP:8774/v2/%\(tenant_id\)s \
  --region regionOne

echo "[DONE]"

echo "Installing NOVA components required for controller........................"
yum -y install openstack-nova-api openstack-nova-cert openstack-nova-conductor \
  openstack-nova-console openstack-nova-novncproxy openstack-nova-scheduler \
  python-novaclient

echo "Editing /etc/nova/nova.conf..............................................."

sed -i.bak "/\[database\]/a \
connection = mysql://nova:$SERVICE_PWD@$CONTROLLER_IP/nova" /etc/nova/nova.conf

sed -i "/\[DEFAULT\]/a \
rpc_backend = rabbit\n\
rabbit_host = $CONTROLLER_IP\n\
auth_strategy = keystone\n\
my_ip = $CONTROLLER_IP\n\
vncserver_listen = $CONTROLLER_IP\n\
vncserver_proxyclient_address = $CONTROLLER_IP\n\
network_api_class = nova.network.neutronv2.api.API\n\
security_group_api = neutron\n\
linuxnet_interface_driver = nova.network.linux_net.LinuxOVSInterfaceDriver\n\
firewall_driver = nova.virt.firewall.NoopFirewallDriver" /etc/nova/nova.conf

sed -i "/\[keystone_authtoken\]/i \
[database]\nconnection = mysql://nova:$SERVICE_PWD@$CONTROLLER_IP/nova" /etc/nova/nova.conf

sed -i "/\[keystone_authtoken\]/a \
auth_uri = http://$CONTROLLER_IP:5000/v2.0\n\
identity_uri = http://$CONTROLLER_IP:35357\n\
admin_tenant_name = service\n\
admin_user = nova\n\
admin_password = $SERVICE_PWD" /etc/nova/nova.conf
sed -i "/\[glance\]/a host = $CONTROLLER_IP" /etc/nova/nova.conf

sed -i "/\[neutron\]/a \
url = http://$CONTROLLER_IP:9696\n\
auth_strategy = keystone\n\
admin_auth_url = http://$CONTROLLER_IP:35357/v2.0\n\
admin_tenant_name = service\n\
admin_username = neutron\n\
admin_password = $SERVICE_PWD\n\
service_metadata_proxy = True\n\
metadata_proxy_shared_secret = $META_PWD" /etc/nova/nova.conf
echo "[DONE]"

echo "Running DB Sync"
su -s /bin/sh -c "nova-manage db sync" nova
echo "Starting NOVA service....................................................."
systemctl enable openstack-nova-api.service openstack-nova-cert.service \
  openstack-nova-consoleauth.service openstack-nova-scheduler.service \
  openstack-nova-conductor.service openstack-nova-novncproxy.service
systemctl start openstack-nova-api.service openstack-nova-cert.service \
  openstack-nova-consoleauth.service openstack-nova-scheduler.service \
  openstack-nova-conductor.service openstack-nova-novncproxy.service
echo "Creating keystone entries for Neutron....................................."

keystone user-create --name neutron --pass $SERVICE_PWD
keystone user-role-add --user neutron --tenant service --role admin
keystone service-create --name neutron --type network \
  --description "OpenStack Networking"
keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ network / {print $2}') \
  --publicurl http://$CONTROLLER_IP:9696 \
  --internalurl http://$CONTROLLER_IP:9696 \
  --adminurl http://$CONTROLLER_IP:9696 \
  --region regionOne

echo "Installing neutron services required at controller........................"

yum -y install openstack-neutron openstack-neutron-ml2 python-neutronclient which

echo -n "Editing /etc/neutron/neutron.conf ....................................."
sed -i.bak "/\[database\]/a \
connection = mysql://neutron:$SERVICE_PWD@$CONTROLLER_IP/neutron" /etc/neutron/neutron.conf

SERVICE_TENANT_ID=$(keystone tenant-list | awk '/ service / {print $2}')

sed -i '0,/\[DEFAULT\]/s//\[DEFAULT\]\
rpc_backend = rabbit\
rabbit_host = '"$CONTROLLER_IP"'\
auth_strategy = keystone\
core_plugin = ml2\
service_plugins = router\
allow_overlapping_ips = True\
notify_nova_on_port_status_changes = True\
notify_nova_on_port_data_changes = True\
nova_url = http:\/\/'"$CONTROLLER_IP"':8774\/v2\
nova_admin_auth_url = http:\/\/'"$CONTROLLER_IP"':35357\/v2.0\
nova_region_name = regionOne\
nova_admin_username = nova\
nova_admin_tenant_id = '"$SERVICE_TENANT_ID"'\
nova_admin_password = '"$SERVICE_PWD"'/' /etc/neutron/neutron.conf

sed -i "/\[keystone_authtoken\]/a \
auth_uri = http://$CONTROLLER_IP:5000/v2.0\n\
identity_uri = http://$CONTROLLER_IP:35357\n\
admin_tenant_name = service\n\
admin_user = neutron\n\
admin_password = $SERVICE_PWD" /etc/neutron/neutron.conf
echo "[DONE]"

echo -n "Editing /etc/neutron/plugins/ml2/ml2_conf.ini.........................."
sed -i "/\[ml2\]/a \
type_drivers = flat,gre\n\
tenant_network_types = gre\n\
mechanism_drivers = openvswitch" /etc/neutron/plugins/ml2/ml2_conf.ini

sed -i "/\[ml2_type_gre\]/a \
tunnel_id_ranges = 1:1000" /etc/neutron/plugins/ml2/ml2_conf.ini

sed -i "/\[securitygroup\]/a \
enable_security_group = True\n\
enable_ipset = True\n\
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver" /etc/neutron/plugins/ml2/ml2_conf.ini
echo "[DONE]"

echo "Starting Neutron service on controller node..............................."

ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade juno" neutron
systemctl restart openstack-nova-api.service openstack-nova-scheduler.service \
  openstack-nova-conductor.service
systemctl enable neutron-server.service
systemctl start neutron-server.service
echo "[DONE]"

echo "Installing OpenStack Horizon Dashboard...................................."
yum -y install openstack-dashboard httpd mod_wsgi memcached python-memcached
echo -n "Editing /etc/openstack-dashboard/local_settings ......................."

sed -i.bak "s/ALLOWED_HOSTS = \['horizon.example.com', 'localhost'\]/ALLOWED_HOSTS = ['*']/" /etc/openstack-dashboard/local_settings
sed -i 's/OPENSTACK_HOST = "127.0.0.1"/OPENSTACK_HOST = "'"$CONTROLLER_IP"'"/' /etc/openstack-dashboard/local_settings
echo "[DONE]"

echo -n "Starting OpenStack dashboard (Horizon)................................."
setsebool -P httpd_can_network_connect on
chown -R apache:apache /usr/share/openstack-dashboard/static
systemctl enable httpd.service memcached.service
systemctl start httpd.service memcached.service
echo "[DONE]"

echo "Creating keystone entries for cinder service.............................."
keystone user-create --name cinder --pass $SERVICE_PWD
keystone user-role-add --user cinder --tenant service --role admin
keystone service-create --name cinder --type volume \
  --description "OpenStack Block Storage"
keystone service-create --name cinderv2 --type volumev2 \
  --description "OpenStack Block Storage"
keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ volume / {print $2}') \
  --publicurl http://$CONTROLLER_IP:8776/v1/%\(tenant_id\)s \
  --internalurl http://$CONTROLLER_IP:8776/v1/%\(tenant_id\)s \
  --adminurl http://$CONTROLLER_IP:8776/v1/%\(tenant_id\)s \
  --region regionOne
keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ volumev2 / {print $2}') \
  --publicurl http://$CONTROLLER_IP:8776/v2/%\(tenant_id\)s \
  --internalurl http://$CONTROLLER_IP:8776/v2/%\(tenant_id\)s \
  --adminurl http://$CONTROLLER_IP:8776/v2/%\(tenant_id\)s \
  --region regionOne
echo "Installing cinder packages at controller.................................."
yum -y install openstack-cinder python-cinderclient python-oslo-db

echo -n "Editing /etc/cinder/cinder.conf ......................................."
sed -i.bak "/\[database\]/a connection = mysql://cinder:$SERVICE_PWD@$CONTROLLER_IP/cinder" /etc/cinder/cinder.conf

sed -i "/\[DEFAULT\]/a \
rpc_backend = rabbit\n\
rabbit_host = $CONTROLLER_IP\n\
auth_strategy = keystone\n\
my_ip = $CONTROLLER_IP" /etc/cinder/cinder.conf

sed -i "/\[keystone_authtoken\]/a \
auth_uri = http://$CONTROLLER_IP:5000/v2.0\n\
identity_uri = http://$CONTROLLER_IP:35357\n\
admin_tenant_name = service\n\
admin_user = cinder\n\
admin_password = $SERVICE_PWD" /etc/cinder/cinder.conf
echo "[DONE]"

echo "Starting cinder service at controller....................................."
su -s /bin/sh -c "cinder-manage db sync" cinder
systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service
systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service

echo "Now rebooting the server.................................................."
reboot