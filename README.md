# Plumber.Release

Invoke-Build release tasks for PowerShell modules.

Plumber.Release is a small companion to Plumber. Plumber owns local validation
pipelines; Plumber.Release owns the narrow release workflow for modules that
publish to PowerShell Gallery and GitHub Releases.

## Tasks

- `BuildModule` stages a clean publishable module folder.
- `PublishModule` publishes the staged folder with `Publish-PSResource`.
- `PublishGitHubRelease` creates the version tag and GitHub release.
- `Release` runs the full workflow.

Publishing is dry-run by default. Set `PSGALLERY_PUBLISH_CONFIRM=true` and
`GITHUB_RELEASE_CONFIRM=true` to publish for real.

## Configuration

```powershell
Import-Module Plumber.Release

. (Get-PlumberReleaseTaskLoader) -Config @{
    ModuleManifest         = 'MyModule.psd1'
    ModuleBuildAddItems    = @('assets/*.json')
    ModuleBuildRemoveItems = @('docs')
}
```

Run the release pipeline:

```powershell
Invoke-Build -File ./Release.build.ps1 Release
```
