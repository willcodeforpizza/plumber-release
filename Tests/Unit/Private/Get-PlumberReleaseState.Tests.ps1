BeforeAll {
    . (Join-Path $PSScriptRoot '../../../Private/ConvertTo-PlumberReleaseSemVer.ps1')
    . (Join-Path $PSScriptRoot '../../../Private/Get-PlumberReleaseState.ps1')
}

Describe 'Get-PlumberReleaseState' {
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
        Set-Content -Path (Join-Path $moduleRoot 'Example.psm1') -Value ''
        $script:config = [pscustomobject]@{
            ModuleRoot     = $moduleRoot
            ModuleManifest = Join-Path $moduleRoot 'Example.psd1'
            GitRemote      = 'origin'
        }
    }

    It 'gets manifest version and matching release tag' {
        Mock git {
            switch -Regex ($args -join ' ') {
                'tag --list v1\.2\.3' { return @() }
                'ls-remote --tags origin refs/tags/v1\.2\.3' { return @() }
                'describe --tags --exact-match' { return 'v1.2.3' }
                'tag --list$' { return @('v1.2.2') }
                'ls-remote --tags origin$' {
                    return '1111111111111111111111111111111111111111 refs/tags/v1.2.1'
                }
            }
        }

        $state = Get-PlumberReleaseState -Config $script:config

        $state.Version | Should -Be '1.2.3'
        $state.TagName | Should -Be 'v1.2.3'
        $state.CurrentTag | Should -Be 'v1.2.3'
        $state.LatestTagVersion.ToString() | Should -Be '1.2.2'
        $state.ExistingLocalTag | Should -BeFalse
        $state.ExistingRemoteTag | Should -BeFalse
    }
}
