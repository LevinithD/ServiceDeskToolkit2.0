Function Get-UserNameSessionIDMap
{
    [CmdletBinding()]
    Param
    (
        $ADUserName
    )
    
    $ADListComputer = @()
    $ADListComputer = Get-Content C:\Users\loc.BOOY3105.TWEEDEKAMER\Documents\Powershell\ServiceDeskToolKit2.0\HelperFiles\Temp_Files\AllComputers.txt

    foreach($ADComputer in $ADListComputer)
    {        
        
        If(-Not $ADComputer.StartsWith("PW"))
        {
           Continue
        }

        $quserRes = quser /server:$ADComputer | select -skip 1
            
        if (!$quserRes) 
        { 
            Continue
        }
        
        $quCSV = @()
        
        $quCSVhead = "Computer","SessionID","UserName","LogonTime"
        
        foreach ($qur in $quserRes) 
        {
            $qurMap = $qur.Trim().Split(" ") | ? {$_}
            
            
            If ($qurMap[0] -eq $ADUserName)
            {
                if ($qur -notmatch " Disc   ") 
                { 
                    $quCSV += $ADComputer + "|" + $qurMap[2] + "|" + $qurMap[0] + "|" + $qurMap[5] + " " + $qurMap[6] 
                }
                else 
                { 
                    $quCSV += $ADComputer + "|" + $qurMap[1] + "|" + $qurMap[0] + "|" + $qurMap[4] + " " + $qurMap[5] 
                } #disconnected sessions have no SESSIONNAME, others have ica-tcp#x
            }
        }
        
        $quCSV | ConvertFrom-CSV -Delimiter "|" -Header $quCSVhead
    }  
} 
Get-UserNameSessionIDMap -ADUserName BOOY3105 -ErrorAction SilentlyContinue