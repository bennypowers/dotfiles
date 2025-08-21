# CEM LSP Screencast Recording

This directory contains tools for recording screencasts of the CEM LSP server in action.

## Quick Start

```bash
# Test the recording script
./auto-record-nvim.fish ./demo-project --dry-run

# Record a demo session with the demo project
./auto-record-nvim.fish ./demo-project

# Record a specific file editing session
./auto-record-nvim.fish ./demo-project/index.html
```

## Scripts

### `auto-record-nvim.fish` - Automatic Recording Script

**New simplified API** that addresses previous issues:
- ✅ **Automatically starts recording** when nvim opens
- ✅ **Automatically stops recording** when nvim exits  
- ✅ **Launches new kitty window** (doesn't hijack your current terminal)
- ✅ **Records only the kitty window** with 20px margin (no extra desktop clutter)
- ✅ **Dynamic geometry detection** (adapts to actual window size)
- ✅ **Takes directory or file argument**:
  - Directory: `cd` to directory and open `nvim .`
  - File: Open file directly with `nvim <file>`
- ✅ **Produces actual video files** in `./screencasts/`
- ✅ **Never opens with blank file** - always opens target

**Usage:**
```bash
./auto-record-nvim.fish <target> [--dry-run]
```

**Features:**
- Automatic lifecycle management (start → record → stop)
- Smart filename generation based on target
- Window environment setup for clean recording
- Dependency checking
- Dry-run mode for testing

### `recording-setup.fish` - Manual Recording Setup

The original manual recording script with advanced features:
- Manual recording control with Super+R keybind
- Multiple recording workflows
- Advanced window management

## Output

All recordings are saved to `./screencasts/` with timestamps:
- `cem-demo_demo-project_20250820_102038.mp4`
- `cem-demo_index.html_20250820_102049.mp4`

## Requirements

- **wf-recorder** - For screen recording
- **hyprctl** - For Hyprland window management
- **kitty** - Terminal emulator (launches new window for recording)
- **jq** - For JSON parsing (window geometry detection)
- **nvim** - Obviously

## Troubleshooting

1. **No video files produced**:
   - Check that `wf-recorder` is installed and working
   - Verify the output directory `./screencasts/` is writable
   - Check that the window geometry is correct for your setup

2. **Opens with blank file**:
   - This script always opens your specified target
   - Use `--dry-run` to verify what will be opened
   - Make sure the target file/directory exists

3. **Recording doesn't stop**:
   - Recording stops automatically when nvim exits
   - If stuck, kill with: `pkill -f 'wf-recorder.*cem-demo'`
   - Check `/tmp/auto-record-nvim.pid` for process tracking

## Demo Project

The `demo-project/` directory contains a ready-to-use project for demonstrations:
- Custom element components (button, card)
- HTML file using the elements  
- TypeScript source files
- LSP configuration

Perfect for showcasing:
- Completions
- Hover information
- Go-to-definition
- Diagnostics and code actions