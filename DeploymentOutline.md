[Back to Title Page](README.md)

# Secure Deployment and Management of ADDS in Azure IaaS - Implementation

Note on Resource Group strategy: The deployment of the solution is broken down 
into multiple blocks. You can deploy all of them into a single Resource Group, 
can deploy into combination of Resource Groups or can deploy each into its 
own Reosurce Group. This is design choice. 

**Recommendation** - deploy each component into its own Resource Group. This way you 
can delete RG and not affect other solution compoenents (as long as there is no 
dependency...). Also different RBAC can be assigned to individal RGs, if such is 
required by design. You might have as many as dozen or more resource groups associaited with this solution (if chose to use separate components). 
Come up with good naming strategy to quickly identify all RGs and their purpose. For example using this naming template Rg-ADDS-"solution component"-Lab, you will have RGs like 
Rg-ADDS-StorageAccounts-Lab, Rg-ADDS-AKVADE-Lab, Rg-ADDS-vNet-Lab, Rg-ADDS-ADDS-Lab etc

> **Azure Privileged Access Workstation (Azure PAW)**
- > All of the below deployments can be done from the Azure PAW that was introduced in the [Solution Overview](SolutionOverview.md). 
- > Azure PAW should be used for prodcution, pre-prod and test deployments that lead to production implementation..
- > Standard device can be used for proof of concept and development.
# 
:mega: All deployments have been tested for deployment with Subscription Contributor RBAC. Lower level RBAC was not used
for any of the deployments. Lower level RBAC would require RBAC specific testing. 

:mega: All deployments have been tested in US West 2 and US South Central only.

## Use the following steps to deploy Secure Management Solution for Azure Virtual Datacenter (Azure Components)

:heavy_exclamation_mark: **Note: Most deployment templates in the following steps use Desired State Configuration (DSC) and PowerShell extenstions. 
DSC and PowerShell code used by the deployments is only available to authorized users. 
If you are not authorised then most deployments will not work.**

:boom: If it is not obvious, the following deployments put in order to support other deployments. Do not attempt to deploy
ADDS if you did not complete prior steps. It probably depends on all or some of them to be successfully completed.


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
11. [Post ADDS and RDS Deployment configuration](PostADDSConfig.md)
12. [Deploy ADFS](DeployADFS.md)
13. [Deploy ADFS Proxy](DeployADFSProxy.md)
14. [Deploy AAD Connect](DeployAADConnect.md) 
15. Deploy Point to Site VPN (optional)
16. Deploy Addtional Domain Controller
17. Deploy Additional RDS Session Host 
18. Deploy Additonal ADFS Server to existing ADFS farm
19. Deploy addtional Active Directory Forest


[Back to Title Page](README.md)



	https://www.webfx.com/tools/emoji-cheat-sheet/


