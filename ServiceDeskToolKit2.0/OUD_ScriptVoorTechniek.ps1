<#
.SYNOPSIS
This script enables the use of all the powershell scripts currently used by Techniek in the Tweede Kamer

.DESCRIPTION

.PARAMETER
No paramaters required. Just run it and answer the questions.

.EXAMPLE

.NOTES
As the need for more options grow, this script will be enhanced.

.LINK
No link available.
#>

#DOT source library: Hier worden andere bestanden ingeladen die nodig zijn voor de werking van de ServiceDesk Toolkit 2.0
. C:\Users\loc.BOOY3105\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Function_Files\Computer_Files\Get-ComputerInfo.ps1
. C:\Users\loc.BOOY3105\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Function_Files\Computer_Files\Get-EventLogs.ps1
. C:\Users\loc.BOOY3105\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Function_Files\Computer_Files\Get-MacAddress.ps1
. C:\Users\loc.BOOY3105\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Function_Files\Computer_Files\Get-Ping.ps1
. C:\Users\loc.BOOY3105\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Function_Files\Computer_Files\Get-Shutdown.ps1

$ADEntry = Read-Host -Prompt "Is het een Printer/Computer/Gebruiker?"

#Afhankelijk van keuze wordt hier de route bepaald
Switch ($ADEntry)
{
    {($_ -eq "c") -or ($_ -eq "Computer")}
    {
        #Maak array voor input van meerdere apparaten
        $ADComputer = Read-Host -Prompt "Voer PW-nummer(s) in, gescheiden door een komma"
        $ADComputer=$ADComputer.Split(",")

        #Loop door array
        Foreach($PW in $ADComputer)
        {
            #Controleert of ingevoerde nummer begint met PW
            if(-not ($PW.StartsWith("PW") -or $PW.StartsWith("pw")))
            {
                $PW = "PW"+ $PW
            }
            
            #Haalt het mac-adres op van de computer
            Get-MacAddress -Hardware $PW

            #Haalt de laatste logon datum en OS van computer op
            Get-ComputerInfo -Hardware $PW
            $PWInfo

            $PingPC = Read-Host -Prompt "Wilt u de PW pingen (j/n)?"
            
            if($PingPC -eq "j")
            {
                #Aantal pogingen om te ondernemen
                $NumberOfAttempts = Read-Host "Aantal te versturen pakketten (Leeg laten voor default)"
                
                #Grootte beschikbaar tussen 1 en 65,527 bytes
                $BufferSize = Read-Host "Grootte van te versturen pakketten (leeg laten voor default)"
                
                Get-Ping -Hardware $PW -NumberOfAttempts $NumberOfAttempts -BufferSize $BufferSize
            }

            #Sluit de PC af
            $ShutdownPC = Read-Host "Wilt u de PC afsluiten (j/n)?"
            if($ShutdownPC -eq "j")
            {
                $Restart = Read-Host "Wilt u de PC herstarten?"
                $DelayInSeconds = Read-Host "Wat is uw gewenste uitstel (in seconden)?"
                Get-ShutDown -Hardware $PW -Restart $Restart -DelayInSeconds $DelayInSeconds
            }

            #Haalt de eventlogs op van de PW
            $GetEventLogs = Read-Host -Prompt "Event logs ophalen (j/n)?"
            
            if($GetEventLogs -eq "j")
            {
                $Source = Read-Host -Prompt "Welk programma?"
                Get-EventLogs -Hardware $PW
            }
            Break
        }
    }

    {($_ -eq "Printer") -or ($_ -eq "p")}
    {
        #Maak array voor input van meerdere apparaten
        $ADPrinter = Read-Host -Prompt "Voer printernummer(s) in, gescheiden door een komma"
        $ADPrinter = $ADPrinter.Split(",")

        #Loop door array
        Foreach($Printer in $ADPrinter)
        {
            #Opent de printer pagina in Chrome
            $URL = "https://" + $Printer
            Start-Process "chrome.exe" $URL

            #Haalt het mac-adres op van de computer
            Get-MacAddress -Hardware $Printer

            #Get IP-Address
            #$IPv4 = @(([net.dns]::GetHostEntry($Printer)).AddressList.IPAddressToString)

            #Sluit de Printer af
            $ShutdownPC = Read-Host "Wilt u de PC afsluiten (j/n)?"
            if($ShutdownPC -eq "j")
            {
                $Restart = Read-Host "Wilt u de PC herstarten (j/n)?"
                $DelayInSeconds = Read-Host "Wat is uw gewenste uitstel (in seconden)?"
                Get-ShutDown -Hardware $PW -Restart $Restart -DelayInSeconds $DelayInSeconds
            }
            
            $NumberOfAttempts = Read-Host "Aantal te versturen pakketten (Leeg laten voor default)"
            $BufferSize = Read-Host "Grootte van te versturen pakketten (leeg laten voor default)"
            Get-Ping -Hardware $Printer -NumberOfAttempts $NumberOfAttempts -BufferSize $BufferSize 
            Break
        }
        
    }

    {($_ -eq "Gebruiker") -or ($_ -eq "g") -or ($_ -eq "Üser") -or ($_ -eq "u")}
    {
        #Maak array voor input van meerdere apparaten
        $ADUser = Read-Host -Prompt "Voer gebruikersna(a)m(en) in, gescheiden door een komma"
        $ADUSer = $ADUSer.Split(",")

        #Loop door array
        Foreach($User in $ADUser) 
        {
            #Haalt alle eigenschappen op van gebruiker
            Get-ADUser -Filter {(SAMAccountName -eq $User) -and (Enabled -eq $true)} -Properties DistinguishedName, LastBadPasswordAttempt, PasswordExpired, PasswordLastSet, LockedOut, extensionAttribute1
            
            #Haalt de groepen waarvan gebruiker lid is op
            Get-ADPrincipalGroupMembership $User | select name
            Break
        }
    }
   
}
