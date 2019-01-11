[Back to main page](DeploymentOutline.md)


# Deploy RDS
RDS is used to securely access Tier 0 of the deployed solution. 

Provided template will deploy the following configuration:

TO DO -> Create diagram and paste it here

### Deploy RDS via ARM template using browser
Use the following link to initiate deployment in your target Tenant/Subscription.
```<language>
https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdmitriilezine%2FAzurePAW-RDS%2Fmaster%2FAzurePAW-RDS%2Fazuredeploy.json
```
:heavy_exclamation_mark: **Parameters** :heavy_exclamation_mark: Most configuration errors come from specifying wrong parameters. 
Pay extra attension to paramter vaules required by the deployment.

### Deploy RDS via PowerShell
If you are planning to test deployment multiple times and run it against the same deployment or new deployment, 
to save time it is recommended to save your custom parameters to the parameters file. You can do this on the first browser deployment, 
first fill in the values for each required parameter then save the parameter file to your computer. Run the following PowerShell to implement RDS.

```<language>
$RGName = "RDS-ResourceGroupName" #must be present. if not create it prior to running this script
$URI = "https://raw.githubusercontent.com/dmitriilezine/AzurePAW-RDS/master/AzurePAW-RDS/azuredeploy.json"
$ParFile = "C:\data\RDS-parametersFile.json"

Login-AzureRmAccount
New-AzureRmResourceGroupDeployment -ResourceGroupName $RGName -TemplateUri $URI -TemplateParameterFile $ParFile

```
### This deployment will do the following:
- Install 7 Windows 2016 Server VMs
- 1 VM will be configured as RDS Connection Broker & Licensing Server
- 1 VM will be configured as RDS Gateway & Web Access
- 1 VM will be configured as RDS Session Host
- Additonal 4 VMs will need to manually added to RDS configuration post deployment
- VMs for CB and GW (4 VMs) are placed on the RDS subnet
- VMs for Session Hosts (3 VMs) are placed on the RDSSessionHosts subnet
- VMs for Session Hosts (3 VMs) configured with RSAT tools to manage ADDS - need to identify any other required tools to be installed
- Create ILB in front of RDS CB
- Create ILB in front of RDS Gateway and Web
- DNS records created pointing RDS and Gateway to respective IP addresses for each ILB
- Download provided PFX certifcates to Connection Broker for postdeployment configuration
- All VMs are domain joined, and considered Tier 0
- It will encrypt each VM with ADE
- It will configure each VM diagnostics with diagnostics storage account
- It will install Microsoft antivirus extension in each VM


### Post Deployment Configurations
- Validate via ASC that all VMs are registered with ASC. Validate that they are not showing any red.
- Steps to finish configuration of RDS to BE DEVELOPED




[Back to main page](DeploymentOutline.md)