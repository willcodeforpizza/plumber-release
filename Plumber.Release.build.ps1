. (Get-PlumberTaskLoader) -Config @{
    ModuleManifest = 'Plumber.Release.psd1'
    Tasks          = @{
        PublicFunctionPrefix = @{
            Prefix = 'PlumberRelease'
        }
    }
}

. (Get-PlumberReleaseTaskLoader) -Config @{
    ModuleManifest = 'Plumber.Release.psd1'
}
