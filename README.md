# OpenClaw-Win 🪟

> Cross-platform desktop GUI client for Claude Code agent engine — **Windows first, macOS & Linux supported**

Fork of [OpenClaude](https://github.com/komako-workshop/openclaude), ported to support Windows natively.

## ✨ What's Different from OpenClaude

- ✅ **Windows native support** — NSIS installer + portable builds for x64/arm64
- ✅ **Cross-platform window chrome** — native title bar on Windows, hidden inset on macOS
- ✅ **Auto Shell detection** — finds Git Bash or falls back to PowerShell on Windows
- ✅ **SDK platform patches** — adds `windows` and `linux` to `SUPPORTED_PLATFORMS`
- ✅ **`setShellIfWindows()` auto-init** — ensures proper shell environment on startup
- ✅ **GitHub Actions CI** — automated builds for Windows/macOS/Linux
- ✅ **macOS & Linux builds** — also supported (x64 + arm64)

## 📋 Prerequisites

### Windows
- [Node.js](https://nodejs.org/) >= 18
- [Git for Windows](https://git-scm.com/downloads/win) (provides Git Bash — **strongly recommended**)
- PowerShell 5.1+ (built-in, used as fallback if Git Bash not found)

### macOS
- Node.js >= 18
- Xcode Command Line Tools

### Linux
- Node.js >= 18
- Build essentials (`apt install build-essential`)

## 🚀 Quick Start

```bash
# Clone
git clone https://github.com/ixuexii-alt/openclaw-win.git
cd openclaw-win/app

# Install dependencies
npm install

# Development mode
npm run dev

# Build for your platform
npm run package:win    # Windows (NSIS + portable)
npm run package:mac    # macOS (DMG)
npm run package:linux  # Linux (AppImage + deb)
npm run package:all    # All platforms
```

## 🏗️ Architecture

```
openclaw-win/
├── app/                    # Electron desktop app
│   ├── electron/main/      # Main process — Agent bridge
│   ├── electron/preload/   # Preload scripts
│   ├── src/                # React frontend UI
│   └── scripts/            # Build & SDK patch scripts
├── open-agent-sdk/         # ShipAny open-source SDK
│   └── src/                # Claude Code Node.js port
└── claude-code/            # Original Claude Code source (read-only reference)
```

### Key Windows Adaptations

| Component | Change | File |
|-----------|--------|------|
| Window chrome | `titleBarStyle: 'default'` on Windows | `electron/main/index.ts` |
| Shell detection | Auto-find Git Bash → PowerShell fallback | `electron/main/index.ts` |
| Build targets | NSIS installer + portable exe | `electron-builder.yml` |
| SDK platforms | `windows` + `linux` added to `SUPPORTED_PLATFORMS` | `scripts/patch-open-agent-sdk.mjs` |
| Shell init | `setShellIfWindows()` called on SDK load | `scripts/patch-open-agent-sdk.mjs` |

## ⚙️ Configuration

Settings are stored at:
- **Windows**: `%APPDATA%/OpenClaw-Win/settings.json`
- **macOS**: `~/Library/Application Support/OpenClaw-Win/settings.json`
- **Linux**: `~/.config/OpenClaw-Win/settings.json`

### API Configuration

1. Open Settings (gear icon)
2. Enter your API Key (OpenRouter, Anthropic, or compatible)
3. Set Base URL (default: `https://openrouter.ai/api`)
4. Choose model (default: `anthropic/claude-sonnet-4.6`)

### MCP Servers

MCP servers are loaded from `~/.claude.json` (same as Claude Code).

## 🔧 Troubleshooting

### Windows: "Shell not found" errors
Install [Git for Windows](https://git-scm.com/downloads/win). The app auto-detects Git Bash at:
- `C:\Program Files\Git\bin\bash.exe`
- `C:\Program Files (x86)\Git\bin\bash.exe`
- `%LOCALAPPDATA%\Programs\Git\bin\bash.exe`

If Git Bash is not found, PowerShell is used as fallback.

### Windows: BashTool commands fail
Some Claude Code tools use bash syntax. On Windows:
- **With Git Bash**: Most bash commands work transparently
- **Without Git Bash**: The SDK falls back to PowerShellTool for Windows-native commands

### Build fails with memory error
The build script already sets `--max-old-space-size=8192`. If you still get OOM errors, increase it:
```bash
node --max-old-space-size=16384 ./node_modules/.bin/electron-builder --win
```

## 📄 License

Same as upstream OpenClaude project.

## 🙏 Credits

- [OpenClaude](https://github.com/komako-workshop/openclaude) — Original macOS client
- [ShipAny Open Agent SDK](https://github.com/anthropics/claude-code) — Agent engine
- [Electron](https://www.electronjs.org/) — Cross-platform desktop framework
