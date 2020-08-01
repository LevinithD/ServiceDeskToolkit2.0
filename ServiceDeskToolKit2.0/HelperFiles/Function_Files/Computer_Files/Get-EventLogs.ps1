<#
.SYNOPSIS
This function gets the eventlogs from a specified computer

.DESCRIPTION

.PARAMETER

.EXAMPLE

.NOTES

.LINK
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-eventlog?view=powershell-5.1
#>

#DOT source library: Hier worden andere bestanden ingeladen die nodig zijn voor de werking van het programma

function Get-EventLogs
{
[CmdletBinding()]
param
    (
    $Hardware
    )

#Check if Eventlogs exists
$FilePath = "C:\Temp\Eventlogs\"

If(!(Test-Path $FilePath))
{
    New-Item -ItemType Directory -Force -Path $FilePath
}

$DateTime = Get-Date -Format "dd-MM-yyyy HH_mm"
$FilePath = $FilePath + $DateTime + "_Eventlog_" + $Hardware + ".txt"

#Get Eventlogs and export to location
Get-EventLog  -LogName System -Entrytype  Error,FailureAudit, Warning -ComputerName $Hardware | Out-File -filepath $FilePath

}