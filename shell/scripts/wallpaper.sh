#!/usr/bin/env bash
# wallpaper.sh — set wallpaper on both monitors and regenerate matugen colors
# Usage: wallpaper.sh <path-to-landscape-wallpaper>

WALLPAPER="$1"
STATE_FILE="$HOME/.cache/waybar-style-current"

if [[ -z "$WALLPAPER" ]]; then
    echo "Usage: wallpaper.sh <path-to-image>"
    exit 1
fi

if [[ ! -f "$WALLPAPER" ]]; then
    echo "File not found: $WALLPAPER"
    exit 1
fi

# Derive portrait variant
PORTRAIT="${WALLPAPER/_2560x1440/_1440x2560}"

# Set wallpaper — dual monitor aware
if [[ "$PORTRAIT" != "$WALLPAPER" && -f "$PORTRAIT" ]]; then
    swww img --outputs DP-1     "$WALLPAPER" --transition-type wipe --transition-duration 1
    swww img --outputs HDMI-A-1 "$PORTRAIT"  --transition-type wipe --transition-duration 1
else
    swww img "$WALLPAPER" --transition-type wipe --transition-duration 1
fi

# Regenerate color palette
matugen image --source-color-index 0 "$WALLPAPER"

# Re-apply current layout style decoration so gaps/rounding aren't reset
CURRENT_STYLE=$(cat "$STATE_FILE" 2>/dev/null || echo "fullwidth")
case "$CURRENT_STYLE" in
    floating)
        hyprctl keyword general:gaps_in 4
        hyprctl keyword general:gaps_out 8
        hyprctl keyword general:border_size 1
        hyprctl keyword decoration:rounding 12
        hyprctl keyword decoration:shadow:enabled true
        hyprctl keyword decoration:shadow:range 4
        hyprctl keyword decoration:shadow:render_power 1
        hyprctl keyword decoration:blur:enabled true
        ;;
    islands)
        hyprctl keyword general:gaps_in 8
        hyprctl keyword general:gaps_out 16
        hyprctl keyword general:border_size 2
        hyprctl keyword decoration:rounding 10
        hyprctl keyword decoration:shadow:enabled true
        hyprctl keyword decoration:shadow:range 6
        hyprctl keyword decoration:shadow:render_power 1
        hyprctl keyword decoration:blur:enabled true
        ;;
    *)  # fullwidth default
        hyprctl keyword general:gaps_in 0
        hyprctl keyword general:gaps_out 0
        hyprctl keyword general:border_size 1
        hyprctl keyword decoration:rounding 0
        hyprctl keyword decoration:shadow:enabled false
        hyprctl keyword decoration:blur:enabled false
        ;;
esac

# Reload kitty colors live in all running instances
# Find the kitty socket dynamically — kitty may append PID to socket name
KITTY_SOCKET=$(ls /tmp/kitty 2>/dev/null || ls /tmp/kitty-* 2>/dev/null | head -1)
if [[ -n "$KITTY_SOCKET" ]]; then
    kitty @ --to unix:"$KITTY_SOCKET" set-colors --all ~/.cache/matugen/colors-kitty.conf 2>/dev/null || true
fi

# Reload waybar with new colors
pkill waybar
sleep 0.5
waybar -c ~/.config/waybar/config-primary.jsonc -s ~/.config/waybar/style.css &
waybar -c ~/.config/waybar/config-secondary.jsonc -s ~/.config/waybar/style.css &
swaync-client -R
