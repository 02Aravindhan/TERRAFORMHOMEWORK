 ## project4: Use Project 03 as Data Block and Create Additional Resources

* First we have  depand to  data block create the  Resource Group for 'project4-rg"
* Virtual Machine (VM): Deploy a VM in Subnet 01.
* NICs are used by virtual machines (VMs) to communicate with the network. 
   A NIC connects a VM to a specific subnet and can have one or more IP configurations.
* Load Balancer: Set up a load balancer to distribute traffic across VMs.
* Storage Account: Add a storage account for the VM.
* Disk encryption: ensures that data stored on Azure disks is secure. This is critical for compliance and data protection.
  Using a managed key, you can control  the encryption keys used.
* Encrypt Disk: Encrypt the VM disk using Customer Managed Key (CMK) from Azure Key Vault.
* We need to create the Azure Key valut service to store the VM username and password.