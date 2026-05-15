function Get-PlumberReleaseTaskLoader {
    <#
        .SYNOPSIS
        Gets the Plumber.Release Invoke-Build task loader path.

        .DESCRIPTION
        Returns the task loader script path so build files can dot-source the
        release task set into the active Invoke-Build scope.

        .EXAMPLE
        . (Get-PlumberReleaseTaskLoader) -Config @{
            ModuleManifest = 'MyModule.psd1'
        }
    #>
    [CmdletBinding()]
    param()

    Join-Path $PSScriptRoot '../Tasks/TaskLoader.ps1' |
        Resolve-Path |
            Select-Object -ExpandProperty Path
}
