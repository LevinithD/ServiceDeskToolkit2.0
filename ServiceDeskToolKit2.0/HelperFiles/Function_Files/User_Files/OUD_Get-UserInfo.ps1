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

# DOT source library: Hier worden andere bestanden ingeladen die nodig zijn voor de werking van de ServiceDesk Toolkit 2.0Function Get-UserInfo

Function Get-UserInfo
{
    # CmdletBinding zorgt ervoor dat deze functie wordt behandelt alsof het een echte PowerShell cmdlet is.
    [CmdletBinding()]
    
    <# 
    In dit onderdeel worden de variabele gedeclareerd die meegestuurd dienen te worden bij het aanroepen van deze functie.
    
    De variable (aangegeven door $Hardware) die hier wordt gecreeërd dient verplicht ingevuld te zijn (aangegeven door 
    Parameter(Mandatory = $true), en accepteert ook pipeline object en object-property argumenten accepteerd (aangegeven door 
    Parameter(ValueFromPipeline = $true en ValueFromPipelinePropertyName = $true) 
    
    De ValidateNotNullOrEmpty bepaalt dat de waarde van de variabele een waarde bevat
    
    De [string] forceert de toegestuurde variabele als een string oftwel een stukje tekst.
    #>
    param
    (
        [Parameter(
        Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        $ADUser
     )

     $arrADUSerProperties=@()

     If($ADUserSettingLoaded -eq $null)
        {
            Get-ADUserSettings
        }

     $UserInfo = Get-ADUser -Identity $ADUser -Properties samAccountName

     Foreach ($User in $UserInfo)
     {
        $dgv_ADUser.Rows.Add($User)
     }

     $frm_Toolkit.refresh()
                                                          

}
