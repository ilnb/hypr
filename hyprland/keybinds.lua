Hypr.mainMod = 'SUPER'
local mm = Hypr.mainMod

local bind = hl.bind
local dsp = hl.dsp
local exec = dsp.exec_cmd
---@param str string
local qs_dsp = function(str)
  return dsp.global('quickshell:' .. str)
end

-- SHELL
bind(mm .. '+Super_L', qs_dsp 'searchToggleRelease', { release = true, desc = 'Toggle search' })
bind(mm .. '+Super_L', exec 'qs -c ii ipc call TEST_ALIVE || pkill fuzzel || fuzzel')
bind(mm .. '+Super_R', qs_dsp 'searchToggleRelease', { release = true })
bind(mm .. '+Super_R', exec 'qs -c ii ipc call TEST_ALIVE || pkill fuzzel || fuzzel')
-- local x = bind(mm, qs_dsp 'searchToggleReleaseInterrupt', { transparent = true, ignore_mods = true, non_consuming = true })
-- x.catchall = true
for _, k in ipairs {
  'CTRL+Super_L',
  'CTRL+Super_R',
  mm .. '+mouse_up',
  mm .. '+mouse_down'
} do
  bind(k, qs_dsp 'searchToggleReleaseInterrupt')
end
for n = 272, 277 do
  bind(mm .. '+mouse:' .. n, qs_dsp 'searchToggleReleaseInterrupt', { mouse = true })
end

bind('Super_L', qs_dsp 'workspaceNumber', { transparent = true })
bind('Super_R', qs_dsp 'workspaceNumber', { transparent = true })
bind(mm .. '+Tab', qs_dsp 'overviewWorkspacesToggle', { desc = 'Toggle overview' })
bind(mm .. '+A', qs_dsp 'sidebarLeftToggle', { desc = 'Toggle left sidebar' })
bind(mm .. '+ALT+A', qs_dsp 'sidebarLeftToggleDetach')
bind(mm .. '+N', qs_dsp 'sidebarRightToggle', { desc = 'Toggle right sidebar' })
-- bind(mm .. '+slash', qs_dsp 'cheatsheetToggle', { desc = 'Toggle cheatsheet' })
bind(mm .. '+SHIFT+K', qs_dsp 'oskToggle', { desc = 'Toggle on-screen keyboard' })
bind(mm .. '+M', qs_dsp 'mediaControlsToggle', { desc = 'Toggle media controls' })
bind(mm .. '+G', qs_dsp 'overlayToggle')
bind(mm .. '+SHIFT+J', qs_dsp 'barToggle', { desc = 'Toggle bar' })
bind('CTRL+ALT+Delete', qs_dsp 'sessionToggle', { desc = 'Toggle session menu' })
bind('CTRL+ALT+Delete', exec(string.format('qs -c ii ipc call TEST_ALIVE || pkill wlogout || wlogout -p layer-shell', Hypr.qsConfig)))
bind('SHIFT+SUPER+ALT+Slash', exec 'qs -p ~/.config/quickshell/ii/welcome.qml')

bind('XF86MonBrightnessUp', exec 'qs -c ii ipc call brightness increment || brightnessctl s 5%+', { locked = true, repeating = true })
bind('XF86MonBrightnessDown', exec 'qs -c ii ipc call brightness decrement || brightnessctl s 5%-', { locked = true, repeating = true })
bind('XF86AudioRaiseVolume', exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1.5', { locked = true, repeating = true })
bind('XF86AudioLowerVolume', exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-', { locked = true, repeating = true })

bind('F10', exec 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle', { desc = 'Toggle audio mute', locked = true })
bind('ALT+XF86AudioMute', exec 'wpctl set-mute @DEFAULT_SOURCE@ toggle', { locked = true })
bind(mm .. '+ALT+M', exec 'wpctl set-mute @DEFAULT_SOURCE@ toggle', { desc = 'Toggle mic', locked = true })
bind(mm .. '+CTRL+T', qs_dsp 'wallpaperSelectorToggle', { desc = 'Toggle wallpaper selector' })
bind(mm .. '+CTRL+T', exec 'qs -c ii ipc call TEST_ALIVE || ~/.config/quickshell/ii/scripts/colors/switchwall.sh')
bind(mm .. '+CTRL+ALT+T', qs_dsp 'wallpaperSelectorRandom', { desc = 'Select random wallpaper' })
bind(mm .. '+CTRL+R', exec 'killall ags qgsv1 gjs ydotool qs quickshell; qs -c ii', { desc = 'Restart Widgets' })

-- UTILS
bind(mm .. '+V', qs_dsp 'overviewClipboardToggle', { desc = 'Clipboard history >> clipboard' })
bind(mm .. '+V', exec 'qs -c ii ipc call TEST_ALIVE || pkill fuzzel || cliphist list | fuzzel --match-mode fzf --dmenu | cliphist decode | wl-copy')
bind(mm .. '+Period', qs_dsp 'overviewEmojiToggle', { desc = 'Emoji >> clipboard' })
bind(mm .. '+Period', exec 'qs -c ii ipc call TEST_ALIVE || pkill fuzzel || ~/.config/hypr/hyprland/scripts/fuzzel-emoji.sh copy')

-- OCR
bind(mm .. '+SHIFT+A', qs_dsp 'regionSearch', { desc = 'Google Lens' })
bind(mm .. '+SHIFT+A', exec 'exec, qs -c ii ipc call TEST_ALIVE || pidof slurp || ~/.config/hypr/hyprland/scripts/snip_to_search.sh')
bind(mm .. '+SHIFT+X', qs_dsp 'regionOcr', { desc = 'OCR >> clipboard' })
bind(mm .. '+SHIFT+X',
  exec [[qs -c ii ipc call TEST_ALIVE || pidof slurp || grim -g "$(slurp $SLURP_ARGS)" "/tmp/ocr_image.png" && tesseract "/tmp/ocr_image.png" stdout -l $(tesseract --list-langs | awk 'NR>1{print $1}' | tr '\\n' '+' | sed 's/\\+$/\\n/') | wl-copy && rm "/tmp/ocr_image.png"]])
-- Color picker
bind(mm .. '+CTRL+P', exec 'hyprpicker -a', { desc = 'Color picker' })
-- Screenshot
bind('Print', exec 'grim - | wl-copy', { desc = 'Screenshot >> clipboard', locked = true })
bind(mm .. '+SHIFT+S', qs_dsp 'regionScreenshot', { desc = 'Screen snip' })
bind(mm .. '+SHIFT+S', exec 'qs -c ii ipc call TEST_ALIVE || pidof slurp || hyprshot --freeze --clipboard-only --mode region --silent')
bind('CTRL+Print',
  exec [[mkdir -p $(xdg-user-dir PICTURES)/Screenshots && grim $(xdg-user-dir PICTURES)/Screenshots/Screenshot_"$(date '+%Y-%m-%d_%H.%M.%S')".png]],
  { desc = 'Screenshot >> clipboard & file', locked = true, non_consuming = true })
bind('CTRL+Print', exec 'grim - | wl-copy', { locked = true, non_consuming = true })
-- Recording stuff
bind(mm .. '+SHIFT+R', qs_dsp 'regionRecord', { desc = 'Record region (no sound)', locked = true })
bind(mm .. '+SHIFT+R', exec 'qs -c ii ipc call TEST_ALIVE || ~/.config/quickshell/ii/scripts/videos/record.sh', { locked = true })
bind(mm .. '+ALT+R', qs_dsp 'regionRecord', { locked = true })
bind(mm .. '+ALT+R', exec 'qs -c ii ipc call TEST_ALIVE || ~/.config/quickshell/ii/scripts/videos/record.sh', { locked = true })
bind('CTRL+ALT+R', exec '~/.config/quickshell/ii/scripts/videos/record.sh --fullscreen', { desc = 'Record fullscreen (no sound)', locked = true })
bind(mm .. '+SHIFT+ALT+R', exec '~/.config/quickshell/ii/scripts/videos/record.sh --fullscreen --sound', { desc = 'Record fullscreen', locked = true })
bind(mm .. '+SHIFT+ALT+mouse:273',
  exec '~/.config/hypr/hyprland/scripts/ai/primary-buffer-query.sh',
  { desc = 'Generate AI summary for selected text' })

-- WINDOW
-- focusing
bind(mm .. '+mouse:272', dsp.window.move, { desc = 'Move window', mouse = true })
bind(mm .. '+mouse:274', dsp.window.move, { mouse = true })
bind(mm .. '+mouse:273', dsp.window.resize, { desc = 'Resize window', mouse = true })
for _, key in ipairs { 'left', 'right', 'up', 'down' } do
  bind(mm .. '+' .. key, dsp.focus { direction = key })
end
bind(mm .. '+Q', dsp.window.close(), { desc = 'Close' })
bind(mm .. '+SHIFT+Q', dsp.window.kill(), { desc = 'Forcefully zap a window' })

-- split ratio
bind(mm .. '+Apostrophe', dsp.layout 'splitratio +0.1', { desc = 'Adjust split +x/+y', repeating = true })
bind(mm .. '+Semicolon', dsp.layout 'splitratio -0.1', { desc = 'Adjust split -x/-y', repeating = true })
bind(mm .. '+ALT+Space', dsp.window.float { action = 'toggle' }, { desc = 'Float' })
bind(mm .. '+X', dsp.window.fullscreen { action = 'toggle', mode = 'maximized' }, { desc = 'Maximize' })
bind('ALT+Return', dsp.window.fullscreen { action = 'toggle', mode = 'fullscreen' }, { desc = 'Fullscreen' })

for n = 1, 10 do
  local i = n == 10 and 0 or n
  bind(mm .. '+ALT+' .. i, exec(Hypr.hypr_scripts .. '/workspace_action.sh movetoworkspacesilent ' .. i))
end

bind(mm .. '+ALT+S', dsp.window.move { workspace = 'special:scratchpad' }, { desc = 'Send to scratchpad' })
bind(mm .. '+S', dsp.workspace.toggle_special 'scratchpad', { desc = 'Toggle scratchpad' })

-- WORKSPACE
-- Switching
for n = 1, 10 do
  local i = n == 10 and 0 or n
  bind(mm .. '+' .. i, exec(Hypr.hypr_scripts .. '/workspace_action.sh workspace' .. i))
end

-- VM
bind(mm .. '+ALT+F1', exec [[notify-send 'Entered Virtual Machine submap' 'Keybinds disabled. Hit Super+ALT+F1 to escape' -a 'Hyprland']],
  { desc = 'Disable keybinds' })
bind(mm .. '+ALT+F1', exec [[hyprctl dispatch "hl.dsp.submap 'virtual-machine'"]])

hl.define_submap('virtual-machine', function()
  bind(mm .. '+ALT+F1', exec [[notify-send 'Exited Virtual Machine submap' 'Keybinds re-enabled' -a 'Hyprland']], { desc = 'Enable keybinds' })
  bind(mm .. '+ALT+F1', exec [[hyprctl dispatch "hl.dsp.submap 'global'"]])
end)

-- Session
bind(mm .. '+SHIFT+L', exec 'loginctl lock-session', { desc = 'Lock' })
bind(mm .. '+ALT+L', exec 'systemctl suspend || loginctl suspend', { desc = 'Sleep', locked = true })
bind(mm .. '+CTRL+SHIFT+ALT+Delete', exec 'systemctl poweroff || loginctl poweroff', { desc = 'Power off' })

-- SCREEN
-- Zoom
bind(mm .. '+Minus', exec '~/.config/hypr/hyprland/scripts/zoom.sh decrease 0.3', { desc = 'Zoom out', repeating = true })
-- bind(mm .. '+code:82', exec '~/.config/hypr/hyprland/scripts/zoom.sh decrease 0.3', { repeating = true })
bind(mm .. '+Plus', exec '~/.config/hypr/hyprland/scripts/zoom.sh increase 0.3', { desc = 'Zoom in', repeating = true })
-- bind(mm .. '+code:86', exec '~/.config/hypr/hyprland/scripts/zoom.sh increase 0.3', { repeating = true })

-- MEDIA
bind(mm .. '+SHIFT+N',
  exec [[playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`]],
  { desc = 'Next track', locked = true })
bind('XF86AudioNext',
  exec [[playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`]],
  { locked = true })
bind(mm .. '+SHIFT+P', exec 'playerctl previous', { desc = 'Previous track', locked = true })
bind('XF86AudioPrev', exec 'playerctl previous', { locked = true })
bind(mm .. '+SHIFT+Space', exec 'playerctl play-pause', { desc = 'Play/pause', locked = true })
bind('XF86AudioPlay', exec 'playerctl play-pause', { locked = true })
bind('XF86AudioPause', exec 'playerctl play-pause', { locked = true })

-- APPS
bind('CTRL+ALT+T', exec 'kitty')
bind(mm .. '+T', exec(Hypr.terminal), { desc = 'Terminal' })
bind(mm .. '+E', exec(Hypr.hypr_scripts .. [[/launch_first_available.sh "dolphin" "nautilus" "nemo" "thunar" "kitty"]]), { desc = 'File manager' })
bind(mm .. '+CTRL+V', exec(Hypr.hypr_scripts .. [[/launch_first_available.sh "pavucontrol-qt" "pavucontrol"]]), { desc = 'Volume mixer' })
bind('CTRL+SHIFT+Escape', exec(Hypr.hypr_scripts .. '/scripts/launch_first_available.sh'
    .. [["gnome-system-monitor" "plasma-systemmonitor --page-name Processes" "command -v btop && wezterm start btop"]]),
  { desc = 'System monitor' })

-- MISC
bind(mm .. '+CTRL+Backslash', dsp.window.resize { x = 640, y = 480 })
