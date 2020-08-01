#https://superuser.com/questions/123242/can-i-find-the-session-id-for-a-user-logged-on-to-another-machine

FUNCTION Get-UserNameSessionIDMap ($Comp)
{
  $quserRes = quser /server:$comp | select -skip 1
  if (!$quserRes) { RETURN }
  $quCSV = @()
  $quCSVhead = "SessionID","UserName","LogonTime"
  foreach ($qur in $quserRes) 
  {
    $qurMap = $qur.Trim().Split(" ") | ? {$_}
    if ($qur -notmatch " Disc   ") { $quCSV += $qurMap[2] + "|" + $qurMap[0] + "|" + $qurMap[5] + " " + $qurMap[6] }
    else { $quCSV += $qurMap[1] + "|" + $qurMap[0] + "|" + $qurMap[4] + " " + $qurMap[5] } #disconnected sessions have no SESSIONNAME, others have ica-tcp#x
  }
  $quCSV | ConvertFrom-CSV -Delimiter "|" -Header $quCSVhead
} #end function Get-UserNameSessionIDMap

Get-UserNameSessionIDMap -Comp "VDI-307-030"