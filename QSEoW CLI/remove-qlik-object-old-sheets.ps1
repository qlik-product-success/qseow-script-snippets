param (
    [string] $AppName         = $null,
    [string] $RemoveOlderThan = $null
)

# Break if Qlik CLI is not available
if(!(Get-Module -ListAvailable -Name Qlik-CLI)) {
    Write-Host -ForegroundColor Red "Error: Qlik CLI has not yet been installed. "
    break
}

# Set license variable values
if($AppName)         { Write-Host "Full app name: $AppName"                         } else { $AppName         = Read-Host -Prompt "Full app name"                               }
if($RemoveOlderThan) { Write-Host "Remove sheets modified before: $RemoveOlderThan" } else { $RemoveOlderThan = Read-Host -Prompt "Remove sheets modified before (YYY/MM/DD)"   }


$app_id = (Get-QlikApp -filter "$AppName").id
# TBA: Fail if no ID is found

(Get-QlikObject -filter "objectType eq 'sheet' and app.id eq $($app_id) and modifiedDate lt '$RemoveOlderThan'" -full) | ForEach-Object { Remove-QlikObject -id $_ }