#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Import Qlik Sense apps in batch mode 
.DESCRIPTION
    This script will allow to import all Qlik Sense apps under the current folder(Exclude subfolders) into QMC.
    This script needs to be put under the same folder where all qvf files are located. 
.NOTES
    To run this script, Qlik-Cli needs to be installed firstly.  Otherwise please run below files firstly before running this script:
    1. qlik-cli-install
    2. Connect-cli
    3. set-qlik-license  
#>

# Break if Qlik CLI is not available
if(!(Get-Module -ListAvailable -Name Qlik-CLI)) {
  Write-Host -ForegroundColor Red "Error: Qlik CLI has not yet been installed. "
  break
}
$directory = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
 
Foreach ($file in $(Get-ChildItem "$directory\*.qvf")){

   Import-QlikApp -file $file.name -name $file.name -upload

 }