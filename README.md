# Plumber.Release

Release tasks for Plumber validation pipelines.

Plumber.Release is a small companion to Plumber. Plumber owns local validation
pipelines; Plumber.Release owns the narrow release workflow for modules that
publish to PowerShell Gallery and GitHub Releases.

## Tasks

- `TestReleaseReadiness` checks version, changelog, tag availability, and a
  clean working tree before a release tag is created.
- `NewReleaseTag` creates the annotated `v<ModuleVersion>` tag.
- `PushReleaseTag` pushes the release tag to the configured remote.
- `BuildModule` stages a clean publishable module folder.
- `PublishModule` publishes the staged folder with `Publish-PSResource`.
- `PublishGitHubRelease` creates or updates the GitHub release for the tag.
- `PublishTaggedRelease` publishes from the tag that triggered CI.
- `Release` creates and pushes the release tag.

Pushing the tag is the manual release action. CI publishes from that tag with
`PublishTaggedRelease`.

## Configuration

```powershell
. (Get-PlumberReleaseTaskLoader) -Config @{
    ModuleManifest          = 'MyModule.psd1'
    ModuleBuildIncludeItems = @('assets/*.json')
    ModuleBuildExcludeItems = @('docs')
    ReleaseTargets          = @('GitHub')
}
```

| Key | Default | Description |
| --- | --- | --- |
| `ModuleManifest` | First `*.psd1` under `ModuleRoot` | Manifest used to discover the module name and version. |
| `ModuleRoot` | Current build root | Repository or module root used for relative paths. |
| `ModuleName` | Manifest base name | Module name used for output paths and manifest lookup. |
| `ModuleOutputRoot` | Temp path named for the module | Clean staging folder passed to `Publish-PSResource`. |
| `ModuleBuildIncludeItems` | None | Adds files, folders, or relative globs to the built-in list. |
| `ModuleBuildExcludeItems` | None | Excludes items from the final list using wildcard matching. |
| `ReleaseTargets` | `@('PSGallery', 'GitHub')` | Release destinations. Use `@('GitHub')` to skip PSGallery. |
| `GitRemote` | `origin` | Remote used when checking and pushing release tags. |

The built-in item list is:

```text
Private
Public
Resource
Tasks
docs
LICENSE
README.md
CHANGELOG.md
<ModuleName>.psd1
<ModuleName>.psm1
```

Missing items are skipped.

Run the release pipeline:

```powershell
Invoke-Plumber -Task Release
```

The release workflow should run from pushed tags matching `v*`, set
`PLUMBER_RELEASE_INTENT=true` for validation, then run:

```powershell
Invoke-Plumber -Task PublishTaggedRelease
```

## Repository setup

Add the PowerShell Gallery API key as a repository secret:

```bash
gh secret set PSGALLERY_API_KEY --repo owner/repo
```

The workflow uses GitHub's built-in `GITHUB_TOKEN` for GitHub release creation.
The release job needs `contents: write`.

Protect the `main` branch:

```bash
gh api --method PUT repos/owner/repo/branches/main/protection --input - <<'JSON'
{
  "required_status_checks": {
    "strict": true,
    "contexts": [
      "ubuntu-latest",
      "windows-latest"
    ]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false,
    "required_approving_review_count": 1
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_linear_history": false,
  "required_conversation_resolution": true
}
JSON
```

Do not require the `Release` check in branch protection. It runs only after a
release tag is pushed; pull requests only run the OS validation matrix.
