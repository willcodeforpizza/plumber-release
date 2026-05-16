function Import-PlumberReleasePSResourceGet {
    <#
        .SYNOPSIS
        Imports PSResourceGet for module publishing.
    #>
    [CmdletBinding()]
    param()

    $moduleName = 'Microsoft.PowerShell.PSResourceGet'
    $moduleVersion = '1.2.0'

    if (Get-Command Publish-PSResource -ErrorAction SilentlyContinue) {
        return
    }

    try {
        Import-Module -Name $moduleName -MinimumVersion $moduleVersion -ErrorAction Stop
        if (Get-Command Publish-PSResource -ErrorAction SilentlyContinue) {
            return
        }
    }
    catch {
        $importError = $PSItem
    }

    throw (
        "PublishModule requires $moduleName v$moduleVersion. " +
        "Install Plumber.Release dependencies with 'Install-PlumberDependency'. " +
        "Error: $importError"
    )
}
