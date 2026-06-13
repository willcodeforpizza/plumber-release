. (Get-PlumberTaskLoader) -Config @{
    ModuleManifest = 'Plumber.Release.psd1'
    Tasks          = @{
        PublicFunctionPrefix = @{
            Prefix = 'PlumberRelease'
        }
        ModuleVersion        = @{
            RunWhen = 'OnRelease'
        }
        ChangelogUpdated     = @{
            RunWhen = 'OnRelease'
        }
    }
}

. (Get-PlumberReleaseTaskLoader) -Config @{
    ModuleManifest = 'Plumber.Release.psd1'
}
