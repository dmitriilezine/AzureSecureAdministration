
<#
    .DESCRIPTION
    This script closely resembles and was derived from https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/application-proxy-register-connector-powershell. 
    This script is used to generate a token that will be used by the Custom Script Extension of the VM(s) created in Azure for hosting the App Proxy Connector service/application.
    
    .IMPORTANT
    This script was developed to run manually and interractive, not within a CI/CD pipeline. 
    This script will prompt twice for a username and password to authenticate to Azure. 
     - !The first username and password entered MUST be of a Global Administrator in the tenant where Azure AD Proxy will be used!
     - !The second username and password (can be the same as first) entered must have ability to write to the Azure Key Vault that will be used to store token!
    This script must be run in PowerShell.exe to work properly. Error occur in PowerShell ISE.
#>

#Requires -RunAsAdministrator

# Specify Key Vault name where token will be stored. This is the Secrets Key Vault created in preparation for this solution.
# Update this paramter with Key Vault Name
$keyvaultName = "DeploymentSecretsAKV"

# Import Modules and Install Windows Updates    
Install-Module AzureAD -Confirm:$false -Force -WarningAction SilentlyContinue

# Locate AzureAD PowerShell Module
# Change Name of Module to AzureAD after what you have installed
$AADPoshPath = (Get-InstalledModule -Name AzureAD).InstalledLocation
# Set Location for ADAL Helper Library
$ADALPath = $(Get-ChildItem -Path $($AADPoshPath) -Filter Microsoft.IdentityModel.Clients.ActiveDirectory.dll -Recurse ).FullName | Select-Object -Last 1


# Add ADAL Helper Library
Add-Type -Path $ADALPath

#region constants - These won't change

# The AAD authentication endpoint uri
[uri]$AadAuthenticationEndpoint = "https://login.microsoftonline.com/common/oauth2/token?api-version=1.0/" 

# The application ID of the connector in AAD
[string]$ConnectorAppId = "55747057-9b5d-4bd4-b387-abf52a8bd489"

# The reply address of the connector application in AAD
[uri]$ConnectorRedirectAddress = "urn:ietf:wg:oauth:2.0:oob" 

# The AppIdUri of the registration service in AAD
[uri]$RegistrationServiceAppIdUri = "https://proxy.cloudwebappproxy.net/registerapp"

#endregion

#region GetAuthenticationToken
  
# Load AzureAD Assembly
[System.Reflection.Assembly]::LoadFrom($ADALPath) | Out-Null

# Set AuthN context
$authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $AadAuthenticationEndpoint

# Build platform parameters
$promptBehavior = [Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Always
$platformParam = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList $promptBehavior

# Do AuthN and get token
$authResult = $authContext.AcquireTokenAsync($RegistrationServiceAppIdUri.AbsoluteUri, $ConnectorAppId, $ConnectorRedirectAddress, $platformParam).Result

# Check AuthN result
If (($authResult) -and ($authResult.AccessToken) -and ($authResult.TenantId) ) 
{
  $token = $authResult.AccessToken
  $tenantId = $authResult.TenantId
}
Else 
{
  Write-Host "Authentication result, token or tenant id returned are null"
  throw
}

#endregion

#region Output Results
# Login to Azure AD where Key Vault that will store secrets is attached
Login-AzureRmAccount

$securetoken = ConvertTo-SecureString -String $token -AsPlainText -Force
$securetenantid = ConvertTo-SecureString -String $tenantid -AsPlainText -Force

# Push Token and TenantId values to Azure Key Vault. 
Set-AzureKeyVaultSecret -Name AADproxyToken -SecretValue $securetoken -VaultName $keyvaultName
Set-AzureKeyVaultSecret -Name AADproxyTenantID -SecretValue $securetenantId -VaultName $keyvaultName

# above secrets will need to be used by the deployment ARM code during VM connector installation 


# Write-Host ""
# Write-Output "Token ID: The Token ID is now on your clipboard!"
# $token | clip
# Write-Host ""
# Write-Output "Tenant ID: $tenantId"

#endregion Output Results

