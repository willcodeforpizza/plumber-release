# Changelog

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
