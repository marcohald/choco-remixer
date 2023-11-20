
Function Test-PushPackage {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][string]$URL,
        [parameter(Mandatory = $true)][string]$Name
    )
    if ($null -eq $URL) {
        Throw "No $name found"
    }

    Test-URL -url $URL -name $name
    try {
        $apiKeySources = Get-ChocoApiKeysUrlList
        if ($apiKeySources -notcontains $URL) {
            Write-Verbose "Did not find a API key for $name"
        }
    }
    catch {
        Write-Warning "Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
    }

}