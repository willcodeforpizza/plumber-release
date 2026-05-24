. (Get-PlumberTaskLoader) -Config @{
    ModuleManifest = 'Plumber.Release.psd1'
    Tasks          = @{
        ModuleVersion        = @{
            RunWhen = 'OnRelease'
            Source  = 'GitTag'
        }
        ChangelogUpdated     = @{
            RunWhen = 'OnRelease'
        }
        PublicFunctionPrefix = @{
            Prefix = 'PlumberRelease'
        }
    }
}

. (Get-PlumberReleaseTaskLoader) -Config @{
    ModuleManifest = 'Plumber.Release.psd1'
}
