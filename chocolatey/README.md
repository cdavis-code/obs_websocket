# Chocolatey Package for obs-cli

This directory contains the Chocolatey package configuration for obs-cli.

## Directory Structure

```
chocolatey/
├── obs-cli.nuspec                 # Package metadata
├── README.md                      # This file
├── SETUP.md                       # Setup and publishing guide
└── tools/
    ├── chocolateyinstall.ps1      # Installation script
    └── chocolateyuninstall.ps1    # Uninstallation script
```

## Building Locally

On a Windows machine with Chocolatey installed:

```powershell
# Navigate to chocolatey directory
cd chocolatey

# Pack the package
choco pack obs-cli.nuspec

# Test locally
choco install obs-cli -s . -y

# Uninstall
choco uninstall obs-cli -y
```

## Publishing

The package is automatically published to the Chocolatey Community Repository when a new GitHub release is created.

### Manual Publish

```powershell
# Set API key (one time)
choco apikey --key "your-api-key" --source https://push.chocolatey.org/

# Push package
choco push obs-cli.5.7.0.nupkg --source https://push.chocolatey.org/
```

## GitHub Actions

The workflow `.github/workflows/chocolatey.yml` handles:
1. Building the Windows executable from Dart source
2. Creating a ZIP archive
3. Calculating SHA256 checksums
4. Uploading binary to GitHub Release
5. Packing the Chocolatey package
6. Publishing to Chocolatey Community Repository

### Required Secrets

Add the following secret to your GitHub repository:
- `CHOCO_API_KEY` - Your Chocolatey API key from https://chocolatey.org/account

## Version Updates

When releasing a new version:

1. Update version in `pubspec.yaml`
2. Create a git tag: `git tag v5.8.0`
3. Push tag: `git push origin v5.8.0`
4. Create a GitHub Release from the tag
5. GitHub Actions will automatically build and publish

## Links

- Package page: https://community.chocolatey.org/packages/obs-cli
- Repository: https://github.com/cdavis-code/obs_websocket
- Documentation: https://pub.dev/documentation/obs_cli/latest/
