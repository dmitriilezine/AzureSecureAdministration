[Back to main page](DeploymentOutline.md)
# Deploy Jump Server
Temporary jump server is needed to finish configuration of the RDS and to provide troubleshooting during 
deployment modifications and testing.

Jump server is deployed into its own subnet with restricted communication to the jump server from the Internet 
and to the target VMs in the solution deployment. 

For inbound Internet access it is restricted by the specified source IP address of the client device. NSG rule will allow 
access on port TCP3389 only from the specified source IP address. This IP address should be the IP of the device from which 
troubleshooting operations are performed. 

During normal operations, this jump server should be shutdown or completely removed from the environment. If emergency access
is required, it can be quickly redeployed into this subnet and provide such access.

Provided template will deploy the following configuration:

TO DO -> Create diagram and paste it here


### Deploy Jump Server via Browser

```<language>
https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdmitriilezine%2FAzurePAW-POC-JumpServer%2Fmaster%2FAzurePAW-POC-JumpServer%2Fazuredeploy.json
```

:heavy_exclamation_mark: Parameters :heavy_exclamation_mark: Most configuration erros come from specifying wrong parameters. 
Pay extra attension to paramter vaules required by the deployment.

### Deploy Jump Server via PowerShell

If you are planning to test deployment multiple times and run it against the same deployment or new deployment, 
to save time it is recommended to save your custom parameters to the parameters file. You can do this on the first browser deployment, 
first fill in the values for each required parameter then save the parameter file to your computer. Run the following PowerShell to implement vNet.

```<language>
$RGName = "JumpServer-ResourceGroupName" #must be present. if not create it prior to running this script
$URI = "https://raw.githubusercontent.com/dmitriilezine/AzurePAW-POC-JumpServer/master/AzurePAW-POC-JumpServer/azuredeploy.json"
$ParFile = "C:\data\JumpServer-parametersFile.json"

Login-AzureRmAccount
New-AzureRmResourceGroupDeployment -ResourceGroupName $RGName -TemplateUri $URI -TemplateParameterFile $ParFile

```
### This deployment will do the following:
- Install Windows 2016 Server VM on JumpServer subnet


### Post Deployment Configurations
- Update Source IP to public IP of the client device that will need to connect to it - this is done via JumpServer NSG which can be found in vNet RG


[Back to main page](DeploymentOutline.md)