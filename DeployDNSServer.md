[Back to main page](DeploymentOutline.md)
# Deploy DNS Server

Many customers point their vNets to a DNS server that is not integrated in ADDS. At the same time ADDS is deployed with its own AD integrated DNS.
To simulate this configuration in this solution we need to deploy a separate DNS server that can act the the "3rd party" DNS. 
vNet DNS configured to point to this DNS server. This DNS server is configured with conditional forwarder that points to the ADDS DNS.
This way any device joined to the vNet will be able to find ADDS. 

This type of configuration might not be required for all deployments, but it is provided as part of this solution to accomodate for such specific common configuration.

:heavy_exclamation_mark: **Important:** Before running this deployment you need to swtich vNet DNS settings to use Azure DNS. This is needed because DNS deployment 
needs to download DSC files and to do that it needs to resolve external names. If you do not switch vNet to use Azure DNS, then deployment will fail.

Provided template will deploy the following configuration:

TO DO -> Create diagram and paste it here


### Deploy DNS Server via Browser

```<language>
https://portal.azure.com/microsoft.onmicrosoft.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdmitriilezine%2FAzurePAW-DNSServer%2Fmaster%2FAzurePAW-DNSServer%2Fazuredeploy.json
```

:heavy_exclamation_mark: **Parameters** :heavy_exclamation_mark: Most configuration errors come from specifying wrong parameters. 
Pay extra attension to paramter vaules required by the deployment.

### Deploy DNS Server via PowerShell

If you are planning to test deployment multiple times and run it against the same deployment or new deployment, 
to save time it is recommended to save your custom parameters to the parameters file. You can do this on the first browser deployment, 
first fill in the values for each required parameter then save the parameter file to your computer. Run the following PowerShell to implement DNS Server.

```<language>
$RGName = "DNSServer-ResourceGroupName" #must be present. if not create it prior to running this script
$URI = "https://raw.githubusercontent.com/dmitriilezine/AzurePAW-DNSServer/master/AzurePAW-DNSServer/azuredeploy.json"
$ParFile = "C:\data\DNSServer-parametersFile.json"

Login-AzureRmAccount
New-AzureRmResourceGroupDeployment -ResourceGroupName $RGName -TemplateUri $URI -TemplateParameterFile $ParFile

```
### This deployment will do the following:
- Install Windows 2016 Server VM, install DNS role on it and configure conditional forwarder for provided DNS name and IP address (should be the first ADDS DC)
- It will join VM to the DNSServer subnet
- It will encrypt VM with ADE
- It will configure VM diagnostics with diagnostics storage account
- It will install Microsoft antivirus extension


### Post Deployment Configurations
- Validate via ASC that all VMs are registered with ASC. Validate that they are not showing any red.
- Change vNet DNS configuration to point to the newly deployed DNS server IP address





[Back to main page](DeploymentOutline.md)