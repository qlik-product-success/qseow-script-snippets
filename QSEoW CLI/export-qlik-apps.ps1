<#
.SYNOPSIS
    Export all Qlik Sense apps including unpublished
.DESCRIPTION
    This script will export all Qlik Sense apps including unpublished apps from QMC.
    This script will also generate the text file with qvf name and id. 
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

Set-content -Force -path .\ExportApp.txt -value (Get-date)

Foreach($qvf in $(get-qlikapp)) {

 Export-QlikApp -id $qvf.id
 Add-Content -Force -path .\ExportApp.txt -Value ($qvf.id+'  '+$qvf.name)
 
  }  
