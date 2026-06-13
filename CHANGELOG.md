# Changelog

## Unreleased

- Bumped Plumber dependency to 0.0.81.
- Changed CI dependency bootstrap to use Plumber 0.0.81's explicit dependency install flow.

## 0.1.6

- Fixed tag release validation by comparing Plumber.Release versions against
  PSGallery instead of the current release tag.

## 0.1.5

- Added tag-driven release tasks: `TestReleaseReadiness`, `NewReleaseTag`,
  `PushReleaseTag`, and `PublishTaggedRelease`.
- Changed `Release` to create and push the annotated release tag instead of
  publishing directly.
- Changed publishing to run from an existing matching tag in CI.

## 0.1.4

- Changed release publishing to require PSResourceGet from Plumber dependencies.
- Removed Plumber internal task dependencies from the release module manifest.
- Moved Plumber build dependencies to `Plumber.dependencies.psd1`.

## 0.1.3

- Changed build validation to assume `Invoke-Plumber` is the public entry point.
- Removed the default `.` release task registration.

## 0.1.2

- Changed CI validation to use `Invoke-Plumber`.
- Updated Plumber dependency to 0.0.30.

## 0.1.1

- Fixed PSResourceGet repository store initialization before publishing.

## 0.1.0

- Added initial release task loader.
- Added `BuildModule`, `PublishModule`, `PublishGitHubRelease`, and `Release`.
