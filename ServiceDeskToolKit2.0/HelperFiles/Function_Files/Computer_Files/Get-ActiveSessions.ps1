<#
.SYNOPSIS
Dit script haalt de actieve sessie van de gebruiker op.

.DESCRIPTION


.PARAMETER

.EXAMPLE

.NOTES

.LINK
https://theposhwolf.com/howtos/A-better-way-to-find-logged-on-users-remotely-using-PowerShell/
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_methods?view=powershell-7
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7
https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/qwinsta
#>

#DOT source library: Hier worden andere bestanden ingeladen die nodig zijn voor de werking van de ServiceDesk Toolkit 2.0
Function Get-ActiveSessions
{
    
    # CmdletBinding zorgt ervoor dat deze functie wordt behandelt alsof het een echte PowerShell cmdlet is.
    [CmdletBinding()]
    
    <# 
    In dit onderdeel worden de variabele gedeclareerd die meegestuurd dienen te worden bij het aanroepen van deze functie.
    De variable (aangegeven door $Name) die hier wordt gecreeërd dient verplicht ingevuld te zijn (aangegeven door 
    Parameter(Mandatory = $true), en accepteert ook pipeline object en object-property argumenten accepteerd (aangegeven door 
    Parameter(ValueFromPipeline = $true en ValueFromPipelinePropertyName = $true) 
    
    De ValidateNotNullOrEmpty bepaalt dat de waarde van de variabele een waarde bevat
    
    De [string] forceert de toegestuurde variabele als een string oftwel een stukje tekst.
    De [Switch] voor Quiet significeert dat deze variabele optioneel kan worden aangeroepen bij het aanroepen van deze functie
    #>
    Param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Name
        ,
        [switch]$Quiet
    )
    
    <#
    Begin, Process, End: Dit zijn manieren om code op te delen in blokken, welke code overzichtelijker maakt. 
    
    Het blok Begin is optioneel en kan gebruikt worden voor het declareren van variabelen en andere pre-proces handelingen. 
    In dit geval wordt de variabele $return hier aangelegd en is bepaald dat dit een array is (aangegeven door de @())

    Het blok Process bevat de eigenlijke functie van die dient te worden uitgevoerd. 
    
    Het blok End is optioneel en kan worden gebruikt voor post-proces handelingen. In dit geval wordt gecontroleerd of de $return 
    variabele gevuld is in het process blok. Hierop wordt de uitkomst van de functie bepaald.
    #>
    Begin
    {
        $return = @()
    }
    
    Process
    {
        # Hier wordt gekeken of de PW is te pingen
        If(!(Test-Connection $Name -Quiet -Count 1))
        {
            # Zo niet, stuur onderstaand bericht naar de console window
            Write-Error -Message "Unable to contact $Name. Please verify its network connectivity and try again." -Category ObjectNotFound -TargetObject $Name
            Return
        }
        
        <# 
        Controle of de gebruiker admin is ([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"), anders kan wat in dit blok gebeurt niet uitgevoerd worden. De registry-key (S-1-5-32-544) 
        is nodig om  een error 5 Access is Denied foutmelding te voorkomen.
        De [bool] zorgt ervoor dat de waarde wordt vervangen door een $true/$false waarde
        #>
        If([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"))
        { 

            # Hier worden variabelen gevuld
            $LMtype = [Microsoft.Win32.RegistryHive]::LocalMachine
            $LMkey = "SYSTEM\CurrentControlSet\Control\Terminal Server"
            $LMRegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($LMtype,$Name)
            $regKey = $LMRegKey.OpenSubKey($LMkey,$true)
            
            #Hier wordt gecontroleerd of de waarde die in de registry staat voor AllowRemoteRPC uit staat. Zo ja, wordt hij aan gezet
            If($regKey.GetValue("AllowRemoteRPC") -ne 1)
            {
                $regKey.SetValue("AllowRemoteRPC",1)
                Start-Sleep -Seconds 1
            }
            
            # De dispose() functie leegt de variabelen van waardes. Powershell ruimt een hoop dingen op aan het einde van een functie, 
            # maar variabelen worden helaas niet geleegd.
            $regKey.Dispose()
            $LMRegKey.Dispose()
        }

        # Hier wordt de uitkomst van een functie in een variabele opgeslagen. Deze functie laat sessie informatie zien op de opgegeven
        # computer.  
        $result = qwinsta /server:$Name
        
        # Hier wordt gekeken of de variabele $result een waarde bevat.
        If($result)
        {
            ForEach($line in $result[1..$result.count])
            { 
                # hier wordt een array aangelegd ($tmp) waarbij de eerste regel niet wordt meegenomen daar deze enkel de headers bevat
                $tmp = $line.split(" ") | ?{$_.length -gt 0}
                
                #Controle of gebruikersnaam leeg is, deze staat kennelijk op plek 19 van $line
                If(($line[19] -ne " "))
                { 
                    #Controle of de sessie actief is. Dit wordt aangegeven op plek 48 van $line
                    If($line[48] -eq "A")
                    { 
                        # $Hier wordt toegevoegd aan de array $return (+=)
                        $return += New-Object PSObject -Property 
                        @{
                            # Deze waardes worden toegevoegd aan $return, met achterstaande waarden
                            "ComputerName" = $Name
                            "SessionName" = $tmp[0]
                            "UserName" = $tmp[1]
                            "ID" = $tmp[2]
                            "State" = $tmp[3]
                            "Type" = $tmp[4]
                        }
                    }
                    Else
                    {
                        # Bij een inactieve sessie worden de onderstaande variabelen toegevoegd met achterstaande waarden
                        $return += New-Object PSObject -Property 
                        @{
                            # Deze waardes worden toegevoegd aan $return, met achterstaande waarden
                            "ComputerName" = $Name
                            "SessionName" = $null
                            "UserName" = $tmp[0]
                            "ID" = $tmp[1]
                            "State" = $tmp[2]
                            "Type" = $null
                        }
                    }
                }
            }
        }
        Else
        {
            # Als $result leeg is, laat dan onderstaande melding zien.
            Write-Error "Unknown error, cannot retrieve logged on users"
        }
    }
    
    End
    {
        
        If($return)
        {
            If($Quiet)
            {
                Return $true
            }
            Else
            {
                Return $return
            }
        }
        Else
        {
            If(!($Quiet))
            {
                Write-Host "No active sessions."
            }
            Return $false
        }
    }
}

Get-ADComputer -Filter {OperatingSystem -like '*Server*'} | Get-ActiveSessions | Where-Object UserName -eq 'BOOY3105'