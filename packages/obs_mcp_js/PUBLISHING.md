# npm Publishing Setup for @unngh/obs-mcp

## What Was Done

### 1. GitHub Workflow Updated ✅
- **File**: `.github/workflows/dart.yml`
- **Changes**:
  - Added tag trigger: `obs_mcp_js-v*`
  - Added `publish-npm-mcp` job that runs on tag pushes
  - Configured to publish with `--access=public`
  - Uses `NPM_TOKEN` secret for authentication

### 2. Publish Script Created ✅
- **File**: `packages/obs_mcp_js/scripts/publish-npm.sh`
- **Purpose**: Automates version bumping, building, and tagging
- **Usage**: `./scripts/publish-npm.sh [major|minor|patch|version]`

### 3. Package Configuration ✅
- **File**: `packages/obs_mcp_js/package.json`
- **Package name**: `@unngh/obs-mcp`
- **Entry point**: `bin/obs-mcp-server.js` (loads `dist/obs_mcp_server.runtime.js`)
- **Build**: Dart compiled to JavaScript via `dart compile js` (not TypeScript)
- **Repository**: Links to GitHub for automatic README display
- **Files array**: Includes `README.md`, `LICENSE`, `bin/`, `dist/`

## Package Metadata for npm

The `package.json` includes these important fields for npm:

```json
{
  "repository": {
    "type": "git",
    "url": "git+https://github.com/cdavis-code/obs_websocket_workspace.git",
    "directory": "packages/obs_mcp_js"
  },
  "homepage": "https://github.com/cdavis-code/obs_websocket_workspace/tree/main/packages/obs_mcp_js#readme",
  "files": [
    "bin/",
    "dist/",
    "README.md",
    "LICENSE"
  ]
}
```

- **repository**: Points to the monorepo root with the package subdirectory
- **homepage**: Direct link to the README on GitHub
- **files**: Ensures README.md and LICENSE are included in the published package

npm will automatically fetch the README from GitHub if it's missing from the tarball, using the repository URL.

## Architecture

This package is **not** a TypeScript project. It is compiled from Dart source to JavaScript using `dart compile js`:

```
lib/obs_mcp_js.dart  →  dart compile js -O4  →  build/dart/obs_mcp_server.js  →  dist/obs_mcp_server.runtime.js
```

The entry point `bin/obs-mcp-server.js` is a hand-written Node.js wrapper that:
- Sets up keepalive, signal handling, and error handling
- Polyfills `WebSocket` via the `ws` package (for Node < 22)
- Loads the dart2js compiled runtime from `dist/obs_mcp_server.runtime.js`

## Next Steps Required

### Set Up NPM_TOKEN Secret

1. **Generate an npm access token** via the npm website:
   - Go to: https://www.npmjs.com/settings/~/tokens
   - Click **"Generate New Token"** → select **"Classic Token"**
   - Choose type: **Automation** (recommended for CI/CD — bypasses 2FA requirements)
   - Give it a descriptive name like `GitHub Actions - obs_mcp_js`
   - Click **"Generate Token"**
   - Copy the token immediately (it won't be shown again)

   Alternatively, from the CLI (requires the `--name` flag):
   ```bash
   npm token create --name="GitHub Actions - obs_mcp_js"
   ```

2. **Add the token to GitHub repository secrets**:
   - Go to: https://github.com/cdavis-code/obs_websocket_workspace/settings/secrets/actions
   - Click **"New repository secret"**
   - Name: `NPM_TOKEN`
   - Value: Paste the token you copied
   - Click **"Add secret"**

## How to Publish Future Versions

### Option 1: Using the Script (Recommended)

```bash
cd packages/obs_mcp_js

# For bug fixes
./scripts/publish-npm.sh patch

# For new features
./scripts/publish-npm.sh minor

# For breaking changes
./scripts/publish-npm.sh major

# Then push to trigger GitHub Action
git push origin main --tags
```

### Option 2: Manual Process

```bash
cd packages/obs_mcp_js

# 1. Update version in package.json
# 2. Build (compiles Dart to JS)
npm run build

# 3. Verify dist/obs_mcp_server.runtime.js exists
ls dist/obs_mcp_server.runtime.js

# 4. Commit and tag
git add .
git commit -m "chore(obs_mcp_js): release v5.7.2"
git tag -a obs_mcp_js-v5.7.2 -m "Release obs_mcp_js v5.7.2"

# 5. Push to trigger
git push origin main --tags
```

## Pre-Publish Checklist

Before publishing, verify these files exist and are correct:

- [ ] `dist/obs_mcp_server.runtime.js` — compiled dart2js output
- [ ] `README.md` — package documentation (MUST exist at package root)
- [ ] `CHANGELOG.md` — version history
- [ ] `LICENSE` — MIT license file
- [ ] `package.json` — version is bumped correctly
- [ ] `package.json` — `repository` field points to GitHub
- [ ] `package.json` — `files` array includes `README.md`

### Verifying README Will Be Included

Before publishing, run this to see what files will be packaged:

```bash
npm pack --dry-run
```

You should see `README.md` in the file list. If not, check:
1. README.md exists at the package root (not in a subdirectory)
2. `files` array in package.json includes `"README.md"`
3. No `.npmignore` file is excluding it

## Workflow Behavior

When you push a tag like `obs_mcp_js-v5.7.2`:

1. **Trigger**: GitHub Actions detects the tag
2. **Build Job**:
   - Sets up Dart SDK and Node.js
   - Runs `dart pub get`
   - Runs `npm run build` (executes `dart compile js -O4`)
   - Verifies `dist/obs_mcp_server.runtime.js` is produced
3. **Publish Job** (only if build succeeds):
   - Runs `npm publish --access=public`
   - Package appears on npm registry

## Verification

After publishing, verify:
- ✅ npm: https://www.npmjs.com/package/@unngh/obs-mcp
- ✅ GitHub Actions: https://github.com/cdavis-code/obs_websocket_workspace/actions
- ✅ Install test: `npx @unngh/obs-mcp --help`

## Troubleshooting

### Build fails with "dart: command not found"
- Ensure the Dart SDK is installed and on PATH
- The CI workflow must set up Dart before building

### Workflow doesn't trigger
- Check tag format: must be `obs_mcp_js-vX.Y.Z`
- Verify workflow file is on the `main` branch

### Publish fails with authentication error
- Verify `NPM_TOKEN` secret is set in GitHub
- Check token hasn't expired
- Ensure token has publish permissions

### Publish fails with version already exists
- Bump the version number
- npm doesn't allow overwriting published versions

### Runtime error: Cannot find module '../dist/obs_mcp_server.runtime.js'
- The build step failed or was skipped
- Run `npm run build` and verify `dist/obs_mcp_server.runtime.js` exists

### npm shows "This package does not have a README"
This can happen even when README.md is correctly configured. To fix:

1. **Verify README is in the published package**:
   ```bash
   # Download the published package
   npm pack @unngh/obs-mcp
   
   # Extract and check
   tar -tzf unngh-obs-mcp-*.tgz | grep README
   ```
   
2. **Check package.json has repository field**:
   - npm uses the `repository` field to fetch README from GitHub as fallback
   - Ensure `repository.url` points to the correct GitHub repo
   - Ensure `repository.directory` specifies the package subdirectory
   
3. **Bump version and republish**:
   - npm doesn't update README for existing versions
   - You must publish a new version (e.g., 5.7.1 → 5.7.2)
   - Use: `./scripts/publish-npm.sh patch`
   
4. **Verify after republishing**:
   - Check npm page: https://www.npmjs.com/package/@unngh/obs-mcp
   - README should appear within a few minutes
   - If still missing, npm will use GitHub README via repository URL
