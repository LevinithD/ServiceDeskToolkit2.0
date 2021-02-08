Function Invoke-Tracert
{
    [CmdLetBinding()]
    param(
          $address
         )

    $ping = new-object System.Net.NetworkInformation.Ping
    $timeout = 5000
    $maxttl  = 64
    
    $message = [System.Text.Encoding]::Default.GetBytes("MESSAGE")
    $dontfragment = $false
    $success = [System.Net.NetworkInformation.IPStatus]::Success

    echo "Tracing $address"
    for ($ttl=1;$i -le $maxttl; $ttl++) 
    {
        $popt = new-object System.Net.NetworkInformation.PingOptions($ttl, $dontfragment)   
        $reply = $ping.Send($address, $timeout, $message, $popt)


        $addr = $reply.Address
        $rtt = $reply.RoundtripTime

        try 
        {
            $dns = [System.Net.Dns]::GetHostByAddress($addr)
        } 
        catch 
        {
            $dns = "-"
        }

        $name = $dns.HostName
    
        echo "Hop: $ttl`t= $addr`t($name)"
        
        if($reply.Status -eq $success) 
        {
            break
        }
    }
}

Mid-Waged-Mans-Tracert stackoverflow.com