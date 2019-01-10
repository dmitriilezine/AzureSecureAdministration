[Back to main page](DeploymentOutline.md)

# Deploy Azure AD Application Proxy Connectors and Configure Azure AD Application Proxy Application

Azure AD Application Proxy is used to provide secure access to the Remote Desktop Services.

## Generate secure token that will be used for AAD Application Proxy connector registration

- Update [UnattendedAppProxyConnectorTokenGeneratorV1.ps1](/scripts/UnattendedAppProxyConnectorTokenGeneratorV1.ps1) script with "Secrets Key Vault" name that was created in prior step
- Open PowerShell as administrator
- Run UnattendedAppProxyConnectorTokenGeneratorV1.ps1 script
- When prompted, logon with account that has Tenant GA where AAD Application Proxy is going to be configured (this does not have to be the same AAD Tenant with which Azure subscription hosting VMs is associated. For test purposes and POCs the Tenant and subscription might not be assocaited. In production it should be the same secure realm)
- When prompted second time, logon with account that has rights to write to the Azure Key Vault used for storing deployment secrets. This would be the account that have deployment rights in the subscription. First and second accounts can be the same.
- This script will generate a secret that will be used to register AAD Application Proxy Connector and will store this secret in the "Secrets Key Vault"
- Proceed to the next step wihout delay. I could not find for how the generated secret token will be valid, but tests showed that registration was failing after about 30 minutes after token generation (could be due to other reasons). Proceed to deploy connectors immediately after token generation is done and availble in the Key Vault.

## Deploy Azure AD App Proxy Connectors

Provided template will deploy the following configuration:

TO DO -> Create diagram and paste it here

### Deploy AAD App Proxy Connectors via ARM template using browser

```<language>
https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdmitriilezine%2FAzurePAW-ADDProxy%2Fmaster%2FAzurePAW-ADDProxy%2Fazuredeploy.json
```
:heavy_exclamation_mark: Parameters :heavy_exclamation_mark: Most configuration erros come from specifying wrong parameters. 
Pay extra attension to paramter vaules required by the deployment.

### Deploy ADD App Proxy via PowerShell
If you are planning to test deployment multiple times and run it against the same deployment or new deployment, 
to save time it is recommended to save your custom parameters to the parameters file. You can do this on the first browser deployment, 
first fill in the values for each required parameter then save the parameter file to your computer. Run the following PowerShell to implement vNet.

```<language>
$RGName = "ADDProxy-ResourceGroupName" #must be present. if not create it prior to running this script
$URI = "https://raw.githubusercontent.com/dmitriilezine/AzurePAW-ADDProxy/master/AzurePAW-ADDProxy/azuredeploy.json"
$ParFile = "C:\data\ADDProxy-parametersFile.json"

Login-AzureRmAccount
New-AzureRmResourceGroupDeployment -ResourceGroupName $RGName -TemplateUri $URI -TemplateParameterFile $ParFile

```
### This deployment will do the following:
- Install 2 Windows 2016 Server VMs and register them with AAD Application Proxy in the AAD Tenant
- Both VMs are domain joined, and considered Tier 0
- Both VMs put on AADAppProxy subnet
- It will encrypt each VM with ADE
- It will configure each VM diagnostics with diagnostics storage account
- It will install Microsoft antivirus extension in each VM


### Post Deployment Configurations
- Validate via ASC that all VMs are registered with ASC. Validate that they are not showing any red.
- Logon to AAD Tenant where AAD Application proxy is being registered:
    - Verify that 2 VMs have been registered
    - Create new connector group and name it RDS
    - Move new servers from default group to the RDS group
- Configure AAD Application proxy to publish RDS:
  - STEPS to BE DOCUMENTED (AAD application configuration and AAD Conditional access configuration)





[Back to main page](DeploymentOutline.md)