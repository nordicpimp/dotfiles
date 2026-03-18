# Arch Linux Setup Runbook

A step-by-step rebuild guide — from fresh ISO to fully configured Hyprland system.

## Guide index

| Step | File | Description |
| --- | --- | --- |
| 1 | `1.base-arch-install.md` | Boot from ISO, run archinstall, configure NVIDIA before first reboot |
| 2 | `2.hyprland-install.md` | Install Hyprland, core session packages, verify from TTY |
| 3 | `3.dotfiles.md` | Clone dotfiles repo, install stow, stow all packages |
| 4 | `4.theming.md` | GTK, Qt, matugen first run, unified color pipeline |
| 5 | `5.greetd.md` | Install and configure greetd + cage + ReGreet login manager |
| 6 | `6.applications.md` | Install remaining GUI and TUI applications |

## Hardware reference

| Component | Detail |
| --- | --- |
| CPU | AMD Ryzen 7 7800X3D |
| Motherboard | ASUS TUF GAMING B650-PLUS WIFI |
| RAM | 32 GB |
| GPU | NVIDIA GeForce RTX 4070 Ti Super |
| WiFi | Realtek 8852BE (driver: `rtw89_8852be`, in mainline kernel since 6.2) |
| Ethernet | Realtek 2.5GbE (driver: `r8169`) |

## Key decisions

| Topic | Choice | Reason |
| --- | --- | --- |
| Network backend | NetworkManager | Mainline, well-supported, works with RTL8852BE out of the box |
| NVIDIA driver | `nvidia-open` | Open kernel modules — required for Ada Lovelace (RTX 40-series) |
| Login manager | greetd + cage + ReGreet | `cage -s` restricts greeter to primary monitor cleanly — SDDM has no equivalent |
| Wallpaper daemon | swww | Animated transitions, IPC hook for matugen pipeline |
| Launcher | rofi | Wayland support merged upstream in 2025 — install package `rofi` |
| Notifications | swaync | Only option with a persistent notification center panel + waybar widget |
| Discord client | Vesktop | Wayland-native, audio screen share, recommended by Hyprland wiki |
| Dotfile management | GNU Stow | Symlink farm — clean git repo, selective per-machine deployment |
| Color pipeline | matugen | Material You algorithm, template-based, integrates with all apps |

## Order of operations (summary)

```
1.  Boot ISO
2.  Set keyboard + connect WiFi (iwctl — live session only)
3.  Run archinstall (Minimal profile, NetworkManager, base-devel git)
4.  DO NOT REBOOT — arch-chroot into new system
5.  Enable multilib in /etc/pacman.conf
6.  Install NVIDIA drivers (nvidia-open + utils)
7.  Configure mkinitcpio.conf (add NVIDIA modules, remove kms)
8.  Add kernel parameters to bootloader entry
9.  Enable nvidia-suspend/hibernate/resume services
10. Exit chroot → reboot
11. Verify NVIDIA + NetworkManager on first boot
12. Install tmux — split screen + copy-paste in TTY
13. Install AUR helper (paru)
14. Install frogmouth — read remaining guides from TTY
15. Install Hyprland + core session packages
16. Launch Hyprland from TTY — verify stable before enabling greetd
17. Clone dotfiles + stow all packages
18. Install remaining core packages
19. GTK + Qt theming (nwg-look, kvantummanager)
20. matugen first run — unifies colors across all apps
21. Install + enable greetd (LAST — replaces TTY login)
22. Install additional applications
```

## Reference document

A detailed HTML reference covering the full theming stack, all application
decisions, and configuration patterns is maintained separately as
`hyprland-theming-reference.html`. Open in any browser.

---

## Installing Claude Desktop on Hyprland

Anthropic does not publish an official Linux build. The community maintains
an unofficial AUR package that extracts the Windows release and repackages it
for Arch. It supports MCP and the launcher script auto-detects Wayland and
adds the Ozone flags — no manual flag configuration needed on Hyprland.

> **Unofficial software:** this is a community repackaging of a proprietary
> Windows application. It is not supported by Anthropic. MCP config lives at
> `~/.config/Claude/claude_desktop_config.json`.

```bash
paru -S claude-desktop-bin
```

If the build fails with a checksum error (the AUR package version can fall
behind when Anthropic releases an update):

```bash
# Clear paru's cached source and retry
paru -S claude-desktop-bin --rebuildall
```

If `asar` is missing during the build:

```bash
sudo npm install -g asar
paru -S claude-desktop-bin
```

Launch from rofi, your application menu, or directly:

```bash
claude-desktop
```

Verify it is running in native Wayland mode (not XWayland):

```bash
hyprctl clients | grep -i claude
# Should show: xwayland: 0
```

MCP configuration — add servers to:

```bash
nvim ~/.config/Claude/claude_desktop_config.json
```
