VMC-EGRESS

VMware Cloud on AWS EGRESS Traffic Monitoring

Powershell script to query NSX-T about EGRESS Traffic Consumption

(C) 2020 Cesare G. Rossi

Use William Lam Powershell Module for NSX-T

Download and execute script [VMware Cloud on AWSgress.sh] to install all components to Your CentOS machine 

Syntax:

pwsh vmc.ps1 [parametersfilename]

If [parametersfilename] is omitted, default will be VMC.INI

Output:

file [OutputFile] with

[TotalEgressTrafficGB]

[CostForEgressTraffic]

[CalculationDateTime]

Example:

19.01

0.95

8/7/2020 4:24:24 PM

if [OutputOnWeb = 1] script will write file index.html into /var/www/html with calculated info.

If [IsATest = 1] script doesn't try to connect to VMware Cloud on AWS: will calculate CostPerGigaByte by using [TestMBytes] and create [OutputFile] and Apache [index.html] file.

Parameters for file .INI

RefreshToken= API Token for VMConAWS Org (see video APIToken.mp4]

OrgName= VMC Org Name

SDDCName= VMC SDDC Name

CostPerGigaByte= Cost per GigaByte for EGRESS Traffic

TrafficThreshold= Threshold for EGRESS Traffic

CostThreshold= Threshold for Cost of EGRESS Traffic

OutputFile= Name of output file

OutputOnWeb= Creation of Index.html file needed (1/0) [optional]

IsATest= Run script as a test without VMC query (1/0) [optional]

TestMBytes= # of MBytes to use for testing [optional]
