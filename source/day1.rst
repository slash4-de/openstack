LEARN OpenStack in 4 Hours
_____________________________

DAY-1: Your First Dive into OpenStack
--------------------------------------------------

You will create your first ever instance in OpenStack on this first day
of your fast track course. If you have no hardware to install OpenStack,
don’t worry because we have a solution for that!!. We will come on it
later so let’s be patient and start to know more about OpenStack.

OpenStack is an open source cloud computing framework which enables
organizations to build their own private clouds while providing them the
freedom to customize and use the code according to their needs.

We will not bore you with history of OpenStack but one thing is more
important to share with you. OpenStack is really powerful and many
technology giants are using it for building their cloud infrastructure.

OK, let’s get prepared to spin up our own virtual machine in an
OpenStack environment!!

After this course you will know the most important features provided by
OpenStack, what kind of cloud features can it provide, how it can be
used and above all, you will see that how easy it is to be used!

You will feel yourself that OpenStack is really a power full framework.
This is not all about OpenStack!!!. OpenStack can also be used for:

-  Creating and managing virtual machine instances using different operating systems (Linux, Windows.. )

-  Creating and managing virtual storage space and disks

-  Building high available servers.

-  Creating and managing virtual LANS.

-  And many more…

Well for sure, it is not possible to cover everything about OpenStack in
just 4 hours…we will not over burden you with very lengthy discussions
but we will equip you with all the necessary information and tools
necessary to get you going in the fast lane.

So let’s get ready to dive into OpenStack!!!

For this tutorial we are using:

-  A readily available OpenStack Environment from TryStack

-  No other dependencies …….!

SUMMARY OF DAY-1
-----------------------------


Here are the learning objectives for today’s course:

-  Login to OpenStack Dashboard Online

-  Create a new network segment

-  Create a new virtual machine instance using Ubuntu image in OpenStack

-  Create a router for your network segment

-  Assign a floating IP to access the newly created VM over the Internet

-  Setup security policies to secure the access

-  Remotely access the newly created VM instance over the Internet

-  Play around with different commands available in the VM

It’s time to get started now!

1. Login To OpenStack Dashboard Online

Remember we had told you that we have a solution to access an OpenStack
environment online? Below is the link to access TryStack online :

http://trystack.openstack.org/

You will need to join the TryStack Facebook Group in order to get
registered which is pretty easy!! Just click on the button as displayed
in the below screenshot:

|image1|

Once your login has been approved, you can access the dashboard as below:

|image2|

After you have successfully logged in, you are now free to use OpenStack dashboard!. It will look something like below:

|image3|

2. Creating A Network Segment

Before we could create a new virtual machine instance we need to create a network first. To do that let’s follow these steps:

	a. Under Network on the left menu bar, go to Networks and select create Network

|image4|

	b. Under the Network tab, fill in the Network Name and click Next.

|image5|

	c. Under Subnet tab, enter the subnet address in CIDR notation, we will use 192.168.1.0/24 for example. Set IP version as IPv4 and click Next

|image6|

	d. Under Subnet Details tab, set the DNS name server as 8.8.4.4 and 8.8.8.8 on two separate lines respectively and click Create.

|image7|

3.  Creating A New VM Instance Using Ubuntu Image. 
Now we are ready to create our own first VM instance in OpenStack. Let’s go to Compute menu on the menu on the left and then select Instances.

|image8|

	a. A popup window will appear. Under the details section fill out the instance details as below:

-  The availability zone should be nova.

-  Provide an instance name

-  Select an appropriate flavor from the list. For this example we are using ‘m1.medium’

-  Select instance count as 1

-  Select instance boot source as : ‘Boot from Image’

-  Select an appropriate image

This is also shown in the image below:

|image9|

	b. Under ‘Access & Security’, select the default security group. We need to add key pairs in order to be able to login to our new instance after it is created. To create and add a key pair, click on the + button near to ‘Key Pair’ field.

|image10|
	
	c. A new popup window will appear. Enter a name for the key and paste the contents of the public key. You can create the new key according to the instructions on the right.

|image11|

	d. Upon successful import, a message like below will appear:

|image12|

	e. Next, under networking tab, select the network that we created earlier and click on launch button.Below image displays the steps:

|image13|

Once the new instance has been launched, a message like below will be displayed:

|image14|

4. Creating A Router For Your Network Segment

To connect our newly created network with the outside world we need a router wich has interfaces connected to internal and external networks. We need to follow below steps to create a router and add interfaces to it:

	a. Goto 'Network' on the left menu under 'Project' and select 'Routers'. The same is depicted in the image below:

|image15|

Click on 'Create Router' on the right as shown in the image below:

|image16|

Once the router is created, a message like below will be displayed:

|image17|

Once the router is created, we need to add its interfaces. To acheive this we need to follow below steps:
		a. Goto the router details page on the newly created router and click on 'Set Gateway'
|image18|
	
		b. Select the external network and click 'Set Gateway'
|image19|

Now we need an interface to connect with the subnet that we created earlier. To do this, click on 'Add Interface' option under 'Interfaces' tab on router details page. This is shown in the image below:

|image20|

Under subnet, select the network subnet that we created earlier and click on 'Add Interface'.

|image21|

Now to confirm the interface addition, we can view it under network topology. To see the network topology, to 'Network Topology' under Networks as shown below:

|image22|

5. Assign a floating IP Address

A floating IP Address is required to access the VM instance remotely using pubic Ineternet. Floating IPs are ussually public IP Addresses which are routable using Internet.
To assign a flaoting IP, we need to follow below steps:
	a. Under 'Compute', go to 'Instances' and select the instance.

|image23|

After selecting the instance, goto 'More Actions'

|image24|

A popup window like below will appear:

Select the  the port to be associated and click on '+' button under IP Address

|image25|

Select the pool and click on 'Allocate IP' . This will allocate a pulic IP to the newly created instance.

|image26|

6.  Setup Security Policies to Secure the Access

Security policies are required to allow or deny access to the VM instances from outside world. It is used to control the incomming and outgoing traffic to and from the VM instances.
This can be done from 'Access and Security' option under 'Compute' menu option on the left. Following steps need to be followed to accomplish this:
	a. Under 'Compute', goto 'Access and Security' and then goto 'Security Groups' tab.
	
|image27|

	b. Click 'Manage Rules' in the 'default' row.

|image28|	

Let's say we need to allow ping (ICMP), web server traffic (port 80) and SSH traffic to this VM instance from outside.  We need to add three rules for this.
a. Click on 'Add Rule' and select 'ALL ICMP'.
b. Click on 'Add Rule' and select 'SSH'
c. Click on 'Add Rule' and select 'HTTP'

|image29|

Now you can open your faviourite SSH client on your PC/laptop to access your first VM instance remotely.
It will ask for accepting the server's key for the first time as shown in the image below:

|image30|

If you are successful, congratulations! You have logged into your first VM instance remotely. Now you can type the commands to play around!

|image31|

.. |image1| image:: media/image1.png
.. |image2| image:: media/image2.png
.. |image3| image:: media/image3.png
.. |image4| image:: media/image4.png
.. |image5| image:: media/image5.png
.. |image6| image:: media/image6.png
.. |image7| image:: media/image7.png
.. |image8| image:: media/image8.png
.. |image9| image:: media/image9.png
.. |image10| image:: media/image10.png
.. |image11| image:: media/image11.png
.. |image12| image:: media/image12.png
.. |image13| image:: media/image13.png
.. |image14| image:: media/image14.png
.. |image15| image:: media/image15.png
.. |image16| image:: media/image16.png
.. |image17| image:: media/image17.png
.. |image18| image:: media/image18.png
.. |image19| image:: media/image19.png
.. |image20| image:: media/image20.png
.. |image21| image:: media/image21.png
.. |image22| image:: media/image22.png
.. |image23| image:: media/image23.png
.. |image24| image:: media/image24.png
.. |image25| image:: media/image25.png
.. |image26| image:: media/image26.png
.. |image27| image:: media/image27.png
.. |image28| image:: media/image28.png
.. |image29| image:: media/image29.png
.. |image30| image:: media/image30.png
.. |image31| image:: media/image31.png