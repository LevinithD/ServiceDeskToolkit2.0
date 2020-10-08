# https://devblogs.microsoft.com/scripting/automating-quser-through-powershell/

Function Get-UserSession
{

    Param
    (
        $ADUser
    )

    $computers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
    
    foreach ( $computer in $computers )
    {
	    $quserResult = quser /server:$computer 2>&1
	    
        If ( $quserResult.Count -gt 0 )
        {
		    $quserRegex = $quserResult | ForEach-Object -Process { $_ -replace '\s{2,}',',' }
		    $quserObject = $quserRegex | ConvertFrom-Csv
		    $userSession = $quserObject | Where-Object -FilterScript { $_.USERNAME -eq $ADUser }
		    

            $userSession
            <#
            If ( $userSession )
		    {
			    logoff $userSession.ID /server:$computer
		    }
            #>
    	}
    }

}

Get-UserSession $env:USERNAME