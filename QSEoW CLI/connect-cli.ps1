param (
    [string] $HostName       = "localhost"
)

# Break if Qlik CLI is not available
if(!(Get-Module -ListAvailable -Name Qlik-CLI)) {
    Write-Host -ForegroundColor Red "Error: Qlik CLI has not yet been installed. "
    break
}

Connect-Qlik $HostName -TrustAllCerts -UseDefaultCredentials | Out-Null

# TBA: Add more connection variety