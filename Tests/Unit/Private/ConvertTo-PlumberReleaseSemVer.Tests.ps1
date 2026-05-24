BeforeAll {
    . (Join-Path $PSScriptRoot '../../../Private/ConvertTo-PlumberReleaseSemVer.ps1')
}

Describe 'ConvertTo-PlumberReleaseSemVer' {
    It 'converts semantic versions and v-prefixed tags' {
        (ConvertTo-PlumberReleaseSemVer -VersionName '1.2.3').ToString() |
            Should -Be '1.2.3'
        (ConvertTo-PlumberReleaseSemVer -VersionName 'v1.2.3').ToString() |
            Should -Be '1.2.3'
    }

    It 'returns null for non-semantic tags' {
        ConvertTo-PlumberReleaseSemVer -VersionName 'not-a-version' |
            Should -BeNullOrEmpty
    }
}
