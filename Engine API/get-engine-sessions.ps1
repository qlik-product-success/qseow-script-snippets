<#
    .SYNOPSIS
    Confirm current consumption for a specifc Qlik Sense Engine through an Engine REST API. 
    .DESCRIPTION
    Call Qlik Engine REST API end-point GET /engine/sessions to get details of currently active sessionId, AppId and userId.  
    .PARAMETER  FQDN
    Hostname of the Qlik Sense Engine node where Engine REST API end-point is called. 
    Defaults to the FDQN on host where script is executed.
    .PARAMETER  EnginePort
    Qlik Sense Engine port where REST API end-point is called. 
    Defaults to 4747.    
    .PARAMETER  CertIssuer
    Hostname used to sign the Qlik Sense CA certificate. 
    Defaults to the FDQN on host where script is executed.
    .EXAMPLE
    C:\PS> .\get-engine-sessions.ps1
    .EXAMPLE
    C:\PS> .\get-engine-sessions.ps1 -CertIssuer "central-node.domain.local"
    .NOTES
    This script is provided "AS IS", without any warranty, under the MIT License. 
    Copyright (c) 2021 Qlik 
#>

param (
    [Parameter()]
    [string] $FQDN       = [string][System.Net.Dns]::GetHostByName(($env:computerName)).Hostname, 
    [Parameter()]
    [int] $EnginePort      = 4747, 
    [Parameter()]
    [string] $CertIssuer = [string][System.Net.Dns]::GetHostByName(($env:computerName)).Hostname
)

# Qlik Sense client certificate to be used for connection authentication
# Note, certificate lookup must return only one certificate. 
$ClientCert = Get-ChildItem -Path "Cert:\CurrentUser\My" | Where-Object {$_.Issuer -like "*$($CertIssuer)*"}

# Only continue if one unique client cert was found 
if (($ClientCert | measure-object).count -ne 1) { 
    Write-Host "Failed. Could not find one unique certificate." -ForegroundColor Red
    Write-Host "$ClientCert" -ForegroundColor Yellow
    Exit 
}

# HTTP headers to be used in REST API call
$HttpHeaders = @{}
$HttpHeaders.Add("Content-Type", "application/json")

# HTTP body for REST API call
$HttpBody = @{}

# Invoke REST API call
Invoke-RestMethod   -Uri "https://$($FQDN):$($EnginePort)/engine/sessions" `
                    -Method GET `
                    -Headers $HttpHeaders  `
                    -Body $HttpBody `
                    -ContentType 'application/json' `
                    -Certificate $ClientCert