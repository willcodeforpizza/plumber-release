BeforeAll {
    . (Join-Path $PSScriptRoot '../../../Private/Import-PlumberReleasePSResourceGet.ps1')
}

Describe 'Import-PlumberReleasePSResourceGet' {
    AfterEach {
        Remove-Item Function:\Publish-PSResource -ErrorAction SilentlyContinue
    }

    It 'returns when Publish-PSResource is already available' {
        function Publish-PSResource {}
        Mock Import-Module {}

        Import-PlumberReleasePSResourceGet

        Should -Invoke Import-Module -Times 0 -Exactly
    }

    It 'imports PSResourceGet when Publish-PSResource is missing' {
        Mock Get-Command {
            if (Get-Item Function:\Publish-PSResource -ErrorAction SilentlyContinue) {
                [pscustomobject]@{ Name = 'Publish-PSResource' }
            }
        } -ParameterFilter {
            $Name -eq 'Publish-PSResource'
        }
        Mock Import-Module {
            function global:Publish-PSResource {}
        }

        Import-PlumberReleasePSResourceGet

        Should -Invoke Import-Module -Times 1 -Exactly -ParameterFilter {
            $Name -eq 'Microsoft.PowerShell.PSResourceGet' -and
            $MinimumVersion -eq '1.2.0'
        }
    }

    It 'throws clearly when PSResourceGet cannot be imported' {
        Mock Import-Module {
            throw 'PSResourceGet missing'
        }
        Mock Get-Command {
            $null
        } -ParameterFilter {
            $Name -eq 'Publish-PSResource'
        }

        { Import-PlumberReleasePSResourceGet } |
            Should -Throw -ExpectedMessage 'PublishModule requires Microsoft.PowerShell.PSResourceGet v1.2.0*'
    }
}
