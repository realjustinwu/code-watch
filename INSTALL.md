# CodeWatch (cw) — Installation Guide for AI Coding Assistants

## What is cw?

`cw` wraps CLI commands (codex, claude, etc.) in a PTY and sends macOS desktop notifications when:
- ⏳ Command is likely **waiting for input** (no output for 30s)
- ✅ Command **completed** successfully
- ❌ Command **failed** (non-zero exit)

After trigger, waits 60s — only notifies if the user hasn't returned to the terminal.

## Pre-Installation Check

```bash
cw --version    # If found, already installed — skip to "Aliases"
```

## Installation

### Quick Install (macOS / Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/wuchengbin/codewatch/main/install.sh | sh
```

Installs to `~/.local/bin/cw`. Verify:

```bash
cw --version    # Should show "cw 0.2.0"
```

### Manual Install

```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/wuchengbin/codewatch/main/cw -o ~/.local/bin/cw
chmod +x ~/.local/bin/cw
```

If `~/.local/bin` is not in PATH:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## Shell Aliases (Recommended)

Auto-wrap codex and claude so the user never forgets:

```bash
cw init --aliases
source ~/.zshrc
```

This adds:
- `alias codex='cw codex'`
- `alias claude='cw claude'`

To remove later: `cw init --uninstall-aliases`

## Usage

```bash
# Via aliases (transparent)
codex "fix the login bug"       # automatically wrapped
claude                           # automatically wrapped

# Explicit wrapping
cw codex "fix the bug"
cw claude
cw npm test

# Custom timeouts
cw --stall-timeout 20 --notify-delay 30 codex "build feature"
```

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `--stall-timeout` | 30 | Seconds without output → "waiting for input" |
| `--notify-delay` | 60 | Seconds after trigger → notify if user inactive |

## How It Works

1. Creates a PTY (pseudo-terminal) — full terminal compatibility (colors, keys, etc.)
2. Bidirectional stdin/stdout forwarding — fully transparent
3. Monitors output activity and process exit state
4. On trigger: countdown starts
5. If no stdin activity during countdown → macOS notification with sound
6. If user types → countdown cancelled

## Requirements

- macOS (uses `osascript` for notifications)
- Python 3.6+ (stdlib only, zero dependencies)

## Uninstall

```bash
cw init --uninstall-aliases   # remove shell aliases
rm ~/.local/bin/cw             # remove binary
```

## AI Assistant Checklist

Before each session:
- [ ] Check if cw is installed: `cw --version`
- [ ] If not installed → `curl -fsSL https://raw.githubusercontent.com/wuchengbin/codewatch/main/install.sh | sh`
- [ ] Check if aliases are set: `grep "cw (CodeWatch)" ~/.zshrc`
- [ ] If not set → `cw init --aliases`
- [ ] When running codex/claude, always use `cw codex ...` or ensure aliases are active
