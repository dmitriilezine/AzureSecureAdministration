[Back to Title Page](README.md)

# Secure Deployment and Management of ADDS in Azure IaaS - Implementation Steps

**Note on Resource Group strategy:** The deployment of the solution is broken down 
into multiple components. You can deploy all solution components into a single Resource Group, 
can deploy into combination of Resource Groups or can deploy each into its 
own Resource Group. This is design choice. **RG Recommendation** - deploy each component into its own Resource Group. This way you 
can delete RG and not affect other solution components (as long as there is no 
dependency...). Also different RBAC can be assigned to individual RGs, if such is 
required by design. You might have as many as dozen or more resource groups associated with this solution. 
Come up with good naming strategy to quickly identify all RGs and their purpose. For example using this naming 
template Rg-ADDS-"solution component"-Lab, you will have RGs like 
Rg-ADDS-StorageAccounts-Lab, Rg-ADDS-AKVADE-Lab, Rg-ADDS-vNet-Lab, Rg-ADDS-ADDS-Lab etc, which are easy to group together

##
> ### **Azure Privileged Access Workstation (Azure PAW)**
- > All of the below deployments have been done/tested from the Azure PAW that was introduced in the [Solution Overview](SolutionOverview.md). 
- > Azure PAW should be used for production, pre-prod and test deployments that lead to production implementation. Azure PAW should be used to manage Azure Control Plane, ADDS and Tier 0 applications.
- > Standard productivity device can be used for proof of concept deployments.
  > Standard productivity/dev device can be used for development/refactoring of the ARM templates, DSC and PowerShell code
## 

## Use the following steps to deploy Secure Management Solution for Azure Virtual Datacenter

:heavy_exclamation_mark: **Note: Most deployment templates in the following steps use Desired State Configuration (DSC) and PowerShell extensions. 
DSC and PowerShell code used by the deployments is only available to authorized users. 
If you are not authorized user then most deployments will not work.**

:boom: If it is not obvious, the following deployments put in order to support other deployments. Deployments will ask for required parameters,
most of which correspond to other already existing resources, like Vnet, Subnets, Key Vaults, Storage accounts etc. 

:mega: All deployments have been tested for deployment with Subscription Contributor RBAC. Lower level RBAC at subscription level or RBAC set 
at individual RG level was not tested for any of the deployments. Lower level RBAC would require RBAC specific testing.

:mega: All deployments have been tested in US West 2 and US South Central only.

##
1. Identify Log Analytics workspace used by the Azure Security Center for the target Azure subscription. 
    This workspace will be used to log data from deployed resources. If Azure Security Center (ASC) is not enabled then it will need to be enabled. 
Recommend to use Standard pricing tier to get all advanced features of ASC.
2. [Deploy storage accounts](DeployStorageAccounts.md)
3. [Deploy Azure Key Vaults](DeployAzureKeyVaults.md)
4. [Deploy vNet](DeployvNet.md)
5. [Deploy DNS Server](DeployDNSServer.md)
6. [Deploy Active Directory](DeployADDS.md)
7. [Deploy temporary Jump Server](DeployJumpServer.md). This server will be used for some manual configuration steps in Windows VMs and any troubleshooting during solution test.
8. [Deploy AAD Application Proxy](DeployAADApProxy.md)
9. [Deploy Azure SQL DB for RDS HA](DeployAzureSQL.md)
10. [Deploy RDS](DeployRDS.md)
11. [Post ADDS and RDS Deployment configuration](PostADDSConfig.md)
12. [Configure Monitoring](ConfigureMonitoring.md)
12. [Deploy ADFS](DeployADFS.md)
13. [Deploy ADFS Proxy](DeployADFSProxy.md)
14. [Deploy AAD Connect](DeployAADConnect.md) 
15. Deploy Point to Site VPN (optional)
16. Deploy additional Domain Controller
17. Deploy additional RDS Session Host 
18. Deploy additional ADFS Server to existing ADFS farm
19. Deploy additional Active Directory Forest


[Back to Title Page](README.md)



	https://www.webfx.com/tools/emoji-cheat-sheet/


