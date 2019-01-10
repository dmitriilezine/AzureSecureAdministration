# Secure Deployment and Management of ADDS in Azure IaaS - Implementation

Note on Resource Group strategy: The deployment of the solution is breaken down 
into multiple blocks. You can deploy all of them into a single Resource Group, 
can deploy into combination of Resource Groups or can deploy each into its 
own Reosurce Group. This is design choice. 
Recommendation - deploy each component into its own Resource Group. This way you 
can delete RG and not affect other solution compoenents (as long as there is no 
dependency...). Also different RBAC can be assigned to individal RGs, if such is 
required by design.

## Use the following steps to deploy ADDS in Azure IaaS and all related components.

:heavy_exclamation_mark: **Note: Most deployment templates in the following steps use Desired State Configuration (DSC) and PowerShell extenstions. 
DSC and PowerShell code used by the deployments is only available to authorized users. 
If you are not authorised then most deployments will not work.**


1. [Deploy Azure Key Vaults](DeployAzureKeyVaults.md)
2. 	Identify Log Analytics workspace used by the Azure Security Center for the target Azure subscription. 
    This workspace will be used to log data from deployed resoucres. If Azure Security Center is not enabled then it will need to be enabled. Recommend to use Standard pricing tier to get all advanced features of ASC.
3. 	Deploy storage accounts that will be used for VM diagnostic, network logging and SQL audit. Click on the following link to initiate deployment in your target Tenant/Subscription.
```<language>
	https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdmitriilezine%2FAzurePAW-StorageAccounts%2Fmaster%2FAzurePAW-StorageAccounts%2Fazuredeploy.json
```
	

> 	This ARM template will create three storage accounts. One account will be used for VM diagnostics, second for NSG diagnostics logging and third account for Azure SQL audit logging.
If more storage accounts are required by the design, then modify template as needed.
**Note:** if your Azure AD account has access to multiple tenants/subscriptions, and when you click on the URL it targets wrong tenant, you will need to insert your desired tenant into the url as follows:

	https://portal.azure.com/YOURTARGETTENANT.onmicrosoft.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdmitriilezine%2FAzurePAW-StorageAccounts%2Fmaster%2FAzurePAW-StorageAccounts%2Fazuredeploy.json


4. [Deploy vNet](DeployvNet.md)
5. [Deploy DNS Server](DeployDNSServer.md)
6. [Deploy temporary Jump Server](DeployJumpServer.md). This server will be used for some manual configuration steps in Windows VMs and any troubleshooting during solution test.
7. [Deploy Active Directory](DeployADDS.md)
8. [Deploy AAD Application Proxy](DeployAADApProxy.md)
9. [Deploy Azure SQL DB for RDS HA](DeployAzureSQL.md)
10. [Deploy RDS](DeployRDS.md)
11. Post ADDS and RDS Deployment configuration
11. [Deploy ADFS](DeployADFS.md)
12. Deploy ADFS Proxy
14. Deploy AAD Connect 
15. Deploy Point to Site VPN (optional)
16. Deploy Addtional Domain Controller
17. Deploy Additional RDS Session Host 
18. Deploy Additonal ADFS Server to existing ADFS farm
19. Deploy addtional Active Directory Forest


	https://www.webfx.com/tools/emoji-cheat-sheet/


