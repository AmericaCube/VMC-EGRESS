# Powershell to query NSX-T about EGRESS Traffic Consumption
# (C) 2020 Cesare G. Rossi
# Use William Lam Powershell Module for NSX-T
# Syntax:
# pwsh vmc.ps1 [parametersfilename]
# If [parametersfilename] is omitted, default will be VMC.INI
#
# Parameters for file .INI
#
# RefreshToken= API Token for VMConAWS Org
# OrgName= VMC Org Name
# SDDCName= VMC SDDC Name
# CostPerGigaByte= Cost per GigaByte for EGRESS Traffic
# TrafficThreshold= Threshold for EGRESS Traffic
# CostThreshold= Threshold for Cost of EGRESS Traffic
# OutputFile= Name of output file
# OutputOnWeb= Creation of Index.html file needed (1/0) [optional]
# IsATest= Run script as a test without VMC query (1/0) [optional]
# TestMBytes= # of MBytes to use for testing [optional]
#


param (
    [string]$ParametersFile = "vmc.ini"
)

if (-not (Test-Path $ParametersFile))
{
    Write-Host "Syntax: vmc.ps1 [ParametersFileName]"
    Write-Error "File [$ParametersFile] does not exists!"
    exit
}

Get-Content $ParametersFile | Where-Object {$_.length -gt 0} | Where-Object {!$_.StartsWith("#")} | ForEach-Object {
    $var = $_.Split('=',2).Trim()
    New-Variable -Scope Script -Name $var[0] -Value $var[1]
}

# Check if it is a test
if(1 -eq $IsATest)
{
	$EgressTraffic=[math]::Round($TestMBytes / 1Mb, 2)
	write-host $TestMBytes
	write-host $EgressTraffic
}
else
{
	Connect-VmcServer -RefreshToken $RefreshToken > /dev/null
	Connect-NSXTProxy -RefreshToken $RefreshToken -OrgName $OrgName -SDDCName $SDDCName > /dev/null
	$Traffic=Get-NSXTT0Stats -NonPrettyPrint
	$EgressTraffic=[math]::Round($Traffic.public.tx_total_bytes / 1GB,2)
}
$EgressTraffic | Out-File -FilePath $outputFile
$EgressCost=[math]::Round($EgressTraffic*$CostPerGigaByte,2)
$EgressCost| Out-File -FilePath $outputFile -Append
Add-Content $OutputFile -Value (Get-Date)
if($OutputOnWeb -eq 1)
{
        [System.String]::Concat("<html>") | Out-File -FilePath "/var/www/html/index.html"
        [System.String]::Concat("<head>") | Out-File -FilePath "/var/www/html/index.html" -Append
		[System.String]::Concat('<meta http-equiv="refresh" content="60">') | Out-File -FilePath "/var/www/html/index.html"
        [System.String]::Concat("<title>", "VMware Cloud on AWS Egress Traffic", "</title>") | Out-File -FilePath "/var/www/html/index.html" -Append
        [System.String]::Concat("</head>") | Out-File -FilePath "/var/www/html/index.html" -Append
        [System.String]::Concat("<body>") | Out-File -FilePath "/var/www/html/index.html" -Append
        [System.String]::Concat('<h1>', "VMware Cloud on AWS Egress", "</h1>") | Out-File -FilePath "/var/www/html/index.html" -Append
        [System.String]::Concat("<h2>", "EGRESS Traffic Monitor", "</h2>") | Out-File -FilePath "/var/www/html/index.html" -Append
        [System.String]::Concat("Check Date: ", $(Get-Date), "<br/>") | Out-File -FilePath "/var/www/html/index.html" -Append
        [System.String]::Concat("EGRESS Traffic: ", $EgressTraffic, "GB<br/>") | Out-File -FilePath "/var/www/html/index.html" -Append
        [System.String]::Concat("EGRESS Cost: ", $EgressCost,"Euro") | Out-File -FilePath "/var/www/html/index.html" -Append
    	if($EgressTraffic -gt $TrafficThreshold -Or $EgressCost -gt $CostThreshold)
    	{
			[System.String]::Concat("<h2>Threshold has been exceeded!</h2>") | Out-File -FilePath "/var/www/html/index.html" -Append
			[System.String]::Concat("<h2>Traffic Threshold = ", $TrafficThreshold, "GB, EGRESS Traffic = ", $EgressTraffic,  "GB</h2>") | Out-File -FilePath "/var/www/html/index.html" -Append
			[System.String]::Concat("<h2>Traffic Cost Threshold = ", $CostThreshold, "$, EGRESS Traffic Cost = ", $EgressCost,  "$</h2>") | Out-File -FilePath "/var/www/html/index.html" -Append
    	}
    	else
    	{
			[System.String]::Concat("<h2>Threshold has not been exceeded!</h2>") | Out-File -FilePath "/var/www/html/index.html" -Append
			[System.String]::Concat("<h2>Traffic Threshold = ", $TrafficThreshold, "GB, EGRESS Traffic = ", $EgressTraffic,  "GB</h2>") | Out-File -FilePath "/var/www/html/index.html" -Append
			[System.String]::Concat("<h2>Traffic Cost Threshold = ", $CostThreshold, "$, EGRESS Traffic Cost = ", $EgressCost,  "$</h2>") | Out-File -FilePath "/var/www/html/index.html" -Append
    	}
	[System.String]::Concat("</body>") | Out-File -FilePath "/var/www/html/index.html" -Append
	[System.String]::Concat("</html>") | Out-File -FilePath "/var/www/html/index.html" -Append
}