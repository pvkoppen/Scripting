Function Get-RvNetIpAddressDetails
{
    <#
    .NOTES
        Version: 1.1

    .SYNOPSIS
        Get details about the defined IPv4 address and subnet mask. Pass IP address and subnet mask (regardless if it is passed in classes for example 255.255.255.0 or in CIDR notation for example 24) and get IP, subnet mask in classes and in CIDR notation, network IP address and IP ranges.

    .DESCRIPTION
        Developer
            Developer: Rudolf Vesely, http://rudolfvesely.com/
            Copyright (c) Rudolf Vesely. All rights reserved
            License: Free for private use only

            RV are initials of the developer's name Rudolf Vesely and distingue names of Rudolf Vesely's cmdlets from the other cmdlets. Type “Get-Command *-Rv*” (without quotes) to list all Rudolf Vesely’s cmdlets (functions).

        Description
            Get details about the defined IP address and subnet mask. Get IPv4 address (for example 10.25.38.6), subnet mask in classes (255.255.0.0) or in CIDR notation (16), network IP address (10.25.0.0), broadcast IP address (10.25.255.255) and full IP address range (10.25.0.0 - 10.25.255.255) or IP addresses range applicable in the given subnet (10.25.0.1 - 10.25.255.254).

            You can pass subnet mask in classes or in CIDR notation and you will get the opposite.

        Advices
            Use -Verbose switch. All Rudolf Vesely's cmdlets (functions) are verbose with a lot of details.

        Requirements
            Developed and tested on PowerShell 4.0 but should be functional on PowerShell 3.0.

        Installation
            Put text ". C:\Path\Where\The\PS1\File\Is\Saved\this_file.ps1" (without quotes) into one of the PowerShell profile files (for example in the Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1).

    .PARAMETER IpAddress
        IPv4 address without defined subnet mask (for example 192.168.1.2) or with CIDR notation (for example 10.25.85.62/16) - leading zeros are allowed (for example 010.001.100.007)

    .PARAMETER SubnetMaskCidr
        Subnet mask in CIDR notation (Prefix Length) - for example 16 (stands for 255.255.0.0)

    .PARAMETER SubnetMask
        Subnet mask - leading zeros (for example 255.255.000.000) are allowed.

    .PARAMETER Output
        You can set additional details to output. These details are not in output by default because their generation can be very time consuming.
            Possibilities:
                IpAddressRangeApplicableAll - All IP addresses applicable in the given subnet (no network and no broadcast IP addresses)
                IpAddressRangeAll - All IP addresses in the given subnet including network and broadcast IP addresses

    .EXAMPLE
        '127.000.000.001/24', '192.168.22.9/24' | Get-RvNetIpAddressDetails -Verbose

    .EXAMPLE
        '127.000.000.001', '192.168.22.9' | Get-RvNetIpAddressDetails  -SubnetMask '255.255.128.0' -Verbose

    .EXAMPLE
        Get-RvNetIpAddressDetails -IpAddress '192.168.22.59/24' -Output IpAddressRangeApplicableAll -Verbose

    .EXAMPLE
        Get-RvNetIpAddressDetails -IpAddress '192.168.22.59/24' -Output IpAddressRangeAll -Verbose

    .EXAMPLE
        Get-RvNetIpAddressDetails -IpAddress '10.22.33.9' -SubnetMaskCidr 16 -Verbose

    .EXAMPLE
        Get-RvNetIpAddressMultipleDetails -IpAddress '192.168.22.8', '192.168.22.9' -SubnetMaskCidr 19, 20 -AmountMinimum 2 -AmountMaximum 2

    .INPUTS
        System.UInt32[]
        System.String[]

    .OUTPUTS
        System.Object

    .LINK
        http://rudolfvesely.com/
    #>

    [CmdletBinding()]

    Param
    (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'IpAddress',
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false
            # HelpMessage = ''
        )]
        [Alias('IpV4Address')]
        [ValidateScript({ [string]::IsNullOrEmpty($_) -or
            $_ -match '^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.' +
            '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.' +
            '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.' +
            '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' +
            '(/0*([1-9]|[12][0-9]|3[0-2]))?$' })]
        [string[]]
        $IpAddress,  # Null or empty or <IPv4> or <IPv4>/<CIDR>

        [Parameter(
            Mandatory = $false,
            Position = 1,
            # ParameterSetName = ,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false
            # HelpMessage = ''
        )]
        [Alias('PrefixLength')]
        [ValidateScript({ !$_ -or
            ($_ -ge 1 -and $_ -le 32) })] # Null or 0 or range
        [int]
        $SubnetMaskCidr,

        [Parameter(
            Mandatory = $false,
            Position = 2,
            # ParameterSetName = ,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false
            # HelpMessage = ''
        )]
        [ValidateScript({ [string]::IsNullOrEmpty($_) -or
            $_ -match '^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.' +
            '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.' +
            '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.' +
            '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$' })] # Null or empty or IPv4
        [string]
        $SubnetMask,

        [Parameter(
            Mandatory = $false,
            # Position = ,
            # ParameterSetName = ,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $false,
            ValueFromRemainingArguments = $false
            # HelpMessage = ''
        )]
        [ValidateSet(
            'IpAddressRangeApplicableAll',
            'IpAddressRangeAll'
        )]
        [string[]]
        $Output
    )

    Begin
    {
        Write-Verbose '- Get-RvNetIpAddressDetails: Start'
        Write-Verbose '    - Copyright (c) Rudolf Vesely (http://rudolfvesely.com/). All rights reserved'
        Write-Verbose '        - License: Free for private use only'



        <#
        Functions
        #>

        # Remove leading zeros - 127.000.100.001 -> 127.0.100.1
        Function Remove-RvNetIpAddressLeadingZeros
        {
            <#
            .DESCRIPTION
                Developer
                    Developer: Rudolf Vesely, http://rudolfvesely.com/
                    Copyright (c) Rudolf Vesely. All rights reserved
                    License: Free for private use only
            #>

            Param
            (
                [string[]]
                $IpAddress
            )

            foreach ($ipAddressItem in $IpAddress)
            {
                # Return
                $ipAddressItem -replace '0*([0-9]+)', '${1}'
            }
        }

        Function Convert-RvNetIpAddressToInt64 ()
        {
            <#
            .DESCRIPTION
                Developer
                    Developer: Rudolf Vesely, http://rudolfvesely.com/
                    Copyright (c) Rudolf Vesely. All rights reserved
                    License: Free for private use only
            #>

            Param
            (
                [string]
                $IpAddress
            )

            $ipAddressParts = $IpAddress.Split('.') # IP to it's octets

            # Return
            [int64]([int64]$ipAddressParts[0] * 16777216 +
                    [int64]$ipAddressParts[1] * 65536 +
                    [int64]$ipAddressParts[2] * 256 +
                    [int64]$ipAddressParts[3])
        }

        Function Convert-RvNetInt64ToIpAddress()
        {
            <#
            .DESCRIPTION
                Developer
                    Developer: Rudolf Vesely, http://rudolfvesely.com/
                    Copyright (c) Rudolf Vesely. All rights reserved
                    License: Free for private use only
            #>

            Param
            (
                [int64]
                $Int64
            )

            # Return
            '{0}.{1}.{2}.{3}' -f ([math]::Truncate($Int64 / 16777216)).ToString(),
                ([math]::Truncate(($Int64 % 16777216) / 65536)).ToString(),
                ([math]::Truncate(($Int64 % 65536)/256)).ToString(),
                ([math]::Truncate($Int64 % 256)).ToString()
        }

        Function Convert-RvNetSubnetMaskCidrToClasses
        {
            <#
            .DESCRIPTION
                Developer
                    Developer: Rudolf Vesely, http://rudolfvesely.com/
                    Copyright (c) Rudolf Vesely. All rights reserved
                    License: Free for private use only
            #>

            Param
            (
                [int]
                $SubnetMaskCidr
            )

            # Return
            Convert-RvNetInt64ToIpAddress -Int64 ([convert]::ToInt64(('1' * $SubnetMaskCidr + '0' * (32 - $SubnetMaskCidr)), 2))
        }

        Function Convert-RvNetSubnetMaskClassesToCidr
        {
            <#
            .DESCRIPTION
                Developer
                    Developer: Rudolf Vesely, http://rudolfvesely.com/
                    Copyright (c) Rudolf Vesely. All rights reserved
                    License: Free for private use only
            #>

            Param
            (
                [string]
                $SubnetMask
            )

            [int64]$subnetMaskInt64 = Convert-RvNetIpAddressToInt64 -IpAddress $SubnetMask

            $subnetMaskCidr32Int = 2147483648 # 0x80000000 - Same as Convert-RvNetIpAddressToInt64 -IpAddress '255.255.255.255'

            $subnetMaskCidr = 0
            for ($i = 0; $i -lt 32; $i++)
            {
                if (!($subnetMaskInt64 -band $subnetMaskCidr32Int) -eq $subnetMaskCidr32Int) { break } # Bitwise and operator - Same as "&" in C#

                $subnetMaskCidr++
                $subnetMaskCidr32Int = $subnetMaskCidr32Int -shr 1 # Bit shift to the right - Same as ">>" in C#
            }

            # Return
            $subnetMaskCidr
        }

        Function Get-RvNetIpAddressRangeAll
        {
            <#
            .DESCRIPTION
                Developer
                    Developer: Rudolf Vesely, http://rudolfvesely.com/
                    Copyright (c) Rudolf Vesely. All rights reserved
                    License: Free for private use only
            #>

            Param
            (
                [int64]
                $IpAddressRangeFirstInt64,
                [int64]
                $ipAddressRangeLastInt64
            )

            $ipAddressRangeAll = @()

            for ($i = $IpAddressRangeFirstInt64; $i -lt ($ipAddressRangeLastInt64 + 1); $i++)
            {
                $ipAddressRangeAll += Convert-RvNetInt64ToIpAddress -Int64 $i
            }

            # Return
            $ipAddressRangeAll
        }
    }

    Process
    {
        :ipAddressItemItems foreach ($ipAddressItem in $IpAddress)
        {
            # Remove leading zeros
            $ipAddressItem = Remove-RvNetIpAddressLeadingZeros -IpAddress $ipAddressItem
            if ($SubnetMask) { $SubnetMask = Remove-RvNetIpAddressLeadingZeros -IpAddress $SubnetMask }

            # Obtaining CIDR from $IpAddress
            if ($ipAddressItem -like '*/*')
            {
                $items = $ipAddressItem.Split('/')

                $ipAddressItem = [string]$items[0]
                try { $SubnetMaskCidr = [int]$items[1] }
                catch
                {
                    Write-Error 'Incorrect CIDR notation of the subnet mask after slash afer the IP address. Whole IP address will be skipped.'
                    continue ipAddressItemItems
                }
            }

            # Obtaining opposite type of the subnet mask
            if ($SubnetMaskCidr)
            {
                try
                {
                    $SubnetMask = Convert-RvNetSubnetMaskCidrToClasses -SubnetMaskCidr $SubnetMaskCidr
                }
                catch
                {
                    Write-Error 'Provided subnet mask (CIDR) is invalid. Whole IP address will be skipped.'
                    continue ipAddressItemItems
                }
            }
            elseif ($SubnetMask)
            {
                try
                {
                    $SubnetMaskCidr = Convert-RvNetSubnetMaskClassesToCidr -SubnetMaskCidr $SubnetMask
                }
                catch
                {
                    Write-Error 'Provided subnet mask (classes) is invalid. Whole IP address will be skipped.'
                    continue ipAddressItemItems
                }
            }
            else
            {
                Write-Error 'Subnet mask (IP address with CIDR, independent CIDR or subnet mask classes) was not provided. Whole IP address will be skipped.'
                continue ipAddressItemItems
            }

            # Objects
            try
            {
                $ipAddressObject = [Net.IPAddress]::Parse($ipAddressItem)
                $subnetMaskObject = [Net.IPAddress]::Parse($SubnetMask)
                $ipAddressNetworkObject = New-Object System.Net.IPAddress ($subnetMaskObject.Address -band $ipAddressObject.Address)
                $ipAddressBroadcastObject = New-Object System.Net.IPAddress (([System.Net.IPAddress]::Parse('255.255.255.255').Address -bxor $subnetMaskObject.Address -bor $ipAddressNetworkObject.Address))

                $ipAddressRangeFirstInt64 = Convert-RvNetIpAddressToInt64 -ip $ipAddressNetworkObject.IPAddressToString
                $ipAddressRangeLastInt64 = Convert-RvNetIpAddressToInt64 -ip $ipAddressBroadcastObject.IPAddressToString

                $ipAddressRangeApplicableFirstInt64 = $ipAddressRangeFirstInt64 + 1
                $ipAddressRangeApplicableLastInt64 = $ipAddressRangeLastInt64 - 1
            }
            catch
            {
                Write-Error 'Error during obtaining details about the currently processed IP address. Whole IP address will be skipped.'
                continue ipAddressItemItems
            }

            # IP addresses - Range
            try
            {
                if ($SubnetMaskCidr -lt 31)
                {
                    $ipAddressRangeApplicableFirst = Convert-RvNetInt64ToIpAddress -Int64 $ipAddressRangeApplicableFirstInt64
                    $ipAddressRangeApplicableLast = Convert-RvNetInt64ToIpAddress -Int64 $ipAddressRangeApplicableLastInt64
                }
                else
                {
                    $ipAddressRangeApplicableFirst = 0
                    $ipAddressRangeApplicableLast = 0
                }
            }
            catch
            {
                Write-Error 'Error during obtaining details about the currently processed IP address. Whole IP address will be skipped.'
                continue ipAddressItemItems
            }

            <# Additional details to output #>
            # IP addresses - Range - All items
            if ($Output -contains 'IpAddressRangeApplicableAll' -and $SubnetMaskCidr -lt 31)
            {
                $ipAddressRangeApplicableAll = Get-RvNetIpAddressRangeAll `
                    -IpAddressRangeFirstInt64 $ipAddressRangeApplicableFirstInt64 `
                    -ipAddressRangeLastInt64 $ipAddressRangeApplicableLastInt64
            }
            if ($Output -contains 'IpAddressRangeAll' -and $SubnetMaskCidr -lt 31)
            {
                $ipAddressRangeAll = Get-RvNetIpAddressRangeAll `
                    -IpAddressRangeFirstInt64 $ipAddressRangeFirstInt64 `
                    -ipAddressRangeLastInt64 $ipAddressRangeLastInt64
            }

            # Output
            try
            {
                $outputFull =
                [PsCustomObject]@{
                    IpAddress = $ipAddressObject.IPAddressToString
                    IpAddressAndSubnetMaskCidr = $ipAddressObject.IPAddressToString + '/' + [string]$SubnetMaskCidr
                    SubnetMaskCidr = $SubnetMaskCidr
                    SubnetMask = $SubnetMask
                    IpAddressNetwork = $(if ($SubnetMaskCidr -lt 31) { $ipAddressNetworkObject.IPAddressToString } else {0} )
                    IpAddressNetworkAndSubnetMaskCidr = $(if ($SubnetMaskCidr -lt 31) { ($ipAddressNetworkObject.IPAddressToString + '/' + [string]$SubnetMaskCidr) } else {0} )
                    IpAddressBroadcast = $(if ($SubnetMaskCidr -lt 31) { $ipAddressBroadcastObject.IPAddressToString } else {0} )
                    IpAddressBroadcastAndSubnetMaskCidr = $(if ($SubnetMaskCidr -lt 31) { ($ipAddressBroadcastObject.IPAddressToString + '/' + [string]$SubnetMaskCidr) } else {0} )
                    IpAddressRangeApplicableFirst = $ipAddressRangeApplicableFirst
                    IpAddressRangeApplicableLast = $ipAddressRangeApplicableLast
                    IpAddressRangeApplicableAll = $ipAddressRangeApplicableAll
                    IpAddressRangeAll = $ipAddressRangeAll
                }
            }
            catch
            {
                throw 'It is not possible to assemble the output object.'
            }

            if ($outputFull.IpAddressRangeApplicableAll) { Write-Verbose ('All IP addresses applicable in the given subnet (no network and no broadcast IP addresses): {0}' -f ($outputFull.IpAddressRangeApplicableAll -join ', ')) }
            if ($outputFull.IpAddressRangeAll) { Write-Verbose ('All IP addresses in the given subnet including network and broadcast IP addresses: {0}' -f ($outputFull.IpAddressRangeAll -join ', ')) }

            # Return
            $outputFull
        }
    }

    End
    {
        Write-Verbose '- Get-RvNetIpAddressDetails: End'
    }
}



Function Get-RvNetIpAddressMultipleDetails
{
    <#
    .SYNOPSIS
        Using Get-RvNetIpAddressDetails get IP addresses details and check if defined number was obtained.

        More information in the help for Get-RvNetIpAddressDetails function.

    .DESCRIPTION
        Developer
            Developer: Rudolf Vesely, http://rudolfvesely.com/
            Copyright (c) Rudolf Vesely. All rights reserved
            License: Free for private use only

        Description
            Using Get-RvNetIpAddressDetails get IP addresses details and check if defined number was obtained.

            More information in the help for Get-RvNetIpAddressDetails function.

            Use: Get-Help Get-RvNetIpAddressDetails

    .PARAMETER AmountMinimum
        Minimal number of IP addresses details sets that must be obtained. Set same number of minimum and maximum in order to check exact number.

    .PARAMETER AmountMaximum
        Maximal number of IP addresses details sets that must be obtained.

    .PARAMETER ItemProcessing
        Configuration settings how the items should be processed.
            Values
                Defined
                    All - Process allitems.
                    StopOnFirstIncorrect - Process only items that are correct and stop processing on first incorrect item.
    #>

    [CmdletBinding()]

    Param
    (
        [Parameter(
            Mandatory = $false,
            Position = 0,
            # ParameterSetName = ,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false
            # HelpMessage = ''
        )]
        [Alias('IpV4Address')]
        [string[]]
        $IpAddress,

        [Parameter(
            Mandatory = $false,
            Position = 1,
            # ParameterSetName = ,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false
            # HelpMessage = ''
        )]
        [Alias('PrefixLength')]
        [string[]]
        $SubnetMaskCidr,

        [Parameter(
            Mandatory = $false,
            Position = 2,
            # ParameterSetName = ,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false
            # HelpMessage = ''
        )]
        [string[]]
        $SubnetMask,

        [Parameter(
            Mandatory = $false,
            # Position = ,
            # ParameterSetName = ,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $false,
            ValueFromRemainingArguments = $false
            # HelpMessage = ''
        )]
        [ValidateSet(
            'IpAddressRangeApplicableAll',
            'IpAddressRangeAll'
        )]
        [string[]]
        $Output,

        [Parameter(
            Mandatory = $false,
            Position = 3,
            # ParameterSetName = ,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $false,
            ValueFromRemainingArguments = $false
            # HelpMessage = ''
        )]
        [int]
        $AmountMinimum = -1,

        [Parameter(
            Mandatory = $false,
            Position = 4,
            # ParameterSetName = ,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $false,
            ValueFromRemainingArguments = $false
            # HelpMessage = ''
        )]
        [int]
        $AmountMaximum = -1,

        [Parameter(
            Mandatory = $false,
            # Position = ,
            # ParameterSetName = ,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $false,
            ValueFromRemainingArguments = $false
            # HelpMessage = ''
        )]
        [ValidateSet(
            'All',
            'StopOnFirstIncorrect'
        )]
        [string]
        $ItemProcessing = 'All'
    )

    Begin
    {
        Write-Verbose '- Get-RvNetIpAddressMultipleDetails: Start'
        Write-Verbose '    - Copyright (c) Rudolf Vesely (http://rudolfvesely.com/). All rights reserved'
        Write-Verbose '        - License: Free for private use only'
    }

    Process
    {
        # Checking passed arguments and obtaining details
        Write-Verbose ('    - Obtaining details about the IP addresses and subnet masks')
        $i = 0
        $ipAddressDetailsItems = @()
        foreach ($ipAddressItem in $IpAddress)
        {
            $parametersAndArguments = @{}
            $parametersAndArguments.Add('IpAddress', $ipAddressItem)
            if ($SubnetMaskCidr -and $SubnetMaskCidr[$i]) { $parametersAndArguments.Add('SubnetMaskCidr', $SubnetMaskCidr[$i]) }
            if ($SubnetMask -and $SubnetMask[$i]) { $parametersAndArguments.Add('SubnetMask', $SubnetMask[$i]) }
            if ($Output) { $parametersAndArguments.Add('Output', $Output) }
            $parametersAndArguments.Add('Debug', $false)
            $parametersAndArguments.Add('Verbose', $false)
            $parametersAndArguments.Add('ErrorAction', 'SilentlyContinue')

            $ipAddressDetails = Get-RvNetIpAddressDetails @parametersAndArguments

            if ($ItemProcessing -and !$ipAddressDetails)
            {
                Write-Verbose ('        - The IP address is not correct and the other will not be obtained.')
                break
            }

            $ipAddressDetailsItems += $ipAddressDetails

            Write-Verbose ('        - IP address details no. {0}: Obtained' -f $i)

            $i++
        }

        if ($AmountMinimum -ge 0)
        {
            if ($ipAddressDetailsItems.Count -lt $AmountMinimum)
            {
                Write-Error 'Required minimal number of IP addresses was not obtained.'
                return
            }
        }

        elseif ($AmountMaximum -ge 0)
        {
            if ($ipAddressDetailsItems.Count -gt $AmountMinimum)
            {
                Write-Error 'Required maximal number of IP addresses was not obtained.'
                return
            }
        }

        # Return
        $ipAddressDetailsItems
    }

    End
    {
        Write-Verbose '- Get-RvNetIpAddressMultipleDetails: End'
    }
}