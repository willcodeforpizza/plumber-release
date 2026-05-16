$manifest = Import-PowerShellDataFile (Join-Path $PSScriptRoot 'Plumber.Release.psd1')
$plumberDependency = $manifest.ModuleList |
    Where-Object { $PSItem.ModuleName -eq 'Plumber' } |
        Select-Object -First 1
Import-Module Plumber -RequiredVersion $plumberDependency.ModuleVersion

Import-Module (Join-Path $PSScriptRoot 'Plumber.Release.psd1') -Force

. (Get-PlumberTaskLoader) -Config @{
    ModuleManifest = 'Plumber.Release.psd1'
    Tasks          = @{
        ModuleVersion        = @{
            Source = 'GitTag'
        }
        PublicFunctionPrefix = @{
            Prefix = 'PlumberRelease'
        }
    }
}

. (Get-PlumberReleaseTaskLoader) -Config @{
    ModuleManifest = 'Plumber.Release.psd1'
}
