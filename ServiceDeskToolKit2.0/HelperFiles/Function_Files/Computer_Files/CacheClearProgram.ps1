<#
.SYNOPSIS
Programma dient de "GUID van bestand" uit Ivanti Workspace Control Console te halen (Ivanti WorkSpace Control Console -> Gebruikersinstellingen) op basis van naam gebruiker en naam programma

.DESCRIPTION

.PARAMETER

.EXAMPLE

.NOTES

.LINK

#>
$PW = Read-Host "Voer PW-nummer in"

$arrInstalledPrograms = wmic /node: $PW product get

foreach($InstalledProgram in $arrInstalledPrograms)
{
$InstalledProgram

}

#Write-Host "Dit programma voert een clear-cache uit op programma's die in Windows 10 draaien"
#[string]$ProgramName = Read-Host "Geef programmanaam op"
#[string]$FileExtensionArray = ".upr", ".upf", ".once"
#[string]$User = Read-Host "Geef Gebruikersnaam op"
#[date]$DateAndTime = Get-Date -Format G

#Switch ($ProgramName)
#    {
#    "Outlook" 
#        {
#        $GUID = "{7209DB73-2BA7-420A-80DA-943775C6766B}"
#        $FileName1 = "133ECA3_212AF_DD2_mapi"
#        $FileName2 = "133ED5A_239F0_920_mapi"
#        }
#    "Powerpoint"
#        {
#        $GUID = "{8037CA5C-CCEC-4211-AA72-A3218BDBD0E8}"
#    	}
#    "IE Cache"
#        {
#        $GUID = "{}"
#        }
#    }

#Foreach ($FileExtension in $FileExtensionArray)
    {
#    Copy-Item -Path("\\nuthvs02\tk_amb_profiles$\" + $User + "\pwrmenu_W10\UserPref\") -Destination ("\\nuthvs02\tk_amb_profiles$\" + $User + "\pwrmenu_W10\" + $DateAndTime + "UserPref\")
    
#    if($FileExtension = ".once")
#        {
#        Remove-Item -Path ("\\nuthvs02\tk_amb_profiles$\" + $User + "\pwrmenu_W10\" + $FileName1 + $FileExtension) -whatif
#        Remove-Item -Path ("\\nuthvs02\tk_amb_profiles$\" + $User + "\pwrmenu_W10\" + $FileName2 + $FileExtension) -whatif
#        }
#    Remove-Item -Path ("\\nuthvs02\tk_amb_profiles$\" + $User + "\pwrmenu_W10\UserPref\" + $GUID + $FileExtension) -whatif
#    }