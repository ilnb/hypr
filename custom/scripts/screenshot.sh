#!/usr/bin/env bash

USAGE() {
  cat <<USAGE
Usage: $(basename "$0") [option]
Options:
  p     Print all outputs
  s     Select area or window to screenshot
  sf    Select area or window with frozen screen
  m     Screenshot focused monitor
  sc    Use tesseract to scan image, then add to clipboard
USAGE
}

pkg_installed() {
  command -v "$1" &>/dev/null || \
  (command -v flatpak &>/dev/null && flatpak info "$1" &>/dev/null)
}

check_package() {
  for pkg in "$@"; do
    pkg_installed "$pkg" || { echo "Error: '$pkg' is not installed."; exit 1; }
  done
}

notify() {
  notify-send -a "Screenshot" "$@"
}

SCREENSHOT_PRE_COMMAND=("export XCURSOR_SIZE=20")
SCREENSHOT_POST_COMMAND=()

pre_cmd() {
  for cmd in "${SCREENSHOT_PRE_COMMAND[@]}"; do eval "$cmd"; done
  trap 'post_cmd' EXIT
}

post_cmd() {
  for cmd in "${SCREENSHOT_POST_COMMAND[@]}"; do eval "$cmd"; done
}

temp_screenshot=$(mktemp -t screenshot_XXXXXX.png)
XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
save_dir="${2:-$XDG_PICTURES_DIR/Screenshots}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
mkdir -p "$save_dir"

annotation_tool="${SCREENSHOT_ANNOTATION_TOOL}"
annotation_args=("-o" "${save_dir}/${save_file}" "-f" "${temp_screenshot}")

if [[ -z "$annotation_tool" ]]; then
  pkg_installed "swappy" && annotation_tool="swappy"
  pkg_installed "satty"  && annotation_tool="satty"
fi

if [[ "$annotation_tool" == "swappy" ]]; then
  swpy_dir="${XDG_CONFIG_HOME}/swappy"
  mkdir -p "$swpy_dir"
  echo -e "[Default]\nsave_dir=$save_dir\nsave_filename_format=$save_file" > "${swpy_dir}/config"
fi

[[ "$annotation_tool" == "satty" ]] && annotation_args+=("--copy-command" "wl-copy")
[[ -n "${SCREENSHOT_ANNOTATION_ARGS[*]}" ]] && annotation_args+=("${SCREENSHOT_ANNOTATION_ARGS[@]}")

grimblast="$(command -v grimblast)"
[[ -z "$grimblast" ]] && { echo "Error: grimblast not found."; exit 1; }

take_screenshot() {
  local mode=$1; shift
  local extra_args=("$@")

  if "$grimblast" "${extra_args[@]}" copysave "$mode" "$temp_screenshot"; then
    "${annotation_tool}" "${annotation_args[@]}" || \
      { notify "Screenshot Error" "Failed to open annotation tool"; return 1; }
  else
    notify "Screenshot Error" "Failed to take screenshot"
    return 1
  fi
}

pre_cmd

case $1 in
  p)  take_screenshot "screen" ;;
  s)  take_screenshot "area" ;;
  sf) take_screenshot "area" "--freeze" ;;
  m)  take_screenshot "output" ;;
  sc)
    check_package tesseract tesseract-data-eng
    if ! GEOM=$(slurp); then
      notify "OCR Error" "Invalid geometry"
      exit 1
    fi
    grim -g "${GEOM}" "${temp_screenshot}"
    pkg_installed imagemagick && magick "${temp_screenshot}" -sigmoidal-contrast 10,50% "${temp_screenshot}"
    tesseract "${temp_screenshot}" - | wl-copy
    notify "OCR preview" -i "${temp_screenshot}" -e
    rm -f "${temp_screenshot}"
    ;;
  *) USAGE ;;
esac

if [[ -f "${save_dir}/${save_file}" ]]; then
  notify "Saved in ${save_dir}" -i "${save_dir}/${save_file}"
fi
