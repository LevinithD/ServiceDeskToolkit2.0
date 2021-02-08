Function Get-SamAccountName
{
    Param(
         $Initials,
         $Surname
         )

        If ($Initials.Length -gt 2)
        {
           # Hier moet per 2-tal karakters gecontroleerd worden of er karakter-punt-karakter-punt staat in een loop
        }
        Else
        {
            If ($Initials -notmatch '\.$')
                {
                    $Initials += '.'
                }
        }
         
        Get-ADUSER -Filter {Initials -like $Initials -and sn -like $Surname} | Select-Object SamAccountName
    
}

Get-SamAccountName -Initials "Y" -Surname "Bool"