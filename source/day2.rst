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

A disk volume is a block storage device that you can connect to an instance as a persistant storage. Disk volumes can be attached to instances while the instance is running.
Similarly they can be detached in the same manner. 

A disk volume resembles a physical hard disk in practical life.  You can attach and format it as you format a physical disk. You can create a filesystem over it , mount it on a mount point and store data on it.

You can have the disk volume even if you distroy the instance and its root disk.  This make it possible to keep data on a volume even if you no longer need to keep the VM instance.

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
