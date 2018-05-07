# Deploy EMS 2.0.1 on Ubuntu 16.04

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FEvoStream%2Fevostream_addons%2Fmaster%2Fazure_templates%2Fems201_ubuntu1604%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FEvoStream%2Fevostream_addons%2Fmaster%2Fazure_templates%2Fems201_ubuntu1604%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template deploys the EvoStream Media Server version 2.0.1 on Ubuntu 16.04.

After deployment, view the EMS Web UI by browsing:
> http://[EMS_IP]:4100/

where [EMS_IP] is the IP address of the deployed VM. The default Web UI username is "admin" and the default password is the Computer name (or VM name). If everything is OK, the EMS ONLINE status indicator should show green on the Web UI Dashboard.

When the EMS is running, you should be able to play the demo video remotely using VLC with this URL:
> rtmp://[EMS_IP]/vod/bunny.mp4

To modify the EMS settings, you should connect to the VM via SSH using username "admin001" and password "Password_1234". Please change the password as soon as possible for security reasons.

_Note: For those not familiar with SSH, please use the Azure portal to reset the password._

For EMS Web UI documentation, please refer to:
http://docs.evostream.com/2.0/userguide_webuioverview.html
