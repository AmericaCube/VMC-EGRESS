#!/bin/bash

# Setup script for VMware Cloud on AWS EGRESS Traffic Monitoring
# 
# - Apache Web Server
# - Enable Apache Web Server Startup
# - Open Firewall ports
# - Install Microsoft POwershell for Linux
# - Update O.S.
# - Install VMware POwershell Modules
# - Install William Lam NSX-T Powershell Module
# - DOwnload VMC-Egress Powershell Script from GitHub
# - DOwnload VMC-Egress readme.txt file from GitHub
# 

echo "Updating O.S. & Packages"
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

echo "Installing Microsoft Powershell for Linux"
curl -s https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo >/dev/null 2>&1
sudo yum install -y powershell >/dev/null 2>&1

echo "Updating O.S. & Packages"
sudo yum update -y >/dev/null 2>&1

echo "Installing VMware Powershell Modules"
pwsh -command Set-PSRepository -Name "PSGallery" -InstallationPolicy "Trusted" <<< A  >/dev/null 2>&1
pwsh -command Install-Module "VMware.PowerCLI" -Scope "AllUsers" -AllowClobber -Force >/dev/null 2>&1
pwsh -command Set-PowerCLIConfiguration -InvalidCertificateAction Ignore <<< A >/dev/null 2>&1
pwsh -command Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP \$true <<< A >/dev/null 2>&1

echo "Installing William Lam NSX-T Powershell Module"
pwsh -command Install-Module VMware.VMC.NSXT <<< A >/dev/null 2>&1

echo "Downloading VMC-EGRESS Sctips from GitHub"
curl -LJOs https://github.com/AmericaCube/VMC-EGRESS/raw/master/vmc.ini
curl -LJOs https://github.com/AmericaCube/VMC-EGRESS/raw/master/vmc.ps1
curl -LJOs https://github.com/AmericaCube/VMC-EGRESS/raw/master/readme.txt
echo "Installation complete"
