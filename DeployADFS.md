[Back to main page](DeploymentOutline.md)

# Deploy ADFS Farm into ADDS

### Prepare ADFS Federation Service Certificate for deployment
- For production you can use trusted certficate from internal or external PKI authority. You'll need to have PFX file.
- For test and lab deployment you can issue certifcate from the CA that is installed as 
part of ADDS deployment. Use "Azure PAW Web Server" certificate template to issue custom certificate and save it as PFX.
- Push PFX file with ADFS federation service certificate to the "Secrets Key Vault". It will be installed on ADFS VMs 
during VM deployment and then used by ADFS installation as the Federation Service certificate.
- To push PFX file to Key Vault, use the following steps:
  - Copy PFX file to the CloudDrive in CloudShell
  - In CloudShell change folder to the CloudDrive and verify that the file is there
  - In CloudShell run the following PowewrShell, after updating parameters
```<language>
$vaultName = "SecretsKeyVault"     # this is Secrets Key Vault created in prior steps
$secretName = "ADFSCert"           # name of the secret that will be created in Key Vault and hold the PFX data
$certPassword = "password"         # PFX file password
$fileName = "sts.contoso.com.pfx"  # name of the PFX file you uploaded to your CloudShell CloudDrive


# Read and covert PFX into secret for Key Vault
$fileContentBytes = Get-Content -Path $fileName -AsByteStream -ReadCount 0
$fileContentEncoded = [System.Convert]::ToBase64String($fileContentBytes)

$jsonObject = @"
{
  "data": "$fileContentEncoded",
  "dataType" :"pfx",
  "password": "$certPassword"
}
"@

$jsonObjectBytes = [System.Text.Encoding]::UTF8.GetBytes($jsonObject)
$jsonEncoded = [System.Convert]::ToBase64String($jsonObjectBytes)

# Push secret to Key vault
$secret = ConvertTo-SecureString -String $jsonEncoded -AsPlainText –Force
Set-AzureKeyVaultSecret -VaultName $vaultName -Name $secretName -SecretValue $secret 
```
  - It will create a secret in the target key vault. You will reference this secret as parameter during ADFS deployment.

### Verify that ADFS Delta GPO is configured in ADDS and is applied to the Identity OU
ADFS delta GPO is deployed during ADDS deployment. There is a bug in the deployment and this GPO does not get all 
settings migrated from the source file. Currently, until this bug is fixed, you will need to fix this GPO before ADFS VMs can be moved to the 
"T0 Identity" OU. To do this you will need to power up JumpServer, access DC and reimport delta ADFS GPO. It is stored on the DC.

### Deploy ADFS Farm

Provided template will deploy the following configuration:

TO DO -> Create diagram and paste it here

### Deploy ADFS via ARM template using browser

```<language>
https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdmitriilezine%2FAzurePAW-ADFS%2Fmaster%2FAzurePAW-ADFS%2Fazuredeploy.json
```
:heavy_exclamation_mark: **Parameters** :heavy_exclamation_mark: Most configuration errors come from specifying wrong parameters. 
Pay extra attension to paramter vaules required by the deployment.

### Deploy ADFS via PowerShell
If you are planning to test deployment multiple times and run it against the same deployment or new deployment, 
to save time it is recommended to save your custom parameters to the parameters file. You can do this on the first browser deployment, 
first fill in the values for each required parameter then save the parameter file to your computer. Run the following PowerShell to implement vNet.

```<language>
$RGName = "ADFS-ResourceGroupName" #must be present. if not create it prior to running this script
$URI = "https://raw.githubusercontent.com/dmitriilezine/AzurePAW-ADFS/master/AzurePAW-ADFS/azuredeploy.json"
$ParFile = "C:\data\ADFS-parametersFile.json"

Login-AzureRmAccount
New-AzureRmResourceGroupDeployment -ResourceGroupName $RGName -TemplateUri $URI -TemplateParameterFile $ParFile

```
### This deployment will do the following:
- Install 2 Windows 2016 Server VMs and 
- Configure them as ADFS farm with WID as DB. Federation Certficate pushed to the Key Vault is installed and used as ADFS Fed Service
- Both VMs are domain joined, and considered Tier 0
- Both VMs are placed on ADFS subnet
- Create ILB in front of ADFS farm
- It will encrypt each VM with ADE
- It will configure each VM diagnostics with diagnostics storage account
- It will install Microsoft antivirus extension in each VM


### Post Deployment Configurations
- Validate via ASC that all VMs are registered with ASC. Validate that they are not showing any red.
- Logon to ADFS VM via RDS 
- Perform post configuration:
  - Reset ADFS service account pwd and move it to the Tier 0 Service Accounts OU
  - Move ADFS VMs to the Tier 0 Identity OUs
- Perform ADFS configuration as required by the ADFS design (IdPs, RPs, claim rules etc)
					


[Back to main page](DeploymentOutline.md)