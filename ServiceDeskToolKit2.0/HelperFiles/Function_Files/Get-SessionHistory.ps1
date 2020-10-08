
#https://www.codetwo.com/admins-blog/how-to-check-event-logs-with-powershell-get-eventlog/
function Get-SessionHistory
{

    [CmdletBinding()]
    param
    (
        $ComputerName
    )


    $logs = get-eventlog system -ComputerName $ComputerName -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-7);
    $res = @(); 
        ForEach ($log in $logs) 
        {
            If($log.instanceid -eq 7001) 
            {
                $type = "Logon"
            } 
            Elseif ($log.instanceid -eq 7002)
            {
                $type="Logoff"
            } 
            Elseif ($log.instanceid -eq 4800)
            {
                $type = "Lock"
            }
            Elseif ($log.instanceid -eq 4801)
            {
                $type = "Unlock"
            }
            Else 
            {
                Continue
            } 
 
            $res += New-Object PSObject -Property @{Time = $log.TimeWritten; "Event" = $type; User = (New-Object System.Security.Principal.SecurityIdentifier $Log.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])}};
    $res

}

Get-SessionHistory -ComputerName "PW3596"