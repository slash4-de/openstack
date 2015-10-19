Learn OpenStack in 4 Hours
___________________________

DAY-3: More Funny Things Ahead .................! 
---------------------------------------------------------------------------------------------

In the earlier session, you worked with disk volumes and snapshots. I hoped you gained some useful information from that session.

Today we will take you to another advanced level of OpenStack operation. This session will focus on :


	1.	Working with Images

	2.	Creating Network Shared Folders

	3.	Tightening Your Security

	4.	Working With Containers


1.	Working with Images
-----------------------------------------

In the context of OpenStack, an image or otherwise a virtual machine image is nothing but a virtual disk file containing a bootable operating system. 
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

Distributed Management Task Force (DMTF) devised the Open Virtualization Format (OVF).  OpenStack Compute does not directly support OVF packages. You need to convert it to qcow2 or raw format to be able to use it with OpenStack.

OpenStack Compute does not currently have support for OVF packages, so you will need to extract the image file(s) from an OVF package if you wish to use it with OpenStack.

ISO
===

It is the image file format most commonly used for CDs and DVDs. But since an ISO contains a bootable filesystem along with an operating system, it can be used as a virtual machine image.


Upload an image

Follow this procedure to upload an image to a project:

Log in to the dashboard.

From the CURRENT PROJECT on the Project tab, select the appropriate project.

On the Project tab, open the Compute tab and click Images category.

Click Create Image.

The Create An Image dialog box appears.

Enter the following values:

Name	Enter a name for the image.
Description	Enter a brief description of the image.
Image Source	Choose the image source from the dropdown list. Your choices are Image Location and Image File.
Image File or Image Location	Based on your selection for Image Source, you either enter the location URL of the image in the Image Location field, or browse for the image file on your file system and add it.
Format	Select the image format (for example, QCOW2) for the image.
Architecture	Specify the architecture. For example, i386 for a 32-bit architecture or x86_64 for a 64-bit architecture.
Minimum Disk (GB) and Minimum RAM (MB)	Leave these fields empty.
Copy Data	Specify this option to copy image data to the Image service.
Public	Select this check box to make the image public to all users with access to the current project.
Protected	Select this check box to ensure that only users with permissions can delete the image.

Click Create Image.

The image is queued to be uploaded. It might take some time before the status changes from Queued to Active
Update an image¶

Follow this procedure to update an existing image.

Log in to the dashboard.
From the CURRENT PROJECT on the Project tab, select the appropriate project.
On the Project tab, open the Compute tab and click Images category.
Select the image that you want to edit.
In the Actions column, click More and then select Edit Image from the list.
In the Update Image dialog box, you can perform the following actions:
Change the name of the image.
Select the Public check box to make the image public.
Clear the Public check box to make the image private.
Click Update Image.
Delete an image¶

Deletion of images is permanent and cannot be reversed. Only users with the appropriate permissions can delete images.

Log in to the dashboard.
From the CURRENT PROJECT on the Project tab, select the appropriate project.
On the Project tab, open the Compute tab and click Images category.
Select the images that you want to delete.
Click Delete Images.
In the Confirm Delete Images dialog box, click Delete Images to confirm the deletion.



[Note]	Note

The Image service and other OpenStack projects do not currently support the container format. It is safe to specify bare as the container format if you are unsure.

You can set the container format for your image to one of the following values:

bare. The image does not have a container or metadata envelope.

ovf. The OVF container format.

aki. An Amazon kernel image.

ari. An Amazon ramdisk image.

ami. An Amazon machine image.

Image metadata
============


Image metadata can help end users determine the nature of an image, and is used by associated OpenStack components and drivers which interface with the Image service.

Metadata can also determine the scheduling of hosts. If the property option is set on an image, and Compute is configured so that the ImagePropertiesFilter scheduler filter is enabled (default), then the scheduler only considers compute hosts that satisfy that property.

[Note]	Note

Compute's ImagePropertiesFilter value is specified in the scheduler_default_filter value in the /etc/nova/nova.conf file.

You can add metadata to Image service images by using the --property key=value parameter with the glance image-create or glance image-update command. More than one property can be specified.

Common image properties are also specified in the /etc/glance/schema-image.json file.
All associated properties for an image can be displayed using the glance image-show command.

Volume-from-Image properties
When creating Block Storage volumes from images, also consider your configured image properties. If you alter the core image properties, you should also update your Block Storage configuration. Amend glance_core_properties in the /etc/cinder/cinder.conf file on all controller nodes to match the core properties you have set in the Image service.


 Get images

The simplest way to obtain a virtual machine image that works with OpenStack is to download one that someone else has already created. Most of the images contain the cloud-init package to support SSH key pair and user data injection. Because many of the images disable SSH password authentication by default, boot the image with an injected key pair. You can SSH into the instance with the private key and default login account. See the OpenStack End User Guide for more information on how to create and inject key pairs with OpenStack.



2.	Creating Network Shared Folders
---------------------------------------------------------





3.	Tightening Your Security
---------------------------------------------



4.	Working With Containers
----------------------------------------------


|image1|




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
