BeforeAll {
    . (Join-Path $PSScriptRoot '../../../Private/Resolve-PlumberReleaseConfig.ps1')
}

Describe 'Resolve-PlumberReleaseConfig' {
    BeforeEach {
        $moduleRoot = Join-Path $TestDrive 'Module'
        New-Item -Path $moduleRoot -ItemType Directory -Force | Out-Null
        Set-Content -Path (Join-Path $moduleRoot 'Example.psd1') -Value @"
@{
    RootModule = 'Example.psm1'
    ModuleVersion = '1.2.3'
    GUID = '11111111-1111-1111-1111-111111111111'
    FunctionsToExport = @()
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
}
"@
    }

    It 'resolves defaults from the module manifest' {
        $config = Resolve-PlumberReleaseConfig -BuildRoot $moduleRoot -Config @{
            ModuleManifest = 'Example.psd1'
        }

        $config.ModuleRoot | Should -Be $moduleRoot
        $config.ModuleName | Should -Be 'Example'
        $config.Repository | Should -Be 'PSGallery'
        $config.GitRemote | Should -Be 'origin'
        $config.ModuleBuildItems | Should -Contain 'Example.psd1'
        $config.ModuleBuildItems | Should -Contain 'Example.psm1'
    }

    It 'adds extra build items to the default item list' {
        $config = Resolve-PlumberReleaseConfig -BuildRoot $moduleRoot -Config @{
            ModuleManifest        = 'Example.psd1'
            ModuleBuildExtraItems = @('docs')
        }

        $config.ModuleBuildItems | Should -Contain 'docs'
    }

    It 'allows callers to replace the build item list' {
        $config = Resolve-PlumberReleaseConfig -BuildRoot $moduleRoot -Config @{
            ModuleManifest   = 'Example.psd1'
            ModuleBuildItems = @('OnlyThis')
        }

        $config.ModuleBuildItems | Should -Be @('OnlyThis')
    }
}
