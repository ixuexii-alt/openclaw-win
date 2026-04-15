# Windows Porting Technical Notes

## Changes Made

### 1. `app/electron-builder.yml`
- Added `win:` section with NSIS and portable targets (x64 + arm64)
- Added `linux:` section with AppImage and deb targets
- Added `nsis:` configuration for Windows installer behavior
- Changed `productName` to `OpenClaw-Win`
- Added `artifactName` template for consistent naming

### 2. `app/electron/main/index.ts`
- **Window chrome**: Changed `titleBarStyle` from hardcoded `'hiddenInset'` to platform-conditional
  - macOS: `'hiddenInset'` with traffic light positioning
  - Windows/Linux: `'default'` with native frame
- **Shell detection**: Added Windows startup block that:
  1. Checks common Git Bash installation paths
  2. Sets `SHELL` environment variable to Git Bash if found
  3. Falls back to `powershell.exe` if Git Bash not available
  4. Sets `GIT_DISCOVERY_ACROSS_FILESYSTEM=1` for Windows long path support
- **Branding**: Updated window title to `OpenClaw-Win`

### 3. `app/package.json`
- Renamed to `openclaw-win`
- Updated description for cross-platform
- Added build scripts:
  - `package:win` — Windows build
  - `package:linux` — Linux build
  - `package:all` — All platforms

### 4. `app/scripts/patch-open-agent-sdk.mjs`
- **Patch 99**: Expands `SUPPORTED_PLATFORMS` array to include `'windows'` and `'linux'`
  - Scans `dist/utils/platform.js` and `.mjs` variants
  - Uses regex to find and extend the array
- **Patch 100**: Injects `setShellIfWindows()` call at SDK entry point
  - Adds auto-import of `windowsPaths.js` on Windows
  - Ensures shell environment is configured before any tool execution

### 5. New Files
- `README.md` — Updated documentation with Windows instructions
- `.github/workflows/ci.yml` — GitHub Actions CI for multi-platform builds
- `build-win.ps1` — PowerShell build script for Windows
- `.gitignore` — Standard ignores for the project
- `WINDOWS_PORTING_NOTES.md` — This file

## SDK Windows Support (Already Present)

The `open-agent-sdk` already contains significant Windows support code:

| File | Purpose |
|------|---------|
| `utils/windowsPaths.ts` | Win↔POSIX path conversion, Git Bash finder |
| `utils/platform.ts` | Platform detection (`'windows'` type) |
| `tools/PowerShellTool/` | Full PowerShell tool implementation |
| `utils/systemDirectories.ts` | Windows `USERPROFILE` directory mapping |
| `utils/Shell.ts` | Dual bash/powershell shell engine |
| `utils/execFileNoThrowPortable.ts` | Cross-platform process execution |

The main blocker was `SUPPORTED_PLATFORMS` only listing `['macos', 'wsl']`, which our patch fixes.

## Known Limitations

1. **BashTool**: Requires Git Bash on Windows. Without it, some bash-specific commands may fail.
   The SDK's PowerShellTool serves as an alternative for Windows-native operations.

2. **File permissions**: `fs.accessSync(path, X_OK)` behaves differently on Windows
   (Windows doesn't distinguish executable permissions). The SDK has fallback logic for this.

3. **POSIX signals**: `SIGTERM`/`SIGKILL` work differently on Windows.
   The `tree-kill` dependency handles cross-platform process termination.

4. **Symlinks**: Creating symlinks on Windows requires elevated privileges or Developer Mode.
   This may affect some Git worktree operations.
