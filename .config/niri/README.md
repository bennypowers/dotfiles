# Niri Configuration

This directory contains the configuration for [niri](https://github.com/YaLTeR/niri), a scrollable-tiling Wayland compositor.

## Configuration File

- `config.kdl`: Main niri configuration (KDL format)

## Session Management

This setup uses **uwsm** (Universal Wayland Session Manager) to manage the niri session with systemd integration.

### Session Launch

The session is launched via the display manager using `/usr/share/wayland-sessions/niri-uwsm.desktop`, which executes:
```bash
uwsm start -- niri.desktop
```

### Systemd Integration

The session is managed through systemd user units:

- **niri-session.target**: Main session target located at `~/.config/systemd/user/niri-session.target`
  - Part of `graphical-session.target`
  - Automatically starts session-specific services

### Session Services

Services enabled for the niri session (via `niri-session.target.wants/`):

- **quickshell.service**: QtQuick-based desktop shell for panels/widgets
  - Documentation: https://quickshell.outfoxxed.me/
  - Conflicts with waybar to prevent both running simultaneously
  - Auto-restarts on failure

- **quickshell-polkit-agent.service**: Polkit authentication agent
  - System service with local override at `~/.config/systemd/user/quickshell-polkit-agent.service.d/override.conf`
  - Enables debug logging with `QT_LOGGING_RULES="*.debug=true"`

- **hyprpaper.service**: Wallpaper daemon
  - Placed within backdrop via layer rule in `config.kdl`

Additional services wanted by niri-session.target but not in wants/ directory:
- **swaync.service**: Notification daemon
- **hypridle.service**: Idle management daemon

## XDG Desktop Portal Configuration

Portal configuration is located at `~/.config/xdg-desktop-portal/portals.conf`.

### Current Setup

- **Primary portal**: `xdg-desktop-portal-gnome`
- **Fallback portals**: `xdg-desktop-portal-gtk`
- **File chooser**: GTK-based (`xdg-desktop-portal-gtk`)

This setup follows the recommendation from [niri discussion #763](https://github.com/YaLTeR/niri/discussions/763) to use the GNOME portal for better compatibility.

### Portal Environment Variables

Portal services are configured via systemd overrides:

**xdg-desktop-portal.service** (`~/.config/systemd/user/xdg-desktop-portal.service.d/50-niri.conf`):
```
Environment=XDG_CURRENT_DESKTOP=niri
Environment=XDG_SESSION_DESKTOP=niri
Environment=XDG_SESSION_TYPE=wayland
Environment=WAYLAND_DISPLAY=wayland-1
```

**xdg-desktop-portal-gnome.service** (`~/.config/systemd/user/xdg-desktop-portal-gnome.service.d/fake-gnome.conf`):
```
Environment=XDG_CURRENT_DESKTOP=GNOME
Environment=XDG_SESSION_DESKTOP=gnome
Environment=DESKTOP_SESSION=gnome
Environment=GDMSESSION=gnome
Environment=GNOME_DESKTOP_SESSION_ID=this-is-deprecated
Environment=GDK_BACKEND=wayland
```

Note: The "fake-gnome" environment variables trick the GNOME portal into working with niri.

## Key Configuration Highlights

### Environment Variables (config.kdl)

- **Cursor theme**: phinger-cursors-dark (size 48)
- **Qt platform theme**: qt5ct
- **Desktop identification**: NiRi

### Input Configuration

- **Keyboard layouts**: US, Adelman (toggle with Win+Space)
- **Focus follows mouse**: Enabled
- **Natural scroll**: Enabled for mouse, touchpad, and trackball

### Display Configuration

- **DP-1 & DP-2**: 5120x2160@120Hz, scale 1.0

### Layout Settings

- **Gaps**: 16px
- **Default column width**: 33.33% of screen
- **Preset widths**: 33%, 50%, 67%, 100%
- **Corner radius**: 12px
- **Focus ring**: Catppuccin Macchiato Mauve (#c6a0f6)
- **Struts**: 48px top/bottom (reserved for quickshell panels)

### Key Bindings

Navigation uses vim-style keys (hjkl):
- **Mod+h/j/k/l**: Focus left/down/up/right
- **Mod+Shift+h/j/k/l**: Move window/column
- **Mod+Ctrl+h/l**: Consume/expel window

Applications:
- **Mod+t**: Kitty terminal
- **Mod+f**: Nautilus file manager
- **Mod+e**: Thunderbird
- **Mod+b**: Zen Browser (flatpak)
- **Mod+p**: Vicinae toggle
- **Mod+o**: Toggle overview

Special features:
- **Mod+w**: Switch to "workmode" workspace (configured for VM full-screen)
- **Mod+v**: Launch virt-viewer for VM access
- **MouseForward**: Toggle overview

Media keys are integrated using `uwsm app --` for proper session scoping:
- Volume control (wpctl)
- Brightness control (brightnessctl)
- Media player control (playerctl)

### Startup Applications

- **swww-daemon**: Alternative wallpaper daemon (note: hyprpaper is also enabled via systemd)

  - Hyprpaper is responsible for the overview background,
  - swww is responsible for the workspace backgrounds

### Window Rules

Notable window-specific configurations:
- **Kitty**: 25% column width by default
- **Bitwarden**: Floating, max 500x800, blocked from screen capture
- **Virt-viewer** (silverblue): Opens fullscreen on "workmode" workspace

### Layer Rules

- **quickshell-polkit-agent**: Large shadow overlay for authentication prompts
- **hyprpaper**: Placed within backdrop layer

## Applying Changes

After modifying configuration files:

### Niri configuration
```bash
# Reload niri config
niri msg reload-config
```

### Systemd services
```bash
# Reload systemd daemon
systemctl --user daemon-reload

# Restart a specific service
systemctl --user restart quickshell.service
```

### Portal configuration
```bash
# Restart portal services
systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-gnome.service
```

## Troubleshooting

### Check session status
```bash
uwsm check may-start
uwsm check has-active-compositor
```

### View service logs
```bash
journalctl --user -u niri-session.target
journalctl --user -u quickshell.service
journalctl --user -u xdg-desktop-portal.service
```

### Portal debugging
```bash
# Check which portal is being used
systemctl --user status xdg-desktop-portal.service
systemctl --user status xdg-desktop-portal-gnome.service

# Monitor portal activity
journalctl --user -f -u xdg-desktop-portal\*
```

## References

- [Niri documentation](https://github.com/YaLTeR/niri/wiki)
- [Niri portal discussion](https://github.com/YaLTeR/niri/discussions/763)
- [QuickShell documentation](https://quickshell.outfoxxed.me/)
- [uwsm documentation](https://github.com/Vladimir-csp/uwsm)
