# cw (CodeWatch)

Wrap CLI commands (codex, claude, etc.) and get macOS notifications when they need your attention.

## Problem

You run `codex` or `claude` in VSCode terminals, switch to other work, and forget to check back. Hours later you find it was stuck waiting for input.

## Solution

```bash
# Instead of:
codex "fix the login bug"

# Use:
cw codex "fix the login bug"
```

**cw** wraps your command in a PTY and monitors it. When it detects the command needs attention, it waits 1 minute — if you haven't returned to the terminal, it sends a macOS desktop notification with sound.

## Install

```bash
# Quick install (macOS / Linux)
curl -fsSL https://raw.githubusercontent.com/realjustinwu/code-watch/main/install.sh | sh

# Verify
cw --version

# Auto-wrap codex and claude (recommended)
cw init --aliases
source ~/.zshrc
```

See [INSTALL.md](INSTALL.md) for AI-friendly installation guide.

## Triggers

| Trigger | Condition | Notification |
|---------|-----------|-------------|
| Waiting for input | No output for 30s while process alive | ⏳ "可能等待输入" |
| Completed | Process exits with code 0 | ✅ "已完成" |
| Failed | Process exits non-zero | ❌ "失败 (exit N)" |

## Usage

```bash
# Via aliases (transparent)
codex "fix the bug"          # auto-wrapped by cw
claude                        # auto-wrapped by cw

# Explicit
cw codex "fix the bug"
cw claude
cw npm test

# Custom timeouts
cw --stall-timeout 20 --notify-delay 30 codex "build feature"
```

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `--stall-timeout` | 30 | Seconds of no output before "waiting for input" |
| `--notify-delay` | 60 | Seconds after trigger before notifying |

## How It Works

1. Creates a PTY (pseudo-terminal) for full terminal compatibility
2. Forwards stdin/stdout bidirectionally — fully transparent
3. Monitors output activity and process state
4. On trigger → countdown starts
5. No stdin activity during countdown → macOS notification
6. User types → countdown cancelled

## Requirements

- macOS (uses `osascript` for notifications)
- Python 3.6+ (stdlib only, zero dependencies)

## License

MIT
