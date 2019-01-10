# Deploy Azure Key Vaults

At least two key vaults will need to be deployed to support the solution. If VMs will be 
deployed in multiple regions, then deploy addtional ancryption key vaults in the 
corresponding regions. Azure Disk Encryption requires Key Vaults to be in the same 
region as VMs that will be encrypted.

### Deploy "Secrets AKV" into its own RG. This AKV will be used to store deployment secrets. 
#### Key Vault name and Resource Group will be used in later deployments.
Run the follwing PowerShell from the CloudShell to create the key vault in target subscription. 

```
# Create Azure Key Vault to be used for secrets. Update with appropriate names for your design
$rgName = "ResourceGroupName-mySecretsAKV"
$location ="SpecifyRegion"
$keyVaultName = "mySecretsAKV"

# for test environment do not enable softDelete
New-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $rgName -Location $location `
-Sku Standard `
-EnabledForDeployment `
-EnabledForTemplateDeployment

# for pre-prod and prod environment create AKV with softdelete and purge protection
New-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $rgName -Location $location `
-Sku Standard  `
-EnabledForDeployment `
-EnabledForTemplateDeployment `
-EnableSoftDelete `
-EnablePurgeProtection

```



### Deploy "Encryption AKV" into its own RG. This AKV will be used for VM encryption in the primary region.
#### Key Vault name and Resource Group will be used in later deployments.
Run the follwing PowerShell from the CloudShell to create the key vault in target subscription.
```
# Create Azure Key Vault to be used for Azure Disk Encryption. Update with appropriate names for your design
$rgName = "ResourceGroupName-myADEAKV"
$location ="SpecifyRegion - must be the same as where VMs will be deployed at"
$keyVaultName = "myADEAKV"

# for test environment do not enable softDelete
New-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $rgName -Location $location `
-Sku Standard `
-EnabledForDiskEncryption

# for pre-prod and prod environment create AKV with softdelete and purge protection
New-AzureRmKeyVault -VaultName $keyVaultName -ResourceGroupName $rgName -Location $location `
-Sku Standard `
-EnabledForDiskEncryption `
-EnableSoftDelete `
-EnablePurgeProtection
```

[Back to main page](DeploymentOutline.md)