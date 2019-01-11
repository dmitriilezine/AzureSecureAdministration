[Back to main page](DeploymentOutline.md)
# Post ADDS and RDS Deployment Configuration

### Azure side
- Configure Azure Update on all VMs (azure automation windows update service)
- Configure ASC application whitelisting in audit mode
- If network block was configured during vNet creation, then disable that block to allow traffic from other customer vNets/on-premises to this vNet
- Other tasks to be identified

### ADDS side
- Reset password of the main admin account (that was used for deployment) and designate it to be break glass account
- Create accounts for Tier 0 users in ADDS and put them in the right T0 groups
- Move ADCS VM to the "T0 PKI" OU
- Move RDS VMs to the respective T0 OUs (this is to be identified)
- Other tasks to be identified 




[Back to main page](DeploymentOutline.md)