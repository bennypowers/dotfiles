# Niri Configuration Instructions

## Before Making Changes

**IMPORTANT**: Always consult the `README.md` in this directory before making any changes to:
- `config.kdl` (niri configuration)
- Systemd service files
- XDG portal configuration
- Any session management settings

The README contains comprehensive documentation about:
- How the session management works (uwsm + systemd)
- What services are running and why
- Portal configuration and environment variables
- Current key bindings and window rules
- Display and layout settings

Understanding the existing setup will help prevent breaking changes and maintain consistency.

## After Making Changes

**REQUIRED**: Update the `README.md` after making any significant changes:
- New services added to the session
- Changes to portal configuration
- New key bindings or modifications to existing ones
- Window rules added or modified
- Layout or display configuration changes
- Any systemd service modifications

Keep the README synchronized with the actual configuration so it remains a reliable source of truth.

## Quick Reference

- **Main config**: `config.kdl`
- **Session target**: `~/.config/systemd/user/niri-session.target`
- **Portal config**: `~/.config/xdg-desktop-portal/portals.conf`
- **Portal overrides**: `~/.config/systemd/user/xdg-desktop-portal*.service.d/`
