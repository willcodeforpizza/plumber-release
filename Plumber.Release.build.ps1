$module = Get-Module Plumber |
    Where-Object { $_.ModuleBase -eq (Resolve-Path (Join-Path $PSScriptRoot '../plumber')).Path } |
        Select-Object -First 1
if (-not $module) {
    $plumberManifest = Join-Path $PSScriptRoot '../plumber/Plumber.psd1'
    $modulePath = if (Test-Path $plumberManifest) {$plumberManifest} else {'Plumber'}
    $module = Import-Module $modulePath -Force -PassThru
}

Import-Module (Join-Path $PSScriptRoot 'Plumber.Release.psd1') -Force

. (Get-PlumberTaskLoader) -Config @{
    ModuleManifest       = 'Plumber.Release.psd1'
    PublicFunctionPrefix = 'PlumberRelease'
    VersionSource        = 'GitTag'
}

. (Get-PlumberReleaseTaskLoader) -Config @{
    ModuleManifest = 'Plumber.Release.psd1'
}
