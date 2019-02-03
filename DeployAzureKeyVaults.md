[Back to main page](DeploymentOutline.md)

# Deploy Azure Key Vaults

At least two key vaults will need to be deployed to support the solution. If VMs will be 
deployed in multiple regions, then deploy additional encryption key vaults in the 
corresponding regions. Azure Disk Encryption requires Key Vaults to be in the same 
region as VMs that will be encrypted.

### Deploy "Secrets AKV" into its own RG. This AKV will be used to store deployment secrets. 
#### Key Vault name and Resource Group will be used in later deployments.
Run the following PowerShell from the CloudShell to create the key vault in target subscription. 

```PowerShell
# Create Azure Key Vault to be used for secrets. Update with appropriate names for your design
$rgName = "ResourceGroupName-mySecretsAKV"
$location ="SpecifyRegion"
$keyVaultName = "mySecretsAKV"

# for test environment do not enable softDelete
New-AzureRmResourceGroup -Name $rgName -Location $location
New-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $rgName -Location $location `
-Sku Standard `
-EnabledForDeployment `
-EnabledForTemplateDeployment

# for pre-prod and prod environment create AKV with softdelete and purge protection
New-AzureRmResourceGroup -Name $rgName -Location $location
New-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $rgName -Location $location `
-Sku Standard  `
-EnabledForDeployment `
-EnabledForTemplateDeployment `
-EnableSoftDelete `
-EnablePurgeProtection

```



### Deploy "Encryption AKV" into its own RG. This AKV will be used for VM encryption in the primary region.
#### Key Vault name and Resource Group will be used in later deployments. 
Run the following PowerShell from the CloudShell to create the key vault in target subscription.
```PS
# Create Azure Key Vault to be used for Azure Disk Encryption. Update with appropriate names for your design
$rgName = "ResourceGroupName-myADEAKV"
$location ="SpecifyRegion - must be the same as where VMs will be deployed at"
$keyVaultName = "myADEAKV"

# for test environment do not enable softDelete
New-AzureRmResourceGroup -Name $rgName -Location $location
New-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $rgName -Location $location `
-Sku Standard `
-EnabledForDiskEncryption

# for pre-prod and prod environment create AKV with softdelete and purge protection
New-AzureRmResourceGroup -Name $rgName -Location $location
New-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $rgName -Location $location `
-Sku Standard `
-EnabledForDiskEncryption `
-EnableSoftDelete `
-EnablePurgeProtection
```


### Post Deployment Configurations

#### Diagnostics Logging
It is important to log diagnostics and audit for each Key Vault. 
You can use the following PowerShell script to configure it. 
Run it from the CloudShell targeting individually each Key Vault. 


```PS
# Configure Key Vault with diagnostics
# Update parameters to match your design

$KeyVaultName = "KeyVault-Name"
$KeyVaultrg = "KeyVault-RG"
$LogAnalyticsName = "ASC-LogAnalytics-Workspace"
$LogAnalyticsRG = "ASC-LogAnalytics-Workspace-RG"
$StorageAccountName = "xxxxxnetworkxxxxx" #Name of the Storage account for Key Vault diagnostics. It was created in prior deployment step. 
$StorageAccountRG = "storageaccountRG"
$RetentionDays = "90" #update with desired interval


$KeyVault=Get-AzureRmKeyVault -Name $KeyVaultName -ResourceGroupName $KeyVaultrg
$Oms=Get-AzureRmOperationalInsightsWorkspace -ResourceGroupName $LogAnalyticsRG -Name $LogAnalyticsName
$sa=Get-AzureRmStorageAccount -ResourceGroupName $StorageAccountRG -AccountName $StorageAccountName


Set-AzureRmDiagnosticSetting -ResourceId $KeyVault.ResourceId -WorkspaceId $Oms.ResourceId -StorageAccountId $sa.Id `
-Enabled $true `
-RetentionEnabled $true `
-RetentionInDays $RetentionDays
```

##### Add Key Vault Management Solution to Log Analytics
The Key Vault Solution allows you to understand the usage of your Key Vault's. Available features include:
- Summary of Operations by Operation Name
- Failed Operations
- Operation Latency
Recommended Searches to explore data further and be added to your own Custom Dashboards, or used to generate Alerts, for example:
- Events by Caller IP Address
- Vault properties updated
- Graph of Avg DurationMs for each Operation
- Min, Max, Avg DurationMs for all Operations

Add Key Vault Solution via Azure portal https://azuremarketplace.microsoft.com/en-us/marketplace/apps/microsoft.keyvaultanalyticsoms?tab=overview 


Reference: 
- https://docs.microsoft.com/en-us/azure/key-vault/
- https://docs.microsoft.com/en-us/azure/azure-monitor/insights/azure-key-vault
- https://docs.microsoft.com/en-us/azure/azure-monitor/insights/solutions
- https://docs.microsoft.com/en-us/powershell/module/azurerm.keyvault/?view=azurermps-6.13.0#key_vault

[Back to main page](DeploymentOutline.md)