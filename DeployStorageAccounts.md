[Back to main page](DeploymentOutline.md)

# Deploy Storage Accounts

Deploy storage accounts that will be used for VM diagnostics, network logging and SQL audit. Use the following link to initiate deployment in your target Tenant/Subscription.
```<language>
https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdmitriilezine%2FAzurePAW-StorageAccounts%2Fmaster%2FAzurePAW-StorageAccounts%2Fazuredeploy.json
```
	

> 	This ARM template will create three storage accounts. One account will be used for VM diagnostics, second for NSG diagnostics logging and third account for Azure SQL audit logging.
If more storage accounts are required by the design, then modify template as needed.
**Note:** if your Azure AD account has access to multiple tenants/subscriptions, and when you click on the URL it targets wrong tenant, you will need to insert your desired tenant into the url as follows:

```<language>
https://portal.azure.com/YOURTARGETTENANT.onmicrosoft.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdmitriilezine%2FAzurePAW-StorageAccounts%2Fmaster%2FAzurePAW-StorageAccounts%2Fazuredeploy.json
```



[Back to main page](DeploymentOutline.md) 


