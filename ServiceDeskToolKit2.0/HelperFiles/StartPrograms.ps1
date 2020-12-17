$ProgramsArray = "iexplore.exe", 
                 "firefox.exe", 
                 "mRemoteNG.exe", 
                 "Outlook.exe", 
                 "ServiceDesk Toolkit.exe"

Foreach ($Program in $ProgramArray)
{
    If (!(Get-Process $Program))
    {
        Start-Process $Program
        Write-Host $Program + " is running" 
    }
}