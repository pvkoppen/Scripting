function Load-ScriptVariables ( [string]$Path ) {
    if (-not $Path) {
        if ($script:MyInvocation.MyCommand.Path) {
            $Path = Join-Path -Path (Split-Path $script:MyInvocation.MyCommand.Path) -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension((Split-Path $script:MyInvocation.MyCommand.Path)))
        } else {
            $Path = Join-Path $env:TEMP $env:USERNAME
        }
        $Path += ".settings"
    }
    if (Test-Path $Path) {
        [hashtable]$results = Get-Content -raw -Path $Path | ConvertFrom-Json
        foreach ($result in $results) {
            $
    } else {
        @{}
    }
} #function Get-ScriptVariables
function Get-ScriptVariable ( $ScriptVariable, $Key, $Value ) {
    if ($ScriptVariable) { $ScriptVariable[$Key] }
} #function Get-ScriptVariable
function Remove-ScriptVariable ( $ScriptVariable, $Key ) {
    $ScriptVariable.Remove($Key)
} #function Remove-ScriptVariable
function Set-ScriptVariable ( $ScriptVariable, $Key, $Value ) {
    Remove-ScriptVariable -ScriptVariable $ScriptVariable -Key $Key
    $ScriptVariable.Add($Key, $Value)
} #function Set-ScriptVariable
function Save-ScriptVariables ( [string]$Path, $ScriptVariable ) {
    if (-not $Path) {
        if ($script:MyInvocation.MyCommand.Path) {
            $Path = Join-Path -Path (Split-Path -Path ($script:MyInvocation.MyCommand.Path) -Parent ) -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension((Split-Path -Path $script:MyInvocation.MyCommand.Path)))
        } else {
            $Path = Join-Path -Path $env:TEMP -ChildPath $env:USERNAME
        }
        $Path += ".settings"
    }
        if ($ScriptVariable) {
        $Export = foreach ($Variable in $($ScriptVariable.Keys)) {
            "$($Variable)=$($ScriptVariable[$Variable])"
        }
    }
    $Export | ConvertTo-Json | Set-Content -Path $Path
} #function Save-ScriptVariables

