function Get-PlumberReleaseNote {
    <#
        .SYNOPSIS
        Writes release notes for the configured module version.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [psobject]
        $Config,

        [Parameter(Mandatory)]
        [string]
        $Version
    )

    $changelogPath = Join-Path $Config.ModuleRoot 'CHANGELOG.md'
    if (-not (Test-Path $changelogPath)) {
        throw 'CHANGELOG.md is missing.'
    }

    $changelog = Get-Content $changelogPath
    $sectionStart = [array]::IndexOf($changelog, "## $Version")
    if ($sectionStart -lt 0) {
        throw "No changelog section found for version $Version."
    }

    $sectionEnd = $changelog.Count
    for ($i = $sectionStart + 1; $i -lt $changelog.Count; $i++) {
        if ($changelog[$i] -match '^## \d') {
            $sectionEnd = $i
            break
        }
    }

    $releaseNotes = @($changelog[($sectionStart + 1)..($sectionEnd - 1)]).Trim() |
        Where-Object { $_ }
    if (-not $releaseNotes) {
        $releaseNotes = @("Release v$Version")
    }

    $releaseNotesPath = Join-Path ([System.IO.Path]::GetTempPath()) "$($Config.ModuleName)-release-notes.md"
    Set-Content -Path $releaseNotesPath -Value $releaseNotes
    $releaseNotesPath
}
