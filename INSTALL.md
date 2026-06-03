# CodeWatch (cw) — Installation Guide for AI Coding Assistants

## What is cw?

`cw` wraps `codex` or `claude` in a PTY and sends macOS desktop notifications when the AI agent needs attention:
- ⏳ Agent is **waiting for input** (no output for 30s → wait 60s → notify if user hasn't returned)
- ✅ Agent **completed** (notify immediately)
- ❌ Agent **failed** (notify immediately)

**Only wrap the top-level agent command.** Internal commands run by the agent (`git status`, `npm test`, etc.) are transparent — no wrapping needed.

## Pre-Installation Check

```bash
cw --version    # If found, already installed — skip to "Aliases"
```

## Installation

### Quick Install (macOS / Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/realjustinwu/code-watch/main/install.sh | sh
```

Installs to `~/.local/bin/cw`. Verify:

```bash
cw --version    # Should show "cw 0.2.0"
```

### Manual Install

```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/realjustinwu/code-watch/main/cw -o ~/.local/bin/cw
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
# Via aliases (transparent, recommended)
codex "fix the login bug"       # automatically wrapped
claude                           # automatically wrapped

# Explicit
cw codex "fix the bug"
cw claude

# Custom timeouts
cw --stall-timeout 20 --notify-delay 30 codex "build feature"
```

**Do NOT wrap internal commands.** The agent runs `git`, `npm`, `grep`, etc. internally — these are handled by the agent itself and need no wrapping.

## Options

| Option | Default | Description |
|--------|---------|-------------|
| `--stall-timeout` | 30 | Seconds without output → "waiting for input" |
| `--notify-delay` | 60 | Seconds after stall trigger → notify if user inactive |

## How It Works

1. Creates a PTY (pseudo-terminal) — full terminal compatibility (colors, keys, etc.)
2. Bidirectional stdin/stdout forwarding — fully transparent
3. Monitors output activity and process exit state
4. Agent waiting for input → countdown starts → notify if user doesn't return
5. Agent exits → notify immediately

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
- [ ] If not installed → `curl -fsSL https://raw.githubusercontent.com/realjustinwu/code-watch/main/install.sh | sh`
- [ ] Check if aliases are set: `grep "cw (CodeWatch)" ~/.zshrc`
- [ ] If not set → `cw init --aliases`
- [ ] When running codex/claude, use `cw codex ...` or ensure aliases are active
