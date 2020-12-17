Function Get-InstalledPrograms
{
    Param($ComputerNames)

    If($ComputerNames -eq $null)
    {
        $ComputerNames = Get-Content C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Temp_Files\AllComputers.txt | Foreach {($_.split(" ", [StringSplitOptions]"RemoveEmptyEntries")[0])}
    }

    Foreach ($ComputerName in $ComputerNames)
    {
        write-host $ComputerName
        $TestConnection = Test-Connection $ComputerName -Count 1

        If(($TestConnection -ne "") -or ($TestConnection -ne $null))
        {
            Get-WmiObject -Namespace ROOT\CIMV2 -Class Win32_Product -ComputerName $ComputerName
        }
    }
    
}

Get-InstalledPrograms