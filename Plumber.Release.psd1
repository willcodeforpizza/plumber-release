@{
    RootModule           = 'Plumber.Release.psm1'
    ModuleVersion        = '0.1.4'
    GUID                 = '961fe657-aa71-4342-9fa0-008bb5275313'
    Author               = 'willcodeforpizza'
    CompanyName          = 'willcodeforpizza'
    Copyright            = '(c) willcodeforpizza. All rights reserved.'
    Description          = 'Invoke-Build release tasks for PowerShell modules.'
    PowerShellVersion    = '7.0'
    FunctionsToExport    = @(
        'Get-PlumberReleaseTaskLoader'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
    PrivateData          = @{
        PSData = @{
            Tags         = @('InvokeBuild', 'Release', 'PowerShell')
            ProjectUri   = 'https://github.com/willcodeforpizza/plumber-release'
            LicenseUri   = 'https://github.com/willcodeforpizza/plumber-release/blob/main/LICENSE'
            ReleaseNotes = 'https://github.com/willcodeforpizza/plumber-release/blob/main/CHANGELOG.md'

        }
    }
}
