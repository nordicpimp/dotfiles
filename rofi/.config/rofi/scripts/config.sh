#!/bin/bash

option=$(printf "Hyprland\nKitty\nWaybar\nSwayNC" | rofi -dmenu -p "Edit Config"

case "$option" in
    "Hyprland" kitty --hold nvim "$HOME/.config/hypr/hyprland.conf" ;;
    "Kitty" kitty --hold nvim "$HOME/.config/kitty/kitty.conf" ;;
    "Waybar" kitty --hold nvim "$HOME/.config/waybar/config.jsonc" ;;
    "SwayNC" kitty --hold nvim "$HOME/.config/swaync/config.json" ;;
esac
