#!/usr/bin/env bash

rofimoji \
  --action type \
  --skin-tone ask \
  --max-recent 0 \
  --prompt "Emoji" \
  --selector-args="-theme ~/.config/rofi/noleftpadding.rasi \
  -theme-str 'element-icon { enabled: false; } element { spacing: 0px; }'"

