# Chocolatey Setup Guide

This guide will help you set up Chocolatey package publishing for obs-cli.

## Prerequisites

1. **Windows Machine** - You need access to a Windows machine for testing
2. **Chocolatey Account** - Create an account at https://chocolatey.org
3. **File Organization** - All Chocolatey files are in the `chocolatey/` directory

## Step 1: Get Your Chocolatey API Key

1. Go to https://chocolatey.org/account
2. Log in to your account
3. Click on "API Keys" in the left sidebar
4. Copy your API key (it looks like a long alphanumeric string)

## Step 2: Add GitHub Secret

Add your Chocolatey API key as a GitHub repository secret:

1. Go to your repository: https://github.com/cdavis-code/obs_websocket_workspace
2. Click on **Settings** tab
3. Click on **Secrets and variables** → **Actions** in the left sidebar
4. Click **New repository secret**
5. Set the following:
   - **Name**: `CHOCO_API_KEY`
   - **Secret**: Paste your Chocolatey API key
6. Click **Add secret**

## Step 3: Test Locally (Optional but Recommended)

On a Windows machine:

```powershell
# Install Chocolatey (if not already installed)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Test the package
cd obs_websocket/chocolatey
choco pack obs-cli.nuspec
choco install obs-cli -s . -y

# Verify installation
obs --help

# Uninstall when done testing
choco uninstall obs-cli -y
```

## Step 4: Create a GitHub Release

The workflow will automatically publish when you create a release:

### Option A: Using GitHub CLI

```bash
# Create and push a tag
git tag v5.7.0
git push origin v5.7.0

# Create a release
gh release create v5.7.0 \
  --title "Release v5.7.0" \
  --notes "See CHANGELOG.md for details"
```

### Option B: Using GitHub Web Interface

1. Go to https://github.com/cdavis-code/obs_websocket_workspace/releases
2. Click **Draft a new release**
3. Click **Choose a tag** and enter `v5.7.0`
4. Click **Create new tag: v5.7.0 on publish**
5. Enter release title: `Release v5.7.0`
6. Add release notes
7. Click **Publish release**

## Step 5: Monitor the Workflow

1. Go to the **Actions** tab in your GitHub repository
2. Click on the "Publish Chocolatey Package" workflow
3. Monitor the progress
4. The workflow will:
   - Build the Windows executable
   - Create a ZIP archive
   - Upload it to the GitHub Release
   - Pack the Chocolatey package
   - Push it to Chocolatey Community Repository

## Step 6: Wait for Moderation

Chocolatey has a moderation process:
- **Review Time**: Typically 3-5 business days
- **Status**: Check at https://community.chocolatey.org/packages/obs-cli
- **Notifications**: You'll receive an email when approved

## Manual Publish (If Needed)

If you need to publish manually:

```powershell
# On Windows machine
cd chocolatey
choco pack obs-cli.nuspec
choco apikey --key "your-api-key" --source https://push.chocolatey.org/
choco push obs-cli.5.7.0.nupkg --source https://push.chocolatey.org/ --timeout 1800
```

## Workflow Triggers

The workflow can be triggered in two ways:

### 1. Automatic (on release)
- Triggered when you create a GitHub release
- Automatically publishes to Chocolatey

### 2. Manual (workflow_dispatch)
- Go to Actions → Publish Chocolatey Package
- Click "Run workflow"
- Enter version number (e.g., 5.7.0)
- Click "Run workflow"
- This will build but NOT publish (for testing)

## Files Created

All Chocolatey-related files are organized in the `chocolatey/` directory:

```
chocolatey/
├── obs-cli.nuspec                 # Package metadata
├── README.md                      # Package documentation
├── SETUP.md                       # This setup guide
├── .gitignore                     # Build artifact exclusions
└── tools/
    ├── chocolateyinstall.ps1      # Installation script
    └── chocolateyuninstall.ps1    # Uninstallation script
```

Additional files:
- `.github/workflows/chocolatey.yml` - CI/CD workflow (updated with new paths)
- `PACKAGES.md` - Overview of all package distribution channels
- `packages/obs_cli/README.md` - Updated with Chocolatey installation instructions

## Troubleshooting

### Package Rejected by Moderation
- Review the rejection email
- Fix the issues mentioned
- Update the package and push again

### Build Fails
- Check the Actions logs
- Ensure Dart SDK is properly configured
- Verify all dependencies are available

### Checksum Mismatch
- The workflow automatically calculates checksums
- If manual, use: `Get-FileHash obs-cli-windows.zip -Algorithm SHA256`

## Next Steps

After your package is approved:

1. Users can install with: `choco install obs-cli`
2. Add installation badge to README
3. Announce on Chocolatey community forums
4. Update documentation to reference Chocolatey installation

## Support

- Chocolatey Docs: https://docs.chocolatey.org
- Package Guidelines: https://docs.chocolatey.org/en-us/create/create-packages
- Community: https://chocolatey.org/community
