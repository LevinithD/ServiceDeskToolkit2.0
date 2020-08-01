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

function Get-ComputerInfo
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
        [string]$Hardware
    )

    Begin
    {
    # Van de variabele Hardware is het onbekend hoeveel waardes het bevat. Hier worden de waardes uit elkaar getrokken en 
    # in een array (is 1-kolom tabel) geplaatst
    $arrHardware=$Hardware.Split(",")
    }

    Process
    {
        # Lus door de array
        Foreach($PW in $arrHardware)
        {
            # Voor iedere computer in de array wordt gecontroleert of het ingevoerde PW-nummer begint met PW
            if(-not ($PW -like "PW*"))
            {
                $PW = "PW"+ $PW
            }
    
    
            # Voor iedere computer worden alle eigenschappen opgehaald
            $PWInfo = Get-ADComputer $PW -Properties *
            
            # Plaatst individuele eigenschappen in variabelen
            $LastLogonDate = $PWInfo | Select-Object LastLogonDate
            $OperatingSystem = $PWInfo | Select-Object OperatingSystem
            $ADComputerDistinguishedName = $PWInfo | Select-Object DistinguishedName

            # De uitkomst van DistinguishedName is moeilijk leesbaar. Hier halen we de eigenschap FAT-Client of Terminal-Client op
            If($ADComputerDistinguishedName -like "*OU=Fat*")
            {
                $FatOrTerminal = "Fat"
            }
        
            Else
            {
                $FatOrTerminal = "Terminal"
            }
            
            <#
            # Voor test-doeleinden worden hier de resulaten van de variabelen getest in de console window
            Write-Output $
            Write-Output $Fatorterminal
            #>
        }
    }
    End
        {
            # Plaatst de gevonden variabelen in de daarvoor bedoelde controls en herlaadt de controls (anders worden de resultaten 
            # niet zichtbaar)
            $lbl_ADComputerLastLogonDate.Text = "Last logon date : " + $LastLogonDate
            $lbl_ADComputerLastLogonDate.Refresh()
    
            $lbl_ADComputerFatTerminal.Text = "Fat or Terminal : "+ $FatOrTerminal
            $lbl_ADComputerFatTerminal.Refresh()

            $lbl_ADComputerOS.Text = "Operating System : "+ $OperatingSystem
            $lbl_ADComputerOS.Refresh()
        }
}

<#
#Controle voor eigen PW

Get-ComputerInfo -arrHardware $env:COMPUTERNAME
#>


