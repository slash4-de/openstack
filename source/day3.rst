Learn OpenStack in 4 Hours
___________________________

DAY-3: More Funny Things Ahead .................! 
---------------------------------------------------------------------------------------------

In the earlier session, you worked with disk volumes and snapshots. I hope you gained some useful information from that session.

Today we will take you to another advanced level of OpenStack operation. This session will focus on :


	1.	Working with Images

	2.	Working with Containers

	3.	Tightening your Security

	4.	Working with Databases

	


1.	Working with Images
-----------------------------------------

Talking in context of OpenStack, an image or otherwise a virtual machine image is nothing but a virtual disk file containing a bootable operating system. 
OpenStack uses an image as a source to create a new virtual machine instance. As a cloud adminstrator or a user you may need to upload and maintain VM images for your cloud.
Both OpenStack dashboard as well as command line tools can be used to manage images for the cloud.

Please note that, besides command line tools like 'glance' and 'nova; you can also use the necessary APIs to maintain images.

Never confuse when you hear people saying , images or virtual machine images or virtual appliances. 
They all simply mean a virtual machine image. For simplification we will use the term 'image' to refer to virtual machine image or a virtual appliance.

In fact, without an image, the Openstack cloud is not very purposeful. So images have vital importance!

Before actually using the methods to maintain images, you must know the types and formats of images used in virtualized environments.

Images come in various formats because of the variety of hypervisors available today. Below are a few major image formats:

Raw
===

As the name indicates, this is the most simplest form of an image. KVM and Xen hypervisors love it ( and ofcourse they support it!) 
It is infact a block device file just like one created using the 'dd' command. 

We do not ask you to always use dd comand to create a raw disk image as we will discuss laters on how to create a raw image. 

qcow2
=====

QCOW2 stands for QEMU copy-on-write version 2. KVM hypervisor uses this format very commonly. There are some enhanced features provided by qcow2 over raw format which are:

	a.	It uses sparse representation which results into a smaller image size.

	b.	It supports creating disk snapshots

	c.	Due to being smaller in size, it takes less time to upload.

	d. 	OpenStack will automatically convert a raw image into qcow2 as it supports snapshots. (which is not the case with raw images)
	

AMI/AKI/ARI
========

It was the first format that was supported by Amazon Elastic Compute Cloud (Amazon EC2). The three files are:

	a.	AMI (Amazon Machine Image) is the image in raw format.
	
	b.	AKI (Amazon Kernel Image) it is the kernel ( vmlinuz) file which is laoded by the linux kernel for booting.
	
	c.	ARI (Amazon Ramdisk Image) is the ramdisk (initrd) file optionally mounted at boot time. 



UEC tarball
========

Ubuntu Enterprise Cloud (UEC)  is the tar file which contains an AMI/AKI/ARI bundle, packaged and gzipped into a single tar file.

UEC was initially build using Ubuntu and Eucalyptus cloud framework which was later on replaced with OpenStack.

VMDK
=====

Virtual Machine Disk (VMDK) format is used by VMWare's ESXi hypervisor.

VDI
====

Virtual Disk Image is a format used by VirtualBox. OpenStack Compute hypervisors do not support it straight forward. You need to convert it to qcow2 or raw to be able to use it with OpenStack.


VHD
====

Virtual Hard Disk (VHD) format is used by Microsoft Hyper-V

VHDX
====

VHDX is an upgraded version of VHD that can support larger disk size and also provides features to guard against data corruption during power failures.

OVF
===

Distributed Management Task Force (DMTF) devised the Open Virtualization Format (OVF).  OpenStack Compute does not directly support OVF packages. You will need to  extract the image file(s) from an OVF package to be able to use it with OpenStack.

ISO
===

It is the image file format most commonly used for CDs and DVDs. But since an ISO contains a bootable filesystem along with an operating system, it can be used as a virtual machine image.


1.1	Upload An Image
-------------------------------------

Now let's get back to some practical work and upload an image to our OpenStack cloud.

Follow this procedure to upload an image to a project:

Log in to the dashboard as you did before.

Under the project tab, go to compute and click on images..

This will display the images page as displayed in the screenshot below:

|image1|


Click Create Image.

The 'Create An Image' dialog box appears.

Enter the following values:

	a.	Name		A meaningful name for the image

	b.	Description	Enter a brief description of the image.

	c.	Image Source	Choose an image source. This could be "Image Location"  or "Image File". . If  you are downloading from Internet then select Image location otherwise if you are loading it from local disk then select image file.
	
	e.	Format		This is the image format either qcow2 or raw..

Below screenshot depicts the steps:

|image2|



	f.	Architecture				This can be for example  i386 for a 32-bit architecture or x86_64 for a 64-bit architecture.
	
	g.	Minimum Disk (GB) and Minimum RAM (MB)	You may leave it as empty.
	
	h.	Copy Data				If enabled, it will copy image data to the Image service.
	
	i.	Public					If enabled, it will make the image public to all users with access to the current project.
	
	j.	Protected	Select this 			If enabled, it will ensure that only users with permissions can delete the image.

Click Create Image.

The steps are also depicted in the screenshot  below:

|image3|

You have put this image in queue waiting to be uploaded. After some time it will change it status from Queued to Active.

1.2	Delete an Image
------------------------------------

Deletion of images is permanent and cannot be reversed. Only users with the appropriate permissions can delete images.

Log in to the dashboard.
From the CURRENT PROJECT on the Project tab, select the appropriate project.
On the Project tab, open the Compute tab and click Images category.
Select the images that you want to delete.
Click Delete Images.

The steps are shown in the below screenshot as well

|image4|

In the Confirm Delete Images dialog box, click Delete Images to confirm the deletion.


2.	Working With Containers
---------------------------------------------------------

In OpenStack Object Storage, containers provide storage for objects in a manner similar to a Windows folder or Linux file directory, though they cannot be nested. 
An object in OpenStack consists of the file to be stored in the container and any accompanying metadata.

Create a container

Log in to the dashboard.
From the CURRENT PROJECT on the Project tab, select the appropriate project.
On the Project tab, open the Object Store tab and click Containers category.
Click Create Container.
In the Create Container dialog box, enter a name for the container, and then click Create Container.
You have successfully created a container.


Upload an object

Log in to the dashboard.

From the CURRENT PROJECT on the Project tab, select the appropriate project.

On the Project tab, open the Object Store tab and click Containers category.

Select the container in which you want to store your object.

Click Upload Object.

The Upload Object To Container: <name> dialog box appears. ``<name>`` is the name of the container to which you are uploading the object.

Enter a name for the object.

Browse to and select the file that you want to upload.

Click Upload Object.

You have successfully uploaded an object to the container


Manage an object

To edit an object

Log in to the dashboard.

From the CURRENT PROJECT on the Project tab, select the appropriate project.

On the Project tab, open the Object Store tab and click Containers category.

Select the container in which you want to store your object.

Click More and choose Edit from the dropdown list.

The Edit Object dialog box is displayed.

Browse to and select the file that you want to upload.

Click Update Object.



To copy an object from one container to another

Log in to the dashboard.
From the CURRENT PROJECT on the Project tab, select the appropriate project.
On the Project tab, open the Object Store tab and click Containers category.
Select the container in which you want to store your object.
Click More and choose Copy from the dropdown list.
In the Copy Object launch dialog box, enter the following values:
Destination Container: Choose the destination container from the list.
Path: Specify a path in which the new copy should be stored inside of the selected container.
Destination object name: Enter a name for the object in the new container.
Click Copy Object.







3.	Tightening Your Security
---------------------------------------------

Before you launch an instance, you should add security group rules to enable users to ping and use SSH to connect to the instance. Security groups are sets of IP filter rules that define networking access and are applied to all instances within a project. To do so, you either add rules to the default security group Add a rule to the default security group or add a new security group with rules.

Key pairs are SSH credentials that are injected into an instance when it is launched. To use key pair injection, the image that the instance is based on must contain the cloud-init package. Each project should have at least one key pair. For more information, see the section Add a key pair.

If you have generated a key pair with an external tool, you can import it into OpenStack. The key pair can be used for multiple instances that belong to a project. For more information, see the section Import a key pair.

When an instance is created in OpenStack, it is automatically assigned a fixed IP address in the network to which the instance is assigned. This IP address is permanently associated with the instance until the instance is terminated. However, in addition to the fixed IP address, a floating IP address can also be attached to an instance. Unlike fixed IP addresses, floating IP addresses are able to have their associations modified at any time, regardless of the state of the instances involved.

Add a rule to the default security group

This procedure enables SSH and ICMP (ping) access to instances. The rules apply to all instances within a given project, and should be set for every project unless there is a reason to prohibit SSH or ICMP access to the instances.

This procedure can be adjusted as necessary to add additional security group rules to a project, if your cloud requires them.

Note
When adding a rule, you must specify the protocol used with the destination port or source port.

Log in to the dashboard.

From the CURRENT PROJECT on the Project tab, select the appropriate project.

On the Project tab, open the Compute tab and click Access & Security category. The Security Groups tab shows the security groups that are available for this project.

Select the default security group and click Manage Rules.

To allow SSH access, click Add Rule.

In the Add Rule dialog box, enter the following values:

Rule: SSH
Remote: CIDR

Note
To accept requests from a particular range of IP addresses, specify the IP address block in the CIDR box.

Click Add.

Instances will now have SSH port 22 open for requests from any IP address.

To add an ICMP rule, click Add Rule.

In the Add Rule dialog box, enter the following values:

Rule: All ICMP
Remote: Ingress
Click Add.

Instances will now accept all incoming ICMP packets.


Add a key pair

Create at least one key pair for each project.

Log in to the dashboard.
From the CURRENT PROJECT on the Project tab, select the appropriate project.
On the Project tab, open the Compute tab and click Access & Security category.
Click the Key Pairs tab, which shows the key pairs that are available for this project.
Click Create Key Pair.
In the Create Key Pair dialog box, enter a name for your key pair, and click Create Key Pair.
Respond to the prompt to download the key pair.

Import a key pair

Log in to the dashboard.

From the CURRENT PROJECT on the Project tab, select the appropriate project.

On the Project tab, open the Compute tab and click Access & Security category.

Click the Key Pairs tab, which shows the key pairs that are available for this project.

Click Import Key Pair.

In the Import Key Pair dialog box, enter the name of your key pair, copy the public key into the Public Key box, and then click Import Key Pair.

Save the *.pem file locally.

To change its permissions so that only you can read and write to the file, run the following command:

$ chmod 0600 yourPrivateKey.pem
 Note
If you are using the Dashboard from a Windows computer, use PuTTYgen to load the *.pem file and convert and save it as *.ppk. For more information see the WinSCP web page for PuTTYgen.

To make the key pair known to SSH, run the ssh-add command.

$ ssh-add yourPrivateKey.pem
The Compute database registers the public key of the key pair.

The Dashboard lists the key pair on the Access & Security tab.


4.	Working With Databases
------------------------------------------------

The Database service provides scalable and reliable cloud provisioning functionality for both relational and non-relational database engines. Users can quickly and easily use database features without the burden of handling complex administrative tasks.




Create a database instance

Prerequisites. Before you create a database instance, you need to configure a default datastore and make sure you have an appropriate flavor for the type of database instance you want.

Configure a default datastore.

Because the dashboard does not let you choose a specific datastore to use with an instance, you need to configure a default datastore. The dashboard then uses the default datastore to create the instance.

Add the following line to /etc/trove/trove.conf:

default_datastore = DATASTORE_NAME
Replace ``DATASTORE_NAME`` with the name that the administrative user set when issuing the trove-manage command to create the datastore. You can use the trove datastore-list command to display the datastores that are available in your environment.

For example, if your MySQL datastore name is set to mysql, your entry would look like this:

default_datastore = mysql
Restart Database services on the controller node:

# service trove-api restart
# service trove-taskmanager restart
# service trove-conductor restart
Verify flavor.

Make sure an appropriate flavor exists for the type of database instance you want.

Create database instance. Once you have configured a default datastore and verified that you have an appropriate flavor, you can create a database instance.

Log in to the dashboard.

From the CURRENT PROJECT on the Project tab, select the appropriate project.

On the Project tab, open the Database tab and click Instances category. This lists the instances that already exist in your environment.

Click Launch Instance.

In the Launch Database dialog box, specify the following values.

Details

Database Name: Specify a name for the database instance.

Flavor: Select an appropriate flavor for the instance.

Volume Size: Select a volume size. Volume size is expressed in GB.

Initialize Databases: Initial Database

Optionally provide a comma separated list of databases to create, for example:

database1, database2, database3

Initial Admin User: Create an initial admin user. This user will have access to all the databases you create.

Password: Specify a password associated with the initial admin user you just named.

Host: Optionally, allow the user to connect only from this host. If you do not specify a host, this user will be allowed to connect from anywhere.

Click the Launch button. The new database instance appears in the databases list.

Backup and restore a database

You can use Database services to backup a database and store the backup artifact in the Object Storage module. Later on, if the original database is damaged, you can use the backup artifact to restore the database. The restore process creates a database instance.

This example shows you how to back up and restore a MySQL database.

To backup the database instance
Log in to the dashboard.

From the CURRENT PROJECT on the Project tab, select the appropriate project.

On the Project tab, open the Database tab and click Instances category. This displays the existing instances in your system.

Click Create Backup.

In the Backup Database dialog box, specify the following values:

Name

Specify a name for the backup.

Database Instance

Select the instance you want to back up.

Click Backup. The new backup appears in the backup list.

To restore a database instance
Now assume that your original database instance is damaged and you need to restore it. You do the restore by using your backup to create a new database instance.

Log in to the dashboard.

From the CURRENT PROJECT on the Project tab, select the appropriate project.

On the Project tab, open the Database tab and click Backups category. This lists the available backups.

Check the backup you want to use and click Restore Backup.

In the Launch Database dialog box, specify the values you want for the new database instance.

Click the Restore From Database tab and make sure that this new instance is based on the correct backup.

Click Launch.

The new instance appears in the database instances list.

Update a database instance

You can change various characteristics of a database instance, such as its volume size and flavor.

To change the volume size of an instance
Log in to the dashboard.
From the CURRENT PROJECT on the Project tab, select the appropriate project.
On the Project tab, open the Database tab and click Instances category. This displays the existing instances in your system.
Check the instance you want to work with. In the Actions column, expand the drop down menu and select Resize Volume.
In the Resize Database Volume dialog box, fill in the New Size field with an integer indicating the new size you want for the instance. Express the size in GB, and note that the new size must be larger than the current size.
Click Resize Database Volume.
To change the flavor of an instance
Log in to the dashboard.
From the CURRENT PROJECT on the Project tab, select the appropriate project.
On the Project tab, open the Database tab and click Instances category. This displays the existing instances in your system.
Check the instance you want to work with. In the Actions column, expand the drop down menu and select Resize Instance.
In the Resize Database Instance dialog box, expand the drop down menu in the New Flavor field. Select the new flavor you want for the instance.
Click Resize Database Instance.




.. |image1| image:: media/d3_image1.png
.. |image2| image:: media/d3_image2.png
.. |image3| image:: media/d3_image3.png
.. |image4| image:: media/d3_image4.png
.. |image5| image:: media/d3_image5.png
.. |image6| image:: media/d3_image6.png
.. |image7| image:: media/d3_image7.png
.. |image8| image:: media/d3_image8.png
.. |image9| image:: media/d3_image9.png
.. |image10| image:: media/d3_image10.png
.. |image11| image:: media/d3_image11.png
.. |image12| image:: media/d3_image12.png
.. |image13| image:: media/d3_image13.png
.. |image14| image:: media/d3_image14.png
