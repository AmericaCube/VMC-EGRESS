#!/bin/bash

# Setup script for VMware Cloud on AWS EGRESS Traffic Monitoring
# 
# - Apache Web Server
# - Enable Apache Web Server Startup
# - Open Firewall ports
# - Install MIcrosoft POwershell for Linux
# - Update O.S.
# - Install VMware POwershell Modules
# - Install William Lam NSX-T Powershell Module
# - DOwnload VMC-Egress Powershell Script from GitHub
# 

sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload

curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo

sudo yum install -y powershell

sudo yum update -y

pwsh -command Set-PSRepository -Name "PSGallery" -InstallationPolicy "Trusted" <<< A
pwsh -command Install-Module "VMware.PowerCLI" -Scope "AllUsers" -AllowClobber -Force
pwsh -command Set-PowerCLIConfiguration -InvalidCertificateAction Ignore <<< A
pwsh -command Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP \$true <<< A
pwsh -command Install-Module VMware.VMC.NSXT <<< A

wget https://github.com/AmericaCube/VMC-EGRESS/raw/master/vmc.ini
wget https://github.com/AmericaCube/VMC-EGRESS/raw/master/vmc.ps1
