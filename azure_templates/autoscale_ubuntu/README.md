### Autoscale a Linux VM Scale Set ###

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FEvoStream%2Fevostream_addons%2Fmaster%2Fazure_templates%2Fautoscale_ubuntu%2Fazuredeploy.json" target="_blank">  <img src="http://azuredeploy.net/deploybutton.png"/></a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FEvoStream%2Fevostream_addons%2Fmaster%2Fazure_templates%2Fautoscale_ubuntu%2Fazuredeploy.json" target="_blank">  <img src="http://armviz.io/visualizebutton.png"/></a>

This template deploys a Linux VM Scale Set integrated with Azure autoscale.

The template deploys a Linux VMSS with a desired count of VMs in the scale set. Once the VM Scale Set is deployed, the user can deploy an application inside each of the VMs (either by directly logging into the VMs or via a custom script extension).

The Autoscale rules are configured as follows:
- Sample for Network Out (\\Processor\\NetworkOut) in each VM every 1 Minute.
- If the Network Out is greater than 50 MB per 1 minute for 5 minutes (equivalent to 0.83 MB/sec or 6.7 mbps average bandwidth), then the scale out action (add more VM instances, one at a time) is triggered.
- Once the scale out action is completed, the cool down period is 1 Minute.
