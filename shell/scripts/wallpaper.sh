#!/usr/bin/env bash
# wallpaper.sh — set wallpaper on both monitors and regenerate matugen colors
# Usage: wallpaper.sh <path-to-landscape-wallpaper>
#
# Dual monitor logic:
# If the wallpaper filename contains _2560x1440, it looks for a matching
# _1440x2560 portrait variant for the secondary monitor.
# Falls back to the same image on both monitors if no portrait variant exists.

WALLPAPER="$1"

if [[ -z "$WALLPAPER" ]]; then
    echo "Usage: wallpaper.sh <path-to-image>"
    exit 1
fi

if [[ ! -f "$WALLPAPER" ]]; then
    echo "File not found: $WALLPAPER"
    exit 1
fi

# Derive portrait variant path by substituting dimensions in filename
PORTRAIT="${WALLPAPER/_2560x1440/_1440x2560}"

# Set wallpaper — dual monitor aware
if [[ "$PORTRAIT" != "$WALLPAPER" && -f "$PORTRAIT" ]]; then
    # Portrait variant exists — set each monitor independently
    swww img --outputs DP-1   "$WALLPAPER" \
        --transition-type wipe --transition-duration 1
    swww img --outputs HDMI-A-1 "$PORTRAIT" \
        --transition-type wipe --transition-duration 1
else
    # No portrait variant — same image on both
    swww img "$WALLPAPER" \
        --transition-type wipe --transition-duration 1
fi

# Regenerate color palette
matugen image --source-color-index 0 "$WALLPAPER"

# Reload apps
pkill waybar && uwsm app -- waybar &
hyprctl reload
swaync-client -R
