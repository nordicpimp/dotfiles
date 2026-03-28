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

# ── Write waybar style ────────────────────────────────────────────────────────
cat > "$STYLE_FILE" << EOF
/* Active waybar style — managed by waybar-style.sh */
@import "/home/nordicpimp/.config/waybar/style-${CHOICE}.css";
EOF

# ── Apply matching Hyprland decoration ───────────────────────────────────────
case "$CHOICE" in
    fullwidth)
        # Edge to edge — no gaps, no rounding, thin border only
        hyprctl keyword general:gaps_in 0
        hyprctl keyword general:gaps_out 0
        hyprctl keyword general:border_size 1
        hyprctl keyword decoration:rounding 0
        hyprctl keyword decoration:shadow:enabled false
        hyprctl keyword decoration:blur:enabled false
        # Un-float all windows
        hyprctl dispatch workspaceopt allfloat
        ;;
    floating)
        # Standard tiled — moderate gaps, slight rounding
        hyprctl keyword general:gaps_in 3
        hyprctl keyword general:gaps_out 6
        hyprctl keyword general:border_size 1
        hyprctl keyword decoration:rounding 5
        hyprctl keyword decoration:shadow:enabled true
        hyprctl keyword decoration:blur:enabled true
        hyprctl dispatch workspaceopt allfloat
        ;;
    islands)
        # All windows float — generous gaps, rounded, prominent borders
        hyprctl keyword general:gaps_in 8
        hyprctl keyword general:gaps_out 16
        hyprctl keyword general:border_size 2
        hyprctl keyword decoration:rounding 10
        hyprctl keyword decoration:shadow:enabled true
        hyprctl keyword decoration:blur:enabled true
        # Toggle all windows to float on current workspace
        hyprctl dispatch workspaceopt allfloat
        ;;
esac

# ── Restart waybar ────────────────────────────────────────────────────────────
pkill waybar
sleep 0.5
waybar -c ~/.config/waybar/config-primary.jsonc -s ~/.config/waybar/style.css &
waybar -c ~/.config/waybar/config-secondary.jsonc -s ~/.config/waybar/style.css &
