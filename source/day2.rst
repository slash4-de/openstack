Learn OpenStack in 4 Hours
__________________________________

DAY-2: More OpenStack Magic !
---------------------------------------------------------------

In your previous interaction with OpenStack, you learned how to create a new virtual machine instance and associate it with a network.
We hope you enjoyed this! 

Today you will see OpenStack in more action. So let's get started 


Below are the learning objectives for today:

1. 	Creating an empty disk volume

2.	 Attaching the empty disk volume to an instance

3.	 Creating a snapshot of a disk volume

4. 	Deleting a snapshot

5. 	Detaching a disk volume from a VM instance

6. 	Deleting a disk volume

7. 	Terminating a VM instance


A disk volume is a block storage device that you can connect to an instance as a persistant storage. Disk volumes can be attached to instances while the instance is running.
Similarly they can be detached in the same manner. 

A disk volume resembles a physical hard disk in practical life.  You can attach and format it as you format a physical disk. You can create a filesystem over it , mount it on a mount point and store data on it.

You can have the disk volume even if you distroy the instance and its root disk.  This make it possible to keep data on a volume even if you no longer need to keep the VM instance.

Let's create a new disk volume.

	1. Goto  'Project'  and then 'Compute' and 'Volumes'
|image1|
	2. Next select 'Create Volume'  on the right top of the page.

|image2|




|image3|

|image4|



.. |image1| image:: media/d2_image1.png
.. |image2| image:: media/d2_image2.png
.. |image3| image:: media/d2_image3.png
.. |image4| image:: media/d2_image4.png

