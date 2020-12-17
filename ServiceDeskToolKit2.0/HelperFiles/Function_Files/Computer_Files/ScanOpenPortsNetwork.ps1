#https://techcommunity.microsoft.com/t5/itops-talk-blog/powershell-basics-how-to-scan-open-ports-within-a-network/ba-p/924149
#Get values
$port = read-host "Enter port(s) to scan"
$network = read-host "Enter network(s) IP to scan"
$range = read-host "Enter IP range(s) to scan (Empty = default is 1-254)"
$path = C:\reports

#Enable silent scan (without error reporting) of said network
$ErrorActionPreference= ‘silentlycontinue’

#Checks to see if range has values
If (!$range)
    {
        $range = 1..254
    }

#Calling the IP addresses one by one from the desired range and displaying the percentage to complete
$(Foreach ($add in $range)
    { 
    $ip = “{0}.{1}” –F $network,$add
    Write-Progress “Scanning Network” $ip -PercentComplete (($add/$range.Count)*100)

    #Pinging the desired IP via the Test-Connection cmdlet to validate its existence on the network
    If(Test-Connection –BufferSize 32 –Count 1 –quiet –ComputerName $ip)
        { 
        #Attempt made to connect to the desired port for testing
        $socket = new-object System.Net.Sockets.TcpClient($ip, $port)
        
        #Report success if the desired port is open
        If($socket.Connected) 
        { 
            “$ip port $port open” 
            $socket.Close() 
        }
    else 
        { 
        “$ip port $port not open” }
        }
    #Create the CSV output file reporting on desired open port
    }) | Out-File $path + \portscan.csv