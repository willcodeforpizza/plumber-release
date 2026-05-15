foreach ($scope in 'Private', 'Public') {
    $root = Join-Path $PSScriptRoot $scope
    if (-not (Test-Path $root)) {
        continue
    }

    foreach ($script in Get-ChildItem -Path $root -Filter '*.ps1' -File) {
        . $script.FullName
    }
}

Export-ModuleMember -Function @(
    'Get-PlumberReleaseTaskLoader'
)
