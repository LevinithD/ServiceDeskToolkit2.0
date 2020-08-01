<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER

.EXAMPLE

.NOTES

.LINK
#>

#DOT source library: Hier worden andere bestanden ingeladen die nodig zijn voor de werking van de ServiceDesk Toolkit 2.0

function Get-MacAddress
{
    [cmdletbinding()]
    param
    (
    $Hardware
    )

    $MacAddress = ""

    if($hardware)
    {
        Try
        {
            $MacAddress = (Get-WmiObject -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $Hardware | Select-Object -Property MACAddress, Description)
        }
        
        Catch
        {
            $MacAddress = "RPC Server unavailable"
        }

        Write-Output $MacAddress
        $lbl_ADComputerMAC.text = "MAC-Address : " + $MacAddress
        $lbl_ADComputerMAC.Refresh()
    }

    
}