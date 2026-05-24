BeforeAll {
    . (Join-Path $PSScriptRoot '../../../Private/Get-PlumberReleaseNote.ps1')
}

Describe 'Get-PlumberReleaseNote' {
    BeforeEach {
        $moduleRoot = Join-Path $TestDrive 'Module'
        New-Item -Path $moduleRoot -ItemType Directory -Force | Out-Null
        Set-Content -Path (Join-Path $moduleRoot 'CHANGELOG.md') -Value @'
# Changelog

## 1.2.3

- Added release task.
- Fixed publish flow.

## 1.2.2

- Previous release.
'@
        $script:config = [pscustomobject]@{
            ModuleRoot = $moduleRoot
            ModuleName = 'Example'
        }
    }

    It 'writes notes from the matching changelog section' {
        $notesPath = Get-PlumberReleaseNote -Config $script:config -Version '1.2.3'

        Get-Content $notesPath | Should -Be @(
            '- Added release task.'
            '- Fixed publish flow.'
        )
    }

    It 'throws when the changelog section is missing' {
        { Get-PlumberReleaseNote -Config $script:config -Version '9.9.9' } |
            Should -Throw "No changelog section found for version 9.9.9."
    }
}
