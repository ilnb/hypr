#!/usr/bin/env bash

data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/end4"
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/end4"
glyph_data="${data_dir}/glyph.db"
recent_data="${cache_dir}/show_glyph.recent"

hypr_border="$(hyprctl -j getoption decoration:rounding 2>/dev/null | jq '.int' || echo 0)"
hypr_width="$(hyprctl -j getoption general:border_size 2>/dev/null | jq '.int' || echo 2)"

get_rofi_pos() {
  readarray -t curPos < <(hyprctl cursorpos -j | jq -r '.x,.y')
  eval "$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) |
    "monRes=(\(.width) \(.height) \(.scale) \(.x) \(.y)) offRes=(\(.reserved | join(" ")))"')"
  monRes[2]="${monRes[2]//./}"
  monRes[0]=$((monRes[0] * 100 / monRes[2]))
  monRes[1]=$((monRes[1] * 100 / monRes[2]))
  curPos[0]=$((curPos[0] - monRes[3]))
  curPos[1]=$((curPos[1] - monRes[4]))

  if [ "${curPos[0]}" -ge "$((monRes[0] / 2))" ]; then
    local x_pos="east"
    local x_off="-$((monRes[0] - curPos[0] - offRes[2]))"
  else
    local x_pos="west"
    local x_off="$((curPos[0] - offRes[0]))"
  fi

  if [ "${curPos[1]}" -ge "$((monRes[1] / 2))" ]; then
    local y_pos="south"
    local y_off="-$((monRes[1] - curPos[1] - offRes[3]))"
  else
    local y_pos="north"
    local y_off="$((curPos[1] - offRes[1]))"
  fi

  echo "window{location:${x_pos} ${y_pos};anchor:${x_pos} ${y_pos};x-offset:${x_off}px;y-offset:${y_off}px;}"
}

get_font() {
  local font
  font=$(hyprctl -j getoption misc:font_family 2>/dev/null | jq -r '.str // empty')
  [[ -z "$font" ]] && font=$(gsettings get org.gnome.desktop.interface font-name 2>/dev/null | tr -d "'")
  echo "${font:-"JetBrainsMono Nerd Font"}"
}

is_valid_glyph() {
  local glyph="$1"
  [[ -z "${glyph}" || -z "${unique_entries}" ]] && return 1
  [[ $'\n'"${unique_entries}"$'\n' == *$'\n'"${glyph}"$'\n'* ]]
}

save_recent() {
  is_valid_glyph "${data_glyph}" || return 0
  awk -v var="$data_glyph" 'BEGIN{print var} {print}' "${recent_data}" > temp && mv temp "${recent_data}"
  awk 'NF' "${recent_data}" | awk '!seen[$0]++' > temp && mv temp "${recent_data}"
}

setup_rofi_config() {
  local font_scale="${ROFI_GLYPH_SCALE}"
  [[ "${font_scale}" =~ ^[0-9]+$ ]] || font_scale=${ROFI_SCALE:-10}

  local font_name="${ROFI_GLYPH_FONT:-${ROFI_FONT:-$(get_font)}}"
  font_override="* {font: \"${font_name} ${font_scale}\";}"

  local wind_border=$((hypr_border * 3 / 2))
  local elem_border=$((hypr_border == 0 ? 5 : hypr_border))

  rofi_position=$(get_rofi_pos)
  r_override="window{border:${hypr_width}px;border-radius:${wind_border}px;}wallbox{border-radius:${elem_border}px;} element{border-radius:${elem_border}px;}"
}

get_glyph_selection() {
  echo "${unique_entries}" | rofi -dmenu -multi-select -i \
    -theme-str "entry { placeholder: \" 🔣 Glyph\";} ${rofi_position}" \
    -theme-str "${font_override}" \
    -theme-str "${r_override}" \
    -theme "${ROFI_GLYPH_STYLE:-clipboard}"
}

main() {
  mkdir -p "${data_dir}" "${cache_dir}"

  if [[ ! -f "${recent_data}" ]]; then
    printf "\tArch linux - I use Arch, BTW" > "${recent_data}"
  fi

  if [[ ! -f "${glyph_data}" ]]; then
    echo "glyph.db not found, downloading..."
    mkdir -p "${data_dir}"
    curl -L https://raw.githubusercontent.com/HyDE-Project/HyDE/main/Configs/.local/share/hyde/glyph.db -o "${glyph_data}" || { echo "Error: failed to download glyph.db"; exit 1; }
  fi

  local recent_entries main_entries
  recent_entries=$(cat "${recent_data}")
  main_entries=$(cat "${glyph_data}")

  combined_entries="${recent_entries}\n${main_entries}"
  unique_entries=$(echo -e "${combined_entries}" | awk '!seen[$0]++')

  setup_rofi_config

  data_glyph=$(get_glyph_selection)

  is_valid_glyph "${data_glyph}" || exit 0

  local sel_glyphs
  sel_glyphs=$(echo "${data_glyph}" | cut -d$'\t' -f1 | tr -d '\n\r')
  wl-copy "${sel_glyphs}"
}

trap save_recent EXIT
main "$@"
