Function Get-AllComputers
{

    $AllComputers = Get-ADComputer -Filter * -Property * | Select-Object Name,OperatingSystem,OperatingSystemVersion,ipv4Address | Out-File C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Temp_Files\AllComputers.txt
}

Get-AllComputers