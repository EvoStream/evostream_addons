### Autoscale a Linux VM Scale Set ###

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FEvoStream%2Fevostream_addons%2Fmaster%2Fazure_templates%2Fautoscale_ubuntu%2Fazuredeploy.json" target="_blank">
  <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FEvoStream%2Fevostream_addons%2Fmaster%2Fazure_templates%2Fautoscale_ubuntu%2Fazuredeploy.json" target="_blank">
  <img src="http://armviz.io/visualizebutton.png"/>
</a>

The following template deploys a Linux VM Scale Set integrated with Azure autoscale

The template deploys a Linux VMSS with a desired count of VMs in the scale set. Once the VM Scale Set is deployed, the user can deploy an application inside each of the VMs (either by directly logging into the VMs or via a custom script extension)

The Autoscale rules are configured as follows:
- sample for Network Out (\\Processor\\NetworkOut) in each VM every 1 Minute
- if the Network Out is greater than 600 MB for 5 minutes (equivalent to 1 MB/sec or 8 mbps total bandwidth), then the scale out action (add more VM instances, one at a time) is triggered
- once the scale out action is completed, the cool down period is 1 Minute
