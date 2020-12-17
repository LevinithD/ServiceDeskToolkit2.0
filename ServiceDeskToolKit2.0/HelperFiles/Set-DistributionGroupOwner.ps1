Function Set-DistributionGroupOwner
{
    [CmdletBinding()]
    Param
    (
        $DistributionGroup,
        $ADUserName
    )

    Set-DistributionGroup -Identity $DistributionGroup -BypassSecurityGroupManagerCheck -ManagedBy $ADUserName
}