<#
	.SYNOPSIS
		Displays an object's values and the 'dot' paths to them
	
	.DESCRIPTION
		A detailed description of the Display-Object function.
	
	.PARAMETER TheObject
		The object that you wish to display
	
	.PARAMETER depth
		the depth of recursion (keep it low!)
	
	.PARAMETER Avoid
		an array of names of pbjects or arrays you wish to avoid.
	
	.PARAMETER Parent
		For internal use, but you can specify the name of the variable
	
	.PARAMETER CurrentDepth
		For internal use
	
	.NOTES
		Additional information about the function.
		URL: https://www.red-gate.com/simple-talk/blogs/display-object-a-powershell-utility-cmdlet/
#>
function Display-Object
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		$TheObject,
		[int]$depth = 5,
		[Object[]]$Avoid = @('#comment'),
		[string]$Parent = '$',
		[int]$CurrentDepth = 0
	)
	
	if (($CurrentDepth -ge $Depth) -or
		($TheObject -eq $Null)) { return; } #prevent runaway recursion
	$ObjectTypeName = $TheObject.GetType().Name #find out what type it is
	if ($ObjectTypeName -in 'HashTable', 'OrderedDictionary')
	{
		#If you can, force it to be a PSCustomObject
		$TheObject = [pscustomObject]$TheObject;
		$ObjectTypeName = 'PSCustomObject'
	}
	if (!($TheObject.Count -gt 1)) #not something that behaves like an array
	{
		# figure out where you get the names from
		if ($ObjectTypeName -in @('PSCustomObject'))
		# Name-Value pair properties created by Powershell 
		{ $MemberType = 'NoteProperty' }
		else
		{ $MemberType = 'Property' }
		#now go through the names 		
		$TheObject |
		gm -MemberType $MemberType | where { $_.Name -notin $Avoid } |
		Foreach{
			Try { $child = $TheObject.($_.Name); }
			Catch { $Child = $null } # avoid crashing on write-only objects
			if ($child -eq $null -or #is the current child a value or a null?
				$child.GetType().BaseType.Name -eq 'ValueType' -or
				$child.GetType().Name -in @('String', 'String[]'))
			{ [pscustomobject]@{ 'Path' = "$Parent.$($_.Name)"; 'Value' = $Child; } }
			elseif (($CurrentDepth + 1) -eq $Depth)
			{
				[pscustomobject]@{ 'Path' = "$Parent.$($_.Name)"; 'Value' = $Child; }
			}
			else #not a value but an object of some sort
			{
				Display-Object -TheObject $child -depth $Depth -Avoid $Avoid -Parent "$Parent.$($_.Name)" `
							   -CurrentDepth ($currentDepth + 1)
			}
			
		}
	}
	else #it is an array
	{
		0..($TheObject.Count - 1) | Foreach{
			$child = $TheObject[$_];
			if (($child -eq $null) -or #is the current child a value or a null?
				($child.GetType().BaseType.Name -eq 'ValueType') -or
				($child.GetType().Name -in @('String', 'String[]'))) #if so display it 
			{ [pscustomobject]@{ 'Path' = "$Parent[$_]"; 'Value' = "$($child)"; } }
			elseif (($CurrentDepth + 1) -eq $Depth)
			{
				[pscustomobject]@{ 'Path' = "$Parent[$_]"; 'Value' = "$($child)"; }
			}
			else #not a value but an object of some sort so do a recursive call
			{
				Display-Object -TheObject $child -depth $Depth -Avoid $Avoid -parent "$Parent[$_]" `
							   -CurrentDepth ($currentDepth + 1)
			}
			
		}
	}
}
