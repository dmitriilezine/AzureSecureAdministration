[Back to main page](DeploymentOutline.md)

# Deploy Storage Accounts

Logging is a critical component of the secure solution. In addition to using Log Analytics, most resources can be
configured to log data into storage accounts. We need to create storage accounts so they can be used in later deployments.

Number of stroage accounts used for diagnostics can vary depending on different resource types being deployed and desire to 
log data from different resource types into dedicated storage accounts.

For this solution, currenlty we deploy four storage accounts:
- VM diagnostics
- Network diagnostics 
- SQL audit
- Key Vault diagnostics

Use the following link to initiate deployment in your target Tenant/Subscription.
```<language>
https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdmitriilezine%2FAzurePAW-StorageAccounts%2Fmaster%2FAzurePAW-StorageAccounts%2Fazuredeploy.json
```
####	
### This deployment will do the following:
- This ARM template will create four storage accounts. 

####
####
####

>**Note:** If your Azure AD account has access to multiple tenants/subscriptions, and when you click on the URL it targets wrong tenant, you will need to insert your desired tenant into the url as follows:

```<language>
https://portal.azure.com/YOURTARGETTENANT.onmicrosoft.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdmitriilezine%2FAzurePAW-StorageAccounts%2Fmaster%2FAzurePAW-StorageAccounts%2Fazuredeploy.json
```



[Back to main page](DeploymentOutline.md) 


