#!/usr/bin/env bash
# wallpaper-picker.sh — 5x3 thumbnail grid wallpaper picker via rofi
# Filters out portrait variants (_1440x2560) to avoid duplicates.
# Portrait variants are applied automatically by wallpaper.sh if they exist.

WALLPAPER_DIR="$HOME/pictures/wallpapers"

SELECTION=$(
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" \) \
    | grep -v "_1440x2560" \
    | sort \
    | while read -r FILEPATH; do
        FILENAME=$(basename "$FILEPATH")
        printf "%s\0icon\x1f%s\n" "$FILENAME" "$FILEPATH"
    done \
    | rofi -dmenu \
           -p "" \
           -i \
           -show-icons \
           -theme "/home/nordicpimp/.config/rofi/wallpaper.rasi"
)

[[ -z "$SELECTION" ]] && exit 0

/home/nordicpimp/dotfiles/shell/scripts/wallpaper.sh "$WALLPAPER_DIR/$SELECTION"
