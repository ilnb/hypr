#!/usr/bin/env bash

DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/end4"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/end4"
PDF_CACHE="${CACHE_DIR}/PDF_CACHE.tsv"
mkdir -p "$CACHE_DIR/rofi_bg"

hypr_border="$(hyprctl -j getoption decoration:rounding 2>/dev/null | jq '.int' || echo 10)"
hypr_width="$(hyprctl -j getoption general:border_size 2>/dev/null | jq '.int' || echo 2)"

wall_path=$(jq -r '.background.wallpaperPath' ~/.config/illogical-impulse/config.json)
wall_base=$(basename "$wall_path")
wall_cached="${CACHE_DIR}/rofi_bg/${wall_base}"
if [[ ! -f "$wall_cached" ]] || [[ "$wall_path" -nt "$wall_cached" ]]; then
  magick "$wall_path" -blur 0x5 "$wall_cached"
fi
wall_override="listview { background-image: url(\"$wall_cached\", height); }"

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

elem_border=$((hypr_border * 2))
r_override="window{border:${hypr_width}px;} element{border-radius:${elem_border}px;}"

icon_theme="$(get_icon_theme)"
i_override="configuration {icon-theme: \"${icon_theme}\";}"

fd_hidden=""
[[ "$1" == "hidden" ]] && fd_hidden="-H"

build_cache() {
  mkdir -p "${CACHE_DIR}"
  local tmp
  tmp=$(mktemp)
  while IFS= read -r f; do
    local base dir display
    base=$(basename "$f")
    dir=$(dirname "$f")
    display="$([[ "$dir" == "$HOME" ]] && echo "$base" || echo "$(basename "$dir")/$base")"
    printf "%s\t%s\n" "$display" "$f"
  done < <(fd -H -t f -e pdf --full-path "$HOME") > "$tmp"
  mv "$tmp" "${PDF_CACHE}"
}

[[ ! -f "${PDF_CACHE}" ]] && build_cache

pdf_names=()
pdf_paths=()
while IFS=$'\t' read -r display path; do
  if [[ "$1" != "hidden" ]] && [[ "$path" =~ (^|/)\. ]]; then
    continue
  fi
  pdf_names+=("$display")
  pdf_paths+=("$path")
done < "${PDF_CACHE}"

REFRESH_LABEL="Refresh"

selected_pdf=$(
  { echo "$REFRESH_LABEL"; printf "%s\n" "${pdf_names[@]}"; } \
  | rofi -dmenu -i -matching fuzzy \
    -show-icons \
    -theme-str "${font_override}" \
    -theme-str "${i_override}" \
    -theme-str "${r_override}" \
    -theme-str "${wall_override}" \
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
