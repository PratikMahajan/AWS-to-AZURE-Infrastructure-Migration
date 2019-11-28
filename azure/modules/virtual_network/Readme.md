# Virtual Network 

AWS Internet Gateway is a pathway used by your VPC instances to direct traffic to \
the internet and vice versa having a 1 to 1 relationship associated with the \
traffic leaving and coming into your VPC instances.

Azure infrastructure automatically source NATs the Azure Virtual Network private IP \
address of the instance to the public IP address assigned to it by the address space \
defined in the Virtual Network. So it takes care of representing the private IP of \
the instance as the associated public IP address thereby presenting your instance \
as a public entity. This would be for outbound traffic. For inbound traffic to your\
instance, the public IP address is automatically mapped to the private IP of the \
instance thereby facilitating a 1 to 1 relationship of the public and private IP \
address as mentioned earlier.

As far as route tables are concerned, Azure has system defined routes that \
take care of the above process for any traffic within the VNet and also from the \
Internet. The system routes take care of most of the routing needs and you do not \
need to worry about this. One of the system routes is the Internet Rule which \
handles all traffic destined to the public Internet (address prefix 0.0.0.0/0) \
and uses the infrastructure internet gateway as the next hop for all traffic \
destined to the Internet. However, if you want the traffic to be routed to a \
specific instances (for example a Network Virtual Appliance for Firewall or \
internal NAT) then you can set a UDR and IP forwarding to route the traffic via \
the NVA but this will only apply for internal private IP addresses native to the \
VNet subnets and not the internet traffic.


[Source](https://social.msdn.microsoft.com/Forums/en-US/814ccee0-9fbb-4c04-8135-49d0aaea5f38/equivalent-of-aws-internet-gateways-in-azure?forum=WAVirtualMachinesVirtualNetwork)