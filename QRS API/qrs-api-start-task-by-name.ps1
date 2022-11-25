# References 
# QRS API - Task: Start by name ; https://help.qlik.com/en-US/sense-developer/February2019/Subsystems/RepositoryServiceAPI/Content/Sense_RepositoryServiceAPI/RepositoryServiceAPI-Task-Start-By-Name.htm
# XrfKey; https://help.qlik.com/en-US/sense-developer/Subsystems/RepositoryServiceAPI/Content/Sense_RepositoryServiceAPI/RepositoryServiceAPI-Connect-API-Using-Xrfkey-Headers.htm

# FQDN to Qlik Sense central node
$FQDN = "qlikserver.domain.local"

# User credentials to use for authetication
$UserName   = "Administrator"
$UserDomain = "Domain"

# Exact name of task to trigger 
$Taskname = "Reload task of My App"

# 16 character Xrefkey to use for QRS API call
$XrfKey =  "hfFOdh87fD98f7sf"

# HTTP headers to be used in REST API call
$HttpHeaders = @{}
$HttpHeaders.Add("X-Qlik-Xrfkey","$XrfKey")
$HttpHeaders.Add("X-Qlik-User", "UserDirectory=$UserDomain;UserId=$UserName")
$HttpHeaders.Add("Content-Type", "application/json")

$HttpBody = @{}

$ClientCert = Get-ChildItem -Path "Cert:\CurrentUser\My" | Where-Object {$_.Subject -like '*QlikClient*'}
$ClientCert

$TaskGUID = Invoke-RestMethod -Uri "https://$($FQDN):4242/qrs/task/start/synchronous?xrfkey=$($xrfkey)&name=$($Taskname)" `
                              -Method POST `
                              -Headers $HttpHeaders  `
                              -Body $HttpBody `
                              -ContentType 'application/json' `
                              -Certificate $ClientCert

$TaskGUID
