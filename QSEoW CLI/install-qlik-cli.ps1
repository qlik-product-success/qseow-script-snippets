#Requires -RunAsAdministrator

param (
    [Parameter(Mandatory=$false)]
    [switch] $ForceGitHub 
)

$PSVersion = $PSVersionTable.PSVersion.Major

if($PSVersion -lt 4) {
    Write-Host -ForegroundColor Red "Qlik CLI requires PowerShell 4 or greater"
    Break   

}elseif ($PSVersion -eq 4 -or $ForceGitHub) {

    $downloads_folder = "$env:HOMEDRIVE$env:HOMEPATH\Downloads"
    $module_folder = "$Env:Programfiles\WindowsPowerShell\Modules\Qlik-Cli"

    Write-Host -ForegroundColor Green "Downloading Qlik CLI files from GitHub to $downloads_folder..."
 
    try {
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ahaydon/Qlik-Cli/master/Qlik-Cli.psd1" -OutFile "$downloads_folder\Qlik-Cli.psd1"
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ahaydon/Qlik-Cli/master/Qlik-Cli.psm1" -OutFile "$downloads_folder\Qlik-Cli.psm1"            
    }
    catch {
        Write-Host "Download failed!" -ForegroundColor Red
        Exit
    }

    New-Item "$module_folder" -ItemType directory -Force | Out-Null

    Write-Host -ForegroundColor Green "Copying Qlik CLI files to $module_folder..."

    New-Item "$Env:Programfiles\WindowsPowerShell\Modules\Qlik-Cli" -ItemType directory -Force

    Copy-Item -Path "$downloads_folder\Qlik-Cli.psd1" -Destination "$module_folder\Qlik-Cli.psd1"
    Copy-Item -Path "$downloads_folder\Qlik-Cli.psm1" -Destination "$module_folder\Qlik-Cli.psm1"

}else {

    Write-Host -ForegroundColor Green "Qlik CLI installation from NuGet repository..."
    Set-ExecutionPolicy Bypass -Scope Process -Force

    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
    Install-Module -Name Qlik-CLI -Force  | Out-Null
}

Import-Module Qlik-Cli

Write-Host -ForegroundColor Green "$((Get-Module Qlik-Cli).Name) ($((Get-Module Qlik-Cli).Version.Major).$((Get-Module Qlik-Cli).Version.Minor)) has been successfully installed"
