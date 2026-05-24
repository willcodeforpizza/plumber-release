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
