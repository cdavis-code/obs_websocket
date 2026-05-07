# Package Distribution

This project supports multiple package managers for easy installation.

## Available Package Managers

### macOS/Linux - Homebrew
- **Tap Repository**: https://github.com/cdavis-code/homebrew-obs-cli
- **Formula**: `obs-cli`
- **Install**: `brew tap cdavis-code/obs-cli && brew install obs-cli`
- **Files**: See `homebrew-obs-cli` repository

### Windows - Chocolatey
- **Package**: https://community.chocolatey.org/packages/obs-cli (after approval)
- **Package ID**: `obs-cli`
- **Install**: `choco install obs-cli`
- **Files**: See `chocolatey/` directory

### Dart Pub
- **Package**: https://pub.dev/packages/obs_cli
- **Install**: `dart pub global activate obs_cli`
- **Files**: See `packages/obs_cli/` directory

### npm (JavaScript / TypeScript)
- **Package**: `obs_websocket_js` on npm
- **Install**: `npm install obs_websocket_js`
- **Universal**: works in browsers and Node.js 18+ via dual `exports` entrypoints
- **Files**: See `packages/obs_websocket_js/` directory

### npm - MCP Server (JavaScript)
- **Package**: `@unngh/obs-mcp` on npm
- **Install**: `npx @unngh/obs-mcp` (no install required)
- **Description**: JavaScript-compiled version of the obs_mcp MCP server; controls OBS Studio via obs-websocket v5.x protocol. Runs via npx without requiring Dart runtime.
- **Files**: See `packages/obs_mcp_js/` directory

## Directory Structure

```
obs_websocket/
├── packages/
│   └── obs_cli/              # Main CLI package
│       ├── bin/
│       ├── lib/
│       └── README.md
├── chocolatey/               # Chocolatey package configuration
│   ├── tools/
│   │   ├── chocolateyinstall.ps1
│   │   └── chocolateyuninstall.ps1
│   ├── obs-cli.nuspec
│   ├── README.md
│   └── SETUP.md
└── .github/
    └── workflows/
        ├── chocolatey.yml    # Chocolatey CI/CD
        └── ...               # Other workflows
```

## Publishing Workflow

### Homebrew
1. Update formula in `homebrew-obs-cli` repository
2. Update SHA256 hash
3. Users install via `brew install obs-cli`

### Chocolatey
1. Create GitHub release
2. GitHub Actions automatically:
   - Builds Windows executable
   - Creates ZIP archive
   - Calculates checksums
   - Publishes to Chocolatey
3. Wait for moderation (3-5 days)

### Dart Pub
1. Update version in `pubspec.yaml`
2. Run `dart pub publish`
3. Package available on pub.dev

### npm (obs_websocket_js)
1. Update version in `packages/obs_websocket_js/package.json`
2. Run `npm install && npm run build && npm test` inside the package
3. Run `npm publish --access public`
4. Package available on npmjs.com

### npm (@unngh/obs-mcp)
1. Update version in `packages/obs_mcp_js/package.json`
2. Run `npm install && npm run build && npm test` inside the package
3. Run `npm publish --access public`
4. Package available on npmjs.com as `@unngh/obs-mcp`

## Adding New Package Managers

To add support for a new package manager:
1. Create a dedicated directory (e.g., `scoop/`, `winget/`)
2. Add package configuration files
3. Create GitHub Actions workflow
4. Update this README
5. Update main package README with installation instructions
