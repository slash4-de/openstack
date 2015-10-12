Learn OpenStack in 4 Hours
__________________________________

DAY-2: More OpenStack Magic !
---------------------------------------------------------------

In your previous interaction with OpenStack, you learned how to create a new virtual machine instance and associate it with a network.
We hope you enjoyed this! 

Today you will see OpenStack in more action. So let's get started 


Below are the learning objectives for today:

1. 	Creating an empty disk volume	

2.	 Creating a snapshot of a disk volume

3. 	 Attaching the empty disk volume to an instance

4.	Deleting a snapshot

5. 	Detaching a disk volume from a VM instance

6. 	Deleting a disk volume

7. 	Terminating a VM instance


1. Creating an Empty Volume
======================

Before you get your hands dirty with creating disk volumes, you should first understand what a volume is .

Openstack provides several storage types  and 'Volume Storage' is one of them.

Let's explain this in a bit more depth.


OpenStack Block Storage
----------------------------------


OpenStack provides two classes of block storage, "ephemeral" storage and persistent "volumes". 

Ephemeral Storage

Ephemeral storage exists only for the life of an instance, it will persist across reboots of the guest operating system but when the instance is deleted so is the associated storage.
 All instances have some ephemeral storage. 
Ephemeral storage is associated with a single unique instance. Its size is defined by the flavor of the instance.
Data on ephemeral storage ceases to exist when the instance it is associated with is terminated. 
Rebooting the VM or restarting the host server, however, will not destroy ephemeral data.
 In the typical use case an instance's root filesystem is stored on ephemeral storage. 
This is often an unpleasant surprise for people unfamiliar with the cloud model of computing.

In addition to the ephemeral root volume all flavors except the smallest, m1.tiny, provide an additional ephemeral block device varying from 20G for the m1.small through 160G for the m1.xlarge by default - these sizes are configurable. 
This is presented as a raw block device with no partition table or filesystem. 
Cloud aware operating system images may discover, format, and mount this device. 
For example the cloud-init package included in Ubuntu's stock cloud images will format this space as an ext3 filesystem and mount it on /mnt. 
It is important to note this a feature of the guest operating system. 
OpenStack only provisions the raw storage.

Volume Storage


Volumes are persistent virtualized block devices independent of any particular instance. 

Volumes may be attached to a single instance at a time, but may be detached or reattached to a different instance while retaining all data, much like a USB drive.

Volume storage is independent of any particular instance and is persistent. 

Volumes are user created and within quota and availability limits may be of any arbitrary size.

When first created volumes are raw block devices with no partition table and no filesystem. 

They must be attached to an instance to be partitioned and/or formatted. 

Once this is done they may be used much like an external disk drive. 

Volumes may attached to only one instance at a time, but may be detached and reattached to either the same or different instances.

It is possible to configure a volume so that it is bootable and provides a persistent virtual instance similar to traditional non-cloud based virtualization systems. 

In this use case the resulting instance may still have ephemeral storage depending on the flavor selected, but the root filesystem (and possibly others) will be on the persistent volume and thus state will be maintained even if the instance is shutdown. 

Volumes do not provide concurrent access from multiple instances. 

For that you need either a traditional network filesystem like NFS or CIFS or a cluster filesystem such as GlusterFS. 

These may be built within an OpenStack cluster or provisioned outside of it, but are not features provided by the OpenStack software.

A disk volume is a block storage device that you can connect to an instance as a persistant storage. 

Disk volumes can be attached to instances while the instance is running.

Similarly they can be detached in the same manner. 

A disk volume resembles a physical hard disk in practical life.  

You can attach and format it as you format a physical disk. 

You can create a filesystem over it , mount it on a mount point and store data on it.

You can have the disk volume even if you distroy the instance and its root disk.  

This make it possible to keep data on a volume even if you no longer need to keep the VM instance.

Let's create a new disk volume.

	1. Goto  'Project'  and then 'Compute' and 'Volumes'
|image1|
	2. Next select 'Create Volume'  on the right top of the page.

|image2|

A popup menu will appear where you need to fillout the details for the new volume. 
	1. Set a meaningful volume name.

	2. Set a volume description

	3. Select 'No volume source , empty volume'  as we want to create an empty volume here.

	4. Select no volume type.

	5. Set the size of the volume in GB

	6. Select availability zone as 'Nova'

	7. Click on 'Create Volume'

This is depicted in the image below too:


|image3|

After creation of the volume, the newly created volume will be displayed on the volumes page.It may look like somthing below: 

In this image, you can see that this volume is not attached to any instance and therfore the field 'Attached To' is empty. 

|image4|

So let's attach this volume to an instance.

2.  Create a Snapshot of a Volume
=========================

	1. Click on the drop down menu under 'Actions' field in the row where the newly created volume is displayed.
	2. Select 'Create Snapshot' 

|image5|

3. Attach a Volume To an Instance
=========================


.. |image1| image:: media/d2_image1.png
.. |image2| image:: media/d2_image2.png
.. |image3| image:: media/d2_image3.png
.. |image4| image:: media/d2_image4.png
.. |image5| image:: media/d2_image5.png
