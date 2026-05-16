@{
    RootModule           = 'Plumber.Release.psm1'
    ModuleVersion        = '0.1.1'
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
    ModuleList           = @(
        @{
            ModuleName    = 'Plumber'
            ModuleVersion = '0.0.30'
        }
        @{
            ModuleName    = 'InvokeBuild'
            ModuleVersion = '5.14.23'
        }
        @{
            ModuleName    = 'Pester'
            ModuleVersion = '5.7.1'
        }
        @{
            ModuleName    = 'PSScriptAnalyzer'
            ModuleVersion = '1.25.0'
        }
        @{
            ModuleName    = 'powershell-yaml'
            ModuleVersion = '0.4.12'
        }
        @{
            ModuleName    = 'Microsoft.PowerShell.PSResourceGet'
            ModuleVersion = '1.2.0'
        }
    )
    PrivateData          = @{
        PSData = @{
            Tags         = @('InvokeBuild', 'Release', 'PowerShell')
            ProjectUri   = 'https://github.com/willcodeforpizza/plumber-release'
            LicenseUri   = 'https://github.com/willcodeforpizza/plumber-release/blob/main/LICENSE'
            ReleaseNotes = 'https://github.com/willcodeforpizza/plumber-release/blob/main/CHANGELOG.md'

        }
    }
}
