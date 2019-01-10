[Back to main page](DeploymentOutline.md)

# Deploy ADFS Farm into ADDS

### Prepare Federation Certificate for deployment
- For production you can use trusted certficate from internal or external PKI authority. You'll need to have PFX file.
- For test and lab deployment you can issued certifcate from the CA that is installed as 
part of ADDS deployment. Use "Azure PAW Web Server" certificate template to issue custom certificate and save it as PFX.
- Push PFX file with ADFS federation service certificate to the "Secrets Key Vault". It will be installed on ADFS VMs 
during VM deployment and then used by ADFS installation as the Federation Service certificate.
- To push PFX file to Key Vault, use the following steps:
- 



[Back to main page](DeploymentOutline.md)