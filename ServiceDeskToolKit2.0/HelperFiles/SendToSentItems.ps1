Function SendtoSentItems
{
    [CmdletBinding()]
    Param
    (
        $Mailbox    
    )
    
    Set-Mailbox $Mailbox -MessageCopyForSentAsEnabled $true
    Set-Mailbox $Mailbox -MessageCopyForSendOnBehalfEnabled $true

}