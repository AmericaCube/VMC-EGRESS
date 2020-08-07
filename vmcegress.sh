#!/bin/bash

# Setup script for VMware Cloud on AWS EGRESS Traffic Monitoring
# 
# - Apache Web Server
# - Enable Apache Web Server Startup
# - Open Firewall ports
# - Install wget command
# - Install MIcrosoft POwershell for Linux
# - Update O.S.
# - Install VMware POwershell Modules
# - Install William Lam NSX-T Powershell Module
# - DOwnload VMC-Egress Powershell Script from GitHub
# 

clear

echo "Update O.S. & Packages"
sudo yum update -y >/dev/null 2>&1

echo "Installing Apache Web Server"
sudo yum install -y httpd >/dev/null 2>&1
echo "Enabling Apache Web Server on Linux startup"
sudo systemctl start httpd >/dev/null 2>&1
sudo systemctl enable httpd >/dev/null 2>&1
echo "Configuring firewall for Apache Web Server"
sudo firewall-cmd --permanent --add-port=80/tcp >/dev/null 2>&1
sudo firewall-cmd --permanent --add-port=443/tcp >/dev/null 2>&1
sudo firewall-cmd --reload >/dev/null 2>&1

echo "Install wget"
sudo yum install -y wget >/dev/null 2>&1

echo "Install Microsoft Powershell for Linux"
curl -s https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo >/dev/null 2>&1
sudo yum install -y powershell >/dev/null 2>&1

echo "Update O.S. & Packages"
sudo yum update -y >/dev/null 2>&1

echo "Install VMware Powershell Modules"
pwsh -command Set-PSRepository -Name "PSGallery" -InstallationPolicy "Trusted" <<< A  >/dev/null 2>&1
pwsh -command Install-Module "VMware.PowerCLI" -Scope "AllUsers" -AllowClobber -Force >/dev/null 2>&1
pwsh -command Set-PowerCLIConfiguration -InvalidCertificateAction Ignore <<< A >/dev/null 2>&1
pwsh -command Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP \$true <<< A >/dev/null 2>&1

echo "Install William Lam NSX-T Powershell Module"
pwsh -command Install-Module VMware.VMC.NSXT <<< A >/dev/null 2>&1

echo "Download VMC-EGRESS Sctips from GitHub"
wget --quiet https://github.com/AmericaCube/VMC-EGRESS/raw/master/vmc.ini >/dev/null 2>&1
wget --quiet https://github.com/AmericaCube/VMC-EGRESS/raw/master/vmc.ps1 >/dev/null 2>&1

echo "Installation complete"
