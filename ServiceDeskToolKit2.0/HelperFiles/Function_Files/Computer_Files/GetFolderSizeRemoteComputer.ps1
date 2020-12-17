# https://community.spiceworks.com/topic/2223014-getting-folder-sizes-on-remote-computers
Function Get-FolderSizeRemoteComputer
{
  [CmdletBinding()]
  Param
  (
    $computer
  )  
  
    if (Test-Connection -ComputerName $computer -Count 1) 
    {
        Invoke-Command -ComputerName $computer -ScriptBlock
        {
            $Folders = Get-ChildItem "C:\" -Recurse | Where-Object{$_.PSIsContainer -eq $true -and $_.Name -match "Users"}
            foreach ($folder in $Folders.fullname) 
            {
                $size = [math]::round((Get-ChildItem $folder -Recurse | Measure-Object -Property Length -sum).sum / 1MB)
                [pscustomobject]@{
                    Folder   = $folder
                    SizeinMB = if (-not($size -gt 0)) { 'Empty' }else { $size }
                }
            }
        }
    }
    else 
    {
        [pscustomobject]@{
            pscomputername = $computer
            Folder   = 'n/a'
            SizeinMB = 'n/a'
    }
}

$result | 
select-object pscomputername, folder, SizeinMB
# export-csv "$env:userprofile\desktop\results.csv" -NoTypeInformation
}

Get-FolderSizeRemoteComputer -computer PW3695