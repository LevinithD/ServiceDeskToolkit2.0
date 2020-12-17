[cmdletbinding()]
param(
  $ComputerName=$env:COMPUTERNAME,
  [parameter(Mandatory=$true)]
  $ProcessName
)
$Processes = Get-WmiObject -Class Win32_Process -ComputerName $ComputerName -Filter "name='$ProcessName'"
 
foreach ($process in $processes) {
  $returnval = $process.terminate()
  $processid = $process.handle
 
if($returnval.returnvalue -eq 0) {
  write-host "The process $ProcessName `($processid`) terminated successfully"
}
else {
  write-host "The process $ProcessName `($processid`) termination has some problems"
}
}
