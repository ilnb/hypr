#!/usr/bin/env bash

data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/end4"
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/end4"
pdf_cache="${cache_dir}/pdf_cache.tsv"

hypr_border="$(hyprctl -j getoption decoration:rounding 2>/dev/null | jq '.int' || echo 10)"
hypr_width="$(hyprctl -j getoption general:border_size 2>/dev/null | jq '.int' || echo 2)"

get_font() {
  local font
  font=$(hyprctl -j getoption misc:font_family 2>/dev/null | jq -r '.str // empty')
  [[ -z "$font" ]] && font=$(gsettings get org.gnome.desktop.interface font-name 2>/dev/null | tr -d "'")
  echo "${font:-"JetBrainsMono Nerd Font"}"
}

get_icon_theme() {
  local theme
  theme=$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null | tr -d "'")
  echo "${theme:-"hicolor"}"
}

rofi_config="${ROFI_LAUNCH_FILEBROWSER_STYLE:-pdf_selector}"

font_scale="${ROFI_LAUNCH_SCALE}"
[[ "${font_scale}" =~ ^[0-9]+$ ]] || font_scale=${ROFI_SCALE:-10}

font_name="${ROFI_LAUNCH_FONT:-${ROFI_FONT:-$(get_font)}}"
font_override="* {font: \"${font_name} ${font_scale}\";}"

wind_border=$((hypr_border * 3))
elem_border=$((hypr_border * 2))
r_override="window{border:${hypr_width}px;border-radius:${wind_border}px;} element{border-radius:${elem_border}px;}"

icon_theme="$(get_icon_theme)"
i_override="configuration {icon-theme: \"${icon_theme}\";}"

fd_hidden=""
[[ "$1" == "hidden" ]] && fd_hidden="-H"

build_cache() {
  mkdir -p "${cache_dir}"
  local tmp
  tmp=$(mktemp)
  while IFS= read -r f; do
    local base dir display
    base=$(basename "$f")
    dir=$(dirname "$f")
    display="$([[ "$dir" == "$HOME" ]] && echo "$base" || echo "$(basename "$dir")/$base")"
    printf "%s\t%s\n" "$display" "$f"
  done < <(fd -H -t f -e pdf --full-path "$HOME") > "$tmp"
  mv "$tmp" "${pdf_cache}"
}

[[ ! -f "${pdf_cache}" ]] && build_cache

pdf_names=()
pdf_paths=()
while IFS=$'\t' read -r display path; do
  if [[ "$1" != "hidden" ]] && [[ "$path" =~ (^|/)\. ]]; then
    continue
  fi
  pdf_names+=("$display")
  pdf_paths+=("$path")
done < "${pdf_cache}"

REFRESH_LABEL="Refresh"

selected_pdf=$(
  { echo "$REFRESH_LABEL"; printf "%s\n" "${pdf_names[@]}"; } \
  | rofi -dmenu -i -matching fuzzy \
    -show-icons \
    -theme-str "${font_override}" \
    -theme-str "${i_override}" \
    -theme-str "${r_override}" \
    -theme "${rofi_config}"
)

[[ -z "$selected_pdf" ]] && exit 0

if [[ "$selected_pdf" == "$REFRESH_LABEL" ]]; then
  build_cache
  exec "$0" "$@"
fi

for i in "${!pdf_names[@]}"; do
  if [[ "${pdf_names[$i]}" == "$selected_pdf" ]]; then
    xdg-open "${pdf_paths[$i]}" &
    break
  fi
done
