# FQDN to Qlik Sense central node
$FQDN = "qlikserver.domain.local"

# User credentials to use for authetication
$UserName   = "Administrator"
$UserDomain = "Domain"

# Create JSON config for custom property 
# Possibel objectType options; "App","ContentLibrary","DataConnection","EngineService","Extension","ProxyService","ReloadTask","RepositoryService","SchedulerService","ServerNodeConfiguration","Stream","User","UserSyncTask","VirtualProxyConfig"
# choiceValue are comma separates values for the property
$HttpBody = @{ name         = "MyCustomProperty";
               valueType    = "Text";
               objectTypes  = @("App","ServerNodeConfiguration");                
               choiceValues = @("Value1", "Value2");
            } | ConvertTo-Json

# 16 character Xrefkey to use for QRS API call
$XrfKey =  "hfFOdh87fD98f7sf"

# HTTP headers to be used in REST API call
$HttpHeaders = @{}
$HttpHeaders.Add("X-Qlik-Xrfkey","$XrfKey")
$HttpHeaders.Add("X-Qlik-User", "UserDirectory=$UserDomain;UserId=$UserName")
$HttpHeaders.Add("Content-Type", "application/json")

# Get Qlik Sense client certificate
$ClientCert = Get-ChildItem -Path "Cert:\CurrentUser\My" | Where-Object {$_.Subject -like '*QlikClient*'}

# Invike API call
Invoke-RestMethod -Uri "https://$($FQDN):4242/qrs/custompropertydefinition?xrfkey=$($xrfkey)" `
                  -Method POST `
                  -Headers $HttpHeaders  `
                  -Body $HttpBody `
                  -ContentType "application/json; charset=utf-8" `
                  -Certificate $ClientCert
