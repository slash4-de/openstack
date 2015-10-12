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
--------------------------------------


Before you get your hands dirty with creating disk volumes, you should first understand what a volume is .

Openstack provides several block storage types  and 'Volume Storage' is one of them.

Let's explain OpenStack storage types in a bit more depth.

You must know that OpenStack offers mainly two categories of block storage:

	1.  Ephemeral  storage

	2.  Persistent volumes 

Ephemeral Storage
==============

The life of instance guarentees the life of ephermeral storage. This means when the VM instance is deleted/terminated, the ephermeral storage will be deleted too. 

Below are few important facts you must remember about ephermeral storage:

	1.	Alghough ephermeral storage does not persist across deletions/terminations of VM instances however they persist across the reboots of the VM instance or the guiest operating system.

	2. 	Every instance must have some ephermeral storage.

	3.	The association of an emphermeral storage is unique. It can only be associated with a single instance at a time.
	
	4.	The size of ephermeral storage varies with the flavor of the instance.
	
	5.	Typically the root filesystem for a VM instance is created on ephermeral storage.

	6.	A few flavors provide more than one ephermeral storage disks with varying sizes. This is used by the guest operating system for creating filesystems and storing data.

Persistant Volume Storage
===================

Now you know what is an ephermeral disk storage in OpenStack terminology. Let' talk about a disk volume next.

	1.	These are virtualized block devices which are by default independent of any VM instance.
	
	2.	Volumes can be attached to single instance at a time. This means concurrent access from two VM instances at the same time is not possible. 
		However it is possible to detach a volume from one instance and attach it to another running instance.

 	3.	Since the volumes are custom created by the user, therefore they can be of any size depending upon the avaialbe quota and limits.

	4. 	By default, volumes are created with empty filesystems and as raw block devices.
	
	5.	Before formatting a volume or creating a filesystem on it, you need to attach it with an instance.

	6.	Volumes can be used in a same manner as an external disk.
 
	7.	You can have the disk volume even if you distroy the instance and its root disk.  


Ok. so far so good! Let's create a new disk volume.

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

|image4|

In this image, you can see that this volume is not attached to any instance and therfore the field 'Attached To' is empty. 



2.  Create a Snapshot of a Volume
---------------------------------------------
Let's understand a few conceptual things about Snapshots before we actually create one.

	1.	A snapshot is also a block storage that is persistant like a volume and can be created from a volume. 

	2.	In fact, it is a read-only image or copy of a volume that is taken in a specific point in time. 

	3.	A snapshot can be created from a volume that is available otherwise it is also possible to create a snapshot that is in use ( this is called forceful creation)

	4.	A new volume can be created using a snapshot as well.

Action time ! Let's create a volume !

	1. Click on the drop down menu under 'Actions' field in the row where the newly created volume is displayed.

	2. Select 'Create Snapshot' 

|image5|

A popup window will appear. You will need to fill out the details about the snapshopt as below:

	1.	A meaningful name for the snapshot

	2.	A description for the snapshot

	3.	Click on 'Create Volume Snapshot'


|image6|


3. Attach a Volume To an Instance
-------------------------------------------
As you may remember that you had created a volume earlier but that volume is not being used by any instance. 

So let's make use of it and attach it with our Ubuntu instance that we created at the first day.

Normally attached volumes act as secondary storage for the VM instances but they can also be used as primary storage in a few cases.

To attach a volume to your Ubuntu instance, see you need to taking follwoing steps:

	1.	At the volumes page, go to the row for the volume you created earlier.

	2.	Click at the drop down menu under 'Actions' field 

	3. 	Select 'Manage Attachments'


This is also depicted in the image below:

|image7|

Now you will see a popup window asking for details.  Here you need to click on the drop down menu next to 'Attach to Instance' and then select the Ubuntu instance that you created before.

Next, click on 'Attach Volume'

The steps are also shown in the image below:

|image8|

.. |image1| image:: media/d2_image1.png
.. |image2| image:: media/d2_image2.png
.. |image3| image:: media/d2_image3.png
.. |image4| image:: media/d2_image4.png
.. |image5| image:: media/d2_image5.png
.. |image6| image:: media/d2_image6.png
.. |image7| image:: media/d2_image7.png
.. |image8| image:: media/d2_image8.png
.. |image9| image:: media/d2_image9.png
.. |image10| image:: media/d2_image10.png
.. |image11| image:: media/d2_image11.png
.. |image12| image:: media/d2_image12.png
.. |image13| image:: media/d2_image13.png
.. |image14| image:: media/d2_image14.png
