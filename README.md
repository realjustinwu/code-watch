# cw (CodeWatch)

Wrap `codex` or `claude` and get macOS notifications when they need your attention.

## Problem

You run `codex` or `claude` in VSCode terminals, switch to other work, and forget to check back. Hours later you find it was stuck waiting for input.

## Solution

```bash
cw codex "fix the login bug"
cw claude
```

**cw** wraps the AI coding agent in a PTY and monitors it. When it needs attention, it sends a macOS desktop notification with sound.

- ⏳ **Agent waiting for input** — no output for 30s → wait 60s, then notify if you haven't returned
- ✅ **Agent completed** → notify immediately
- ❌ **Agent failed** → notify immediately

Internal commands (`git status`, `npm test`, etc.) run by the agent are transparent — no wrapping needed.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/realjustinwu/code-watch/main/install.sh | sh
cw --version

# Auto-wrap codex and claude (recommended)
cw init --aliases
source ~/.zshrc
```

See [INSTALL.md](INSTALL.md) for AI-friendly installation guide.

## Usage

```bash
# Via aliases (transparent, recommended)
codex "fix the bug"          # auto-wrapped by cw
claude                        # auto-wrapped by cw

# Explicit
cw codex "fix the bug"
cw claude

# Custom timeouts
cw --stall-timeout 20 --notify-delay 30 codex "build feature"
```

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `--stall-timeout` | 30 | Seconds of no output → "waiting for input" |
| `--notify-delay` | 60 | Seconds after stall trigger before notifying |

## How It Works

1. Creates a PTY (pseudo-terminal) for full terminal compatibility
2. Forwards stdin/stdout bidirectionally — fully transparent
3. Monitors output activity and process exit state
4. Agent waiting for input → countdown starts, notify if user doesn't return
5. Agent exits → notify immediately

## Requirements

- macOS (uses `osascript` for notifications)
- Python 3.6+ (stdlib only, zero dependencies)

## License

MIT
