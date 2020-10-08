<#
.SYNOPSIS
Dit script haalt de computer informatie uit het Active Directory.

.DESCRIPTION
Deze functie wordt gevoedt door een aanroep voor een computer van elders. Het zoekt vervolgens de betreffende computer op 
in het AD en verdeeld deze informatie vervolgens over diverse variabelen. Deze variabelen worden vervolgens toegevoegd aan 
controls en zichtbaar gemaakt voor de gebruiker op het formulier.

.PARAMETER
$Hardware: Hierin wordt of een enkele computer opgevraagd of een reeks aan computers (een array of enkelkolommige tabel).

.EXAMPLE
Get-ComputerInfo -arrHardware $env:COMPUTERNAME

.NOTES

.LINK
Zelf gemaakt. Geen link beschikbaar
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7
#>

# DOT source library: Hier worden andere bestanden ingeladen die nodig zijn voor de werking van de ServiceDesk Toolkit 2.0

Function Get-ADUserSettings
{
    # CmdletBinding zorgt ervoor dat deze functie wordt behandelt alsof het een echte PowerShell cmdlet is.
    [CmdletBinding()]
   
        $strADUserSettings = Get-Content -Path $FilePathADUSerSettings

        $arrADUserSettings = $strADUserSettings.Split([Environment]::NewLine, [StringSplitOptions]::RemoveEmptyEntries)

        ForEach($ADUserSetting in $arrADUserSettings)
        {
            If($ADUserSetting.Contains("TRUE"))
                {
                    $ADUserSetting = $ADUserSetting -replace " = TRUE", ""
                    $script:arrADUSerProperties += $ADUserSetting
                }

        }
    
        $script:ADUserSettingLoaded = $true
}
