<#
 
.SYNOPSIS
This function enables pinging a computer

.DESCRIPTION

.PARAMETER &lt;Parameter-Name&gt;
Parameter | Uitleg
-t Pings the specified host until stopped. To stop - type Control-C
-a Resolve adresses to hostnames
-n Number of echo requests to send
-l Send buffer size
-f Set Don't Fragment flag in packet (IPv4-only)
-i Set Time To Live
-v Set Type of Service (Setting has been deprecated)
-r Record route for count hops (IPv4-only)
-s Timestamp for count hops (IPv4-only)
-j Loose source route along host-list (IPv4-only)
-k Strict source route along host-list (IPv4-only)
-w Timeout in milliseconds to wait for each reply
-R Use routing header to test reverse route also (IPv6-only, deprecated per RFC 5095)
-S Source address to use
-c Routing compartment identifier
-p Ping a Hyper-V Network Virtualization provider address
-4 Force using IPv4
-6 Force using Ipv6

.EXAMPLE

.NOTES
Currently the only commands added from list above are -n, -l. Others will be added when needed.

.LINK
https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/ping
            
#>

#DOT source library: Hier worden andere bestanden ingeladen die nodig zijn voor de werking van de ServiceDesk Toolkit 2.0

function Get-Ping
{
    [CmdletBinding()]
    param
    (
    $Hardware,
    $NumberOfAttempts,
    $BufferSize
    )

            #Checkt of variabele leeg is
            if(!$NumberOfAttempts)
            {
                $NumberOfAttempts = 4
            }

            #Checkt of variabele leeg is
            if(!$BufferSize)
            {
                $BufferSize = 32
            }

            $Hardware
            Write-Host "Pinging " $Hardware
            
            
            #Ping $Hardware -n $NumberOfAttempts -l $BufferSize
            $PingResult = Test-Connection -ComputerName $Hardware -BufferSize $BufferSize -Count $NumberOfAttempts

            Write-Output $PingResult
}