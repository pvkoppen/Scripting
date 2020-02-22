function Copy-UserGroups
{
    [CmdletBinding()]
    param 
    (
        # User to copy from
        [Parameter(Mandatory)]
        [string]
        $sourceUser,

        # User to copy to
        [Parameter(Mandatory)]
        [string]
        $destinationUser
    )

    If ((Get-ADUser -identity $sourceUser -ErrorAction SilentlyContinue) -eq $null)
    {
        Write-Error "$sourceUser doesn't exist"
        exit
    }

    If ((Get-ADUser -identity $destinationUser -ErrorAction SilentlyContinue) -eq $null)
    {
        Write-Error "$destinationUser doesn't exist"
        exit
    }

    Get-ADuser -identity $sourceUser -properties MemberOf | 
        Select-Object MemberOf -expandproperty MemberOf |
        Add-AdGroupMember -Members $destinationUser -ErrorAction SilentlyContinue
}

Copy-UserGroups -sourceUser testuser001 -destinationUser testuser002

