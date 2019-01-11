# Secure Deployment and Management of ADDS in Azure IaaS - Implementation

Note on Resource Group strategy: The deployment of the solution is broken down 
into multiple blocks. You can deploy all of them into a single Resource Group, 
can deploy into combination of Resource Groups or can deploy each into its 
own Reosurce Group. This is design choice. 

**Recommendation **- deploy each component into its own Resource Group. This way you 
can delete RG and not affect other solution compoenents (as long as there is no 
dependency...). Also different RBAC can be assigned to individal RGs, if such is 
required by design. You might have as many as dozen or more resource groups associaited with this solution (if chose to use separate components). 
Come up with good naming strategy to quickly identify all RGs and their purpose. For example using this naming template Rg-ADDS-"solution component"-Lab, you will have RGs like 
Rg-ADDS-StorageAccounts-Lab, Rg-ADDS-AKVADE-Lab, Rg-ADDS-vNet-Lab, Rg-ADDS-ADDS-Lab etc

## Use the following steps to deploy ADDS in Azure IaaS and all related security components.

:heavy_exclamation_mark: **Note: Most deployment templates in the following steps use Desired State Configuration (DSC) and PowerShell extenstions. 
DSC and PowerShell code used by the deployments is only available to authorized users. 
If you are not authorised then most deployments will not work.**


1. [Deploy Azure Key Vaults](DeployAzureKeyVaults.md)
2. Identify Log Analytics workspace used by the Azure Security Center for the target Azure subscription. 
    This workspace will be used to log data from deployed resoucres. If Azure Security Center is not enabled then it will need to be enabled. Recommend to use Standard pricing tier to get all advanced features of ASC.
3. [Deploy storage accounts](DeployStorageAccounts.md)
4. [Deploy vNet](DeployvNet.md)
5. [Deploy DNS Server](DeployDNSServer.md)
6. [Deploy Active Directory](DeployADDS.md)
7. [Deploy temporary Jump Server](DeployJumpServer.md). This server will be used for some manual configuration steps in Windows VMs and any troubleshooting during solution test.
8. [Deploy AAD Application Proxy](DeployAADApProxy.md)
9. [Deploy Azure SQL DB for RDS HA](DeployAzureSQL.md)
10. [Deploy RDS](DeployRDS.md)
11. Post ADDS and RDS Deployment configuration
12. [Deploy ADFS](DeployADFS.md)
13. Deploy ADFS Proxy
14. Deploy AAD Connect 
15. Deploy Point to Site VPN (optional)
16. Deploy Addtional Domain Controller
17. Deploy Additional RDS Session Host 
18. Deploy Additonal ADFS Server to existing ADFS farm
19. Deploy addtional Active Directory Forest


	https://www.webfx.com/tools/emoji-cheat-sheet/


