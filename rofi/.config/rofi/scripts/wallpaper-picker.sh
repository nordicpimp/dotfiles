#!/usr/bin/env bash
# wallpaper-picker.sh — browse wallpapers with rofi and apply selection
# Only shows landscape wallpapers (2560x1440) to avoid duplicates in the list.
# Portrait variants are applied automatically by wallpaper.sh if they exist.

WALLPAPER_DIR="$HOME/pictures/wallpapers"

# Build list — prefer landscape variants, fall back to all images
SELECTION=$(
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" \) \
    | grep -v "_1440x2560" \
    | sort \
    | xargs -I{} basename {} \
    | rofi -dmenu \
           -p "Wallpaper" \
           -i \
           -theme-str 'window { width: 50%; }' \
           -theme-str 'listview { lines: 10; }'
)

[[ -z "$SELECTION" ]] && exit 0

wallpaper.sh "$WALLPAPER_DIR/$SELECTION"
