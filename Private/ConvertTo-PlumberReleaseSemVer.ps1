function ConvertTo-PlumberReleaseSemVer {
    <#
        .SYNOPSIS
        Converts a version or tag name to a semantic version.
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.SemanticVersion])]
    param (
        [Parameter(Mandatory)]
        [string]
        $VersionName
    )

    $candidate = $VersionName.Trim()
    if ($candidate.StartsWith('v', [System.StringComparison]::OrdinalIgnoreCase)) {
        $candidate = $candidate.Substring(1)
    }

    $version = $null
    if ([System.Management.Automation.SemanticVersion]::TryParse($candidate, [ref]$version)) {
        $version
    }
}
