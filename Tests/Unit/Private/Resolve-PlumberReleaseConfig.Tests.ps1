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
        $config.GitRemote | Should -Be 'origin'
        $config.ReleaseTargets | Should -Be @('PSGallery', 'GitHub')
        $config.ModuleBuildItems | Should -Contain 'Example.psd1'
        $config.ModuleBuildItems | Should -Contain 'Example.psm1'
        $config.ModuleBuildItems | Should -Contain 'Tasks'
        $config.ModuleBuildItems | Should -Contain 'docs'
    }

    It 'includes build item globs in the default item list' {
        $config = Resolve-PlumberReleaseConfig -BuildRoot $moduleRoot -Config @{
            ModuleManifest          = 'Example.psd1'
            ModuleBuildIncludeItems = @('assets/*.json')
        }

        $config.ModuleBuildItems | Should -Contain 'assets/*.json'
    }

    It 'does not add empty build items when optional config is omitted' {
        $config = Resolve-PlumberReleaseConfig -BuildRoot $moduleRoot -Config @{
            ModuleManifest = 'Example.psd1'
        }

        $config.ModuleBuildItems | Should -Not -Contain ''
        $config.ModuleBuildItems | Should -Not -Contain $null
    }

    It 'excludes build item globs from the item list' {
        $config = Resolve-PlumberReleaseConfig -BuildRoot $moduleRoot -Config @{
            ModuleManifest          = 'Example.psd1'
            ModuleBuildExcludeItems = @('docs', 'Resource*')
        }

        $config.ModuleBuildItems | Should -Not -Contain 'docs'
        $config.ModuleBuildItems | Should -Not -Contain 'Resource'
        $config.ModuleBuildItems | Should -Contain 'Tasks'
    }

    It 'allows callers to choose release targets' {
        $config = Resolve-PlumberReleaseConfig -BuildRoot $moduleRoot -Config @{
            ModuleManifest = 'Example.psd1'
            ReleaseTargets = @('GitHub')
        }

        $config.ReleaseTargets | Should -Be @('GitHub')
    }

    It 'rejects unsupported release targets' {
        {
            Resolve-PlumberReleaseConfig -BuildRoot $moduleRoot -Config @{
                ModuleManifest = 'Example.psd1'
                ReleaseTargets = @('NuGet')
            }
        } | Should -Throw "Unsupported release target 'NuGet'*"
    }
}
