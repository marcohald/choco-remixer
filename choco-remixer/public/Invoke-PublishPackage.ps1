#Requires -Version 5.0
Function Invoke-PublishPackage {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'String needs to be in plain text when used for header')]
    param (
        [string]$configXML,
        [string]$internalizedXML,
        [string]$repoCheckXML,
        [string]$folderXML,
        [string]$privateRepoCreds,
        [string]$proxyRepoCreds,
        [switch]$thoroughList,
        [switch]$skipRepoCheck,
        [switch]$skipRepoMove,
        [switch]$noSave,
        [switch]$writeVersion,
        [switch]$noPack,
        [string]$package
    )
    $ErrorActionPreference = 'Stop'


    # Import package specific functions
    Get-ChildItem -Path (Join-Path (Split-Path -Parent $PSScriptRoot) 'pkgs') -Filter "*.ps1" | ForEach-Object {
        . $_.fullname
    }

    Try {
        $test = $PSBoundParameters
        . Get-RemixerConfig -upperFunctionBoundParameters $PSBoundParameters
    } Catch {
        Write-Error "Error details:`n$($PSItem.ToString())`n$($PSItem.InvocationInfo.Line)`n$($PSItem.ScriptStackTrace)"
    }


    if ($config.pushPkgs -eq "yes") {
        Write-Output "pushing $($obj.nuspecID)"
        $pushArgs = 'push -f -r -s ' + $config.pushURL
        if($config.pushKey -ne ""){
            $pushArgs = $pushArgs + ' --api-key ' + $config.pushKey
        }
        $pushArgs = $pushArgs + ' ' + $package
        #if()
        $startProcessArgs = @{
            FilePath         = "choco"
            # FilePath         = "echo"
            ArgumentList     = $pushArgs
            NoNewWindow      = $true
            Wait             = $true
            PassThru         = $true
        }

        $pushcode = Start-Process @startProcessArgs
    }
    if (($config.pushPkgs -eq "yes") -and ($pushcode.exitcode -ne "0")) {
        Throw "push failed"
    } 
}