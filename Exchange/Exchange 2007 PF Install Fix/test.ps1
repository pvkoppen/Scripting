# Copyright (c) 2006 Microsoft Corporation. All rights reserved.
#
# THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE RISK
# OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

Param(
	[string] $Server,
	[string] $TopPublicFolder = "",
	[string] $ServerToRemove = ""
)

# This function validates the scripts parameters
function ValidateParams
{
  $validInputs = $true
  $errorString =  ""

  if ($TopPublicFolder -eq "")
  {
    $validInputs = $false
    $errorString += "`nMissing parameter: The -TopPublicFolder parameter is required. Please pass in a valid Public Folder path, name, or entryID."
  }

  if ($ServerToRemove -eq "")
  {
    $validInputs = $false
    $errorString += "`nMissing parameter: The -ServerToRemove parameter is required. Please pass in a valid mailbox server identity"
  }

  if (!$validInputs)
  {
    Write-error "$errorString"
  }

  return $validInputs
}

# Function that returns true if the incoming argument is a help request
function IsHelpRequest
{
	param($argument)
	return ($argument -eq "-?" -or $argument -eq "-help");
}

# Function that displays the help related to this script following
# the same format provided by get-help or <cmdletcall> -?
function Usage
{
@"

NAME:
`tAddReplicaToPFRecursive.ps1

SYNOPSIS:
`tRemoves a server from the replica list for a public folder, and all
`tthe contained folders under it. If the server is not listed in the
`treplica list for a particular folder, nothing is changed for that
`tfolder.

SYNTAX:
`tRemoveReplicaFromPFRecursive.ps1
`t`t[-Server <ServerIdParameter>]
`t`t[-TopPublicFolder <PublicFolderIdParameter>]
`t`t[-ServerToRemove <ServerIdParameter>]

PARAMETERS:
`t-Server (optional)
`t`tThe server to operate against. Must be an Exchange 2007 Mailbox server
`t`twith a public folder database.  Defaults to a convenient server.

`t-TopPublicFolder (required)
`t`tThe folder identity of the top of the tree of folders to modify

`t-ServerToRemove (required)
`t`tThe server identity to remove from the replica list. Must be a server
`t`twith a public folder database.

`t-------------------------- EXAMPLE 1 --------------------------

C:\PS> .\RemoveReplicaFromPFRecursive.ps1 -TopPublicFolder "\Folder" -ServerToRemove "MyEx2003Server"

`t-------------------------- EXAMPLE 2 --------------------------

C:\PS> .\RemoveReplicaFromPFRecursive.ps1 -Server "MyEx2007Server" -TopPublicFolder "\Folder" -ServerToRemove "MyEx2003Server"

REMARKS:
`tReplica lists are updated quickly, but data replication can take a
`tsubstantial amount of time.  Client referrals to the removed server
`twill stop immediately, but content may remain on the server for a
`tsignificant amount of time until the system confirms the data is fully
`treplicated to at least one other replica.

`tA folder listing the server to be removed as its sole replica will not be modified.

RELATED LINKS:
`tAddReplicaToPFRecursive.ps1
`tMoveAllReplicas.ps1
`tRemoveReplicaFromPFRecursive.ps1
`tReplaceReplicaOnPFRecursive.ps1
`tGet-Help

"@
}

####################################################################################################
# Script starts here
####################################################################################################

# Check for Usage Statement Request
$args | foreach { if (IsHelpRequest $_) { Usage; exit; } }

# Validate the parameters
$ifValidParams = ValidateParams;

if (!$ifValidParams) { exit; }

$db = get-publicfolderdatabase -server $ServerToRemove -erroraction Stop

if ($server)
{
	$getpfcmd = "get-publicfolder -server $Server -identity $TopPublicFolder -Recurse -resultsize unlimited"
}
else
{
	$getpfcmd = "get-publicfolder -identity $TopPublicFolder -Recurse -resultsize unlimited"
}

invoke-expression $getpfcmd | foreach {
	if ($_.Replicas.Contains($db.Identity)) {
                $_ | format-List
		$_.Replicas -= $db.Identity;
		$_ | set-publicfolder -server $_.OriginatingServer;
	}
}
