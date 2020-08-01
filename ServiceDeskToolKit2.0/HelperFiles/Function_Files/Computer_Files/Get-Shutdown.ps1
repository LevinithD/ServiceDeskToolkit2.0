<#
.SYNOPSIS
This function enables shutting down/restarting (remote) computers.

.DESCRIPTION

.PARAMETER
/i 	Displays the Remote Shutdown Dialog box. The /i option must be the first parameter following the command. If /i is specified, all other options are ignored.
/l 	Logs off the current user immediately, with no time-out period. You cannot use /l with /m or /t.
/s 	Shuts down the computer.
/r 	Restarts the computer after shutdown.
/a 	Aborts a system shutdown. Effective only during the timeout period. To use /a, you must also use the /m option.
/p 	Turns off the local computer only (not a remote computer)—with no time-out period or warning. You can use /p only with /d or /f. If your computer does not support power-off functionality, it will shut down when you use /p, but the power to the computer will remain on.
/h 	Puts the local computer into hibernation, if hibernation is enabled. You can use /h only with /f.
/e 	Enables you to document the reason for the unexpected shutdown on the target computer.
/f 	Forces running applications to close without warning users.
    Caution: Using the /f option might result in loss of unsaved data.

/m \\<ComputerName> 	Specifies the target computer. Cannot be used with the /l option.
/t <XXX> 	Sets the time-out period or delay to XXX seconds before a restart or shutdown. This causes a warning to display on the local console. You can specify 0-600 seconds. If you do not use /t, the time-out period is 30 seconds by default.
/d [p|u:]<XX>:<YY> 	Lists the reason for the system restart or shutdown. The following are the parameter values:
p Indicates that the restart or shutdown is planned.
u Indicates that the reason is user defined.
    Note: If p or u are not specified, the restart or shutdown is unplanned.
 
XX Specifies the major reason number (positive integer less than 256).
YY Specifies the minor reason number (positive integer less than 65536).
/c <Comment> 	Enables you to comment in detail about the reason for the shutdown. You must first provide a reason by using the /d option. You must enclose comments in quotation marks. You can use a maximum of 511 characters.
/? 	Displays help at the command prompt, including a list of the major and minor reasons that are defined on your local computer. 

.EXAMPLE

.NOTES

.LINK
https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/shutdown

#>

#DOT source library: Hier worden andere bestanden ingeladen die nodig zijn voor de werking van de ServiceDesk Toolkit 2.0

function ADShutdown
{

[CmdletBinding()]
    param
    (
    $Hardware,
    $Restart,
    $DelayInSeconds
    )

    If ($Restart -eq "j")
    {
        #$Restart = -r
        Restart-Computer -ComputerName $Hardware -Force
    }
    Else
    {
        #$Restart = -s
        Stop-Computer -ComputerName $Hardware  -Force
    }

    #shutdown $Restart /m\\$Hardware -t $DelayInSeconds
}