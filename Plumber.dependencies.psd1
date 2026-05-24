@{
    Modules = @(
        @{
            ModuleName    = 'Plumber'
            ModuleVersion = '0.0.41'
            Scope         = 'Core'
        }
        @{
            ModuleName    = 'Microsoft.PowerShell.PSResourceGet'
            ModuleVersion = '1.2.0'
            Scope         = @(
                'PublishModule'
                'PublishTaggedRelease'
            )
        }
    )
}
