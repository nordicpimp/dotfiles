#!/usr/bin/env bash
# waybar-style.sh — switch waybar style + matching hyprland decoration
# Super+Shift+W

STYLE_FILE="$HOME/.config/waybar/style.css"

CHOICE=$(printf "fullwidth\nfloating\nislands" | rofi -dmenu \
    -p "Layout style" \
    -theme "/home/nordicpimp/.config/rofi/theme.rasi" \
    -theme-str 'window { width: 30%; }' \
    -theme-str 'listview { lines: 3; }')

[[ -z "$CHOICE" ]] && exit 0

# Save current style for wallpaper.sh to re-apply after wallpaper changes
echo "$CHOICE" > "$HOME/.cache/waybar-style-current"

# ── Write waybar style ────────────────────────────────────────────────────────
cat > "$STYLE_FILE" << EOF
/* Active waybar style — managed by waybar-style.sh */
@import "/home/nordicpimp/.config/waybar/style-${CHOICE}.css";
EOF

# ── Apply matching Hyprland decoration ───────────────────────────────────────
case "$CHOICE" in
    fullwidth)
        # Edge to edge — no gaps, no rounding, thin border, no shadow
        hyprctl keyword general:gaps_in 0
        hyprctl keyword general:gaps_out 0
        hyprctl keyword general:border_size 1
        hyprctl keyword decoration:rounding 0
        hyprctl keyword decoration:shadow:enabled false
        hyprctl keyword decoration:blur:enabled false
        hyprctl dispatch workspaceopt allfloat
        ;;
    floating)
        # Tiled pill — gaps/rounding match waybar pill (margin 8px, radius 12px)
        # Shadow range kept tiny so it doesn't add visual padding beyond gaps_out
        hyprctl keyword general:gaps_in 4
        hyprctl keyword general:gaps_out 8
        hyprctl keyword general:border_size 1
        hyprctl keyword decoration:rounding 12
        hyprctl keyword decoration:shadow:enabled true
        hyprctl keyword decoration:shadow:range 4
        hyprctl keyword decoration:shadow:render_power 1
        hyprctl keyword decoration:blur:enabled true
        hyprctl dispatch workspaceopt allfloat
        ;;
    islands)
        # Floating windows — gaps/rounding match waybar islands (margin 16px, radius 10px)
        # Shadow range kept tight so visual edge aligns with gaps_out
        hyprctl keyword general:gaps_in 8
        hyprctl keyword general:gaps_out 16
        hyprctl keyword general:border_size 2
        hyprctl keyword decoration:rounding 10
        hyprctl keyword decoration:shadow:enabled true
        hyprctl keyword decoration:shadow:range 6
        hyprctl keyword decoration:shadow:render_power 1
        hyprctl keyword decoration:blur:enabled true
        hyprctl dispatch workspaceopt allfloat
        ;;
esac

# ── Restart waybar ────────────────────────────────────────────────────────────
pkill waybar
sleep 0.5
waybar -c ~/.config/waybar/config-primary.jsonc -s ~/.config/waybar/style.css &
waybar -c ~/.config/waybar/config-secondary.jsonc -s ~/.config/waybar/style.css &
