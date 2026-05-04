$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Get the release tag from package version
$version = '5.7.0'
$releaseTag = "v$version"

# Download URL for Windows binary
$url = "https://github.com/cdavis-code/obs_websocket/releases/download/$releaseTag/obs-cli-windows.zip"

# Package arguments for downloading
$packageArgs = @{
  packageName   = $packageName
  url           = $url
  checksum      = '' # TODO: Update with actual SHA256 checksum
  checksumType  = 'sha256'
  unzipLocation = $toolsDir
}

# Download and extract the binary
Install-ChocolateyZipPackage @packageArgs

# Create shim for the executable
$exePath = Join-Path $toolsDir "obs.exe"
Install-ChocolateyInstallPackage `
  -PackageName $packageName `
  -FileType 'exe' `
  -File $exePath `
  -SilentArgs '/S' `
  -ValidExitCodes @(0)

Write-Host ""
Write-Host "obs-cli has been installed successfully!"
Write-Host "Run 'obs --help' to get started"
Write-Host ""
Write-Host "Before using obs-cli, make sure:"
Write-Host "  1. OBS Studio is installed"
Write-Host "  2. obs-websocket plugin is enabled in OBS"
Write-Host "  3. Configure your connection using environment variables or .env file"
Write-Host ""
