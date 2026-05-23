#!/usr/bin/env bash

if ! command -v wezterm >/dev/null; then
  notify-send 'Hyprland' 'Wezterm not found'
  exit 1
fi

export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.json

exec wezterm "$@"
