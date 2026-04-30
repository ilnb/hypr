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
bind(mm .. '+SUPER_L', function()
  qs_dsp 'searchToggleRelease'
  exec 'qs -c ii ipc call TEST_ALIVE || pkill fuzzel || fuzzel'
end, { ignore_mods = true, desc = 'Toggle search' })

bind(mm .. '+SUPER_R', function()
  qs_dsp 'searchToggleRelease'
  exec 'qs -c ii ipc call TEST_ALIVE || pkill fuzzel || fuzzel'
end, { ignore_mods = true })

bind(mm .. '+catchall', qs_dsp 'searchToggleReleaseInterrupt', { transparent = true, ignore_mods = true, non_consuming = true })
for _, k in ipairs {
  'Ctrl+Super_L',
  'Ctrl+Super_R',
  mm .. '+mouse_up',
  mm .. '+mouse_down'
} do
  bind(k, qs_dsp 'searchToggleReleaseInterrupt')
end
for n = 272, 277 do
  bind(mm .. '+mouse:' .. n, qs_dsp 'searchToggleReleaseInterrupt')
end

bind('Super_L', qs_dsp 'workspaceNumber', { transparent = true })
bind('Super_R', qs_dsp 'workspaceNumber', { transparent = true })
bind(mm .. '+Tab', qs_dsp 'overviewWorkspacesToggle', { desc = 'Toggle overview' })
bind(mm .. '+A', qs_dsp 'sidebarLeftToggle', { desc = 'Toggle left sidebar' })
bind(mm .. '+Alt+A', qs_dsp 'sidebarLeftToggleDetach')
bind(mm .. '+N', qs_dsp 'sidebarRightToggle', { desc = 'Toggle right sidebar' })
-- bind(mm .. '+slash', qs_dsp 'cheatsheetToggle', { desc = 'Toggle cheatsheet' })
bind(mm .. '+Shift+K', qs_dsp 'oskToggle', { desc = 'Toggle on-screen keyboard' })
bind(mm .. '+M', qs_dsp 'mediaControlsToggle', { desc = 'Toggle media controls' })
bind(mm .. '+G', qs_dsp 'overlayToggle')
bind(mm .. '+Shift+J', qs_dsp 'barToggle', { desc = 'Toggle bar' })
bind('Ctrl+Alt+Delete', function()
  qs_dsp 'sessionToggle'
  exec(string.format('qs -c ii ipc call TEST_ALIVE || pkill wlogout || wlogout -p layer-shell', Hypr.qsConfig))
end, { desc = 'Toggle session menu' })
bind('Shift+Super+Alt+Slash', exec 'qs -p ~/.config/quickshell/ii/welcome.qml')

bind('XF86MonBrightnessUp', exec 'qs -c ii ipc call brightness increment || brightnessctl s 5%+', { locked = true, repeating = true })
bind('XF86MonBrightnessDown', exec 'qs -c ii ipc call brightness decrement || brightnessctl s 5%-', { locked = true, repeating = true })
bind('XF86AudioRaiseVolume', exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1.5', { locked = true, repeating = true })
bind('XF86AudioLowerVolume', exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-', { locked = true, repeating = true })

bind('F10', exec 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle', { desc = 'Toggle audio mute', locked = true })
bind('Alt+XF86AudioMute', exec 'wpctl set-mute @DEFAULT_SOURCE@ toggle', { locked = true })
bind(mm .. '+Alt+M', exec 'wpctl set-mute @DEFAULT_SOURCE@ toggle', { desc = 'Toggle mic', locked = true })

bind(mm .. '+Ctrl+T', function()
  qs_dsp 'wallpaperSelectorToggle'
  exec 'qs -c ii ipc call TEST_ALIVE || ~/.config/quickshell/ii/scripts/colors/switchwall.sh'
end, { desc = 'Toggle wallpaper selector' })
bind(mm .. '+Ctrl+Alt+T', qs_dsp 'wallpaperSelectorRandom', { desc = 'Select random wallpaper' })
bind(mm .. '+Ctrl+R', exec 'killall ags qgsv1 gjs ydotool qs quickshell; qs -c ii', { desc = 'Restart Widgets' })

-- UTILS
bind(mm .. '+V', function()
  qs_dsp 'overviewClipboardToggle'
  exec 'qs -c ii ipc call TEST_ALIVE || pkill fuzzel || cliphist list | fuzzel --match-mode fzf --dmenu | cliphist decode | wl-copy'
end, { desc = 'Clipboard history >> clipboard' })
bind(mm .. '+Period', function()
  qs_dsp 'overviewEmojiToggle'
  exec 'qs -c ii ipc call TEST_ALIVE || pkill fuzzel || ~/.config/hypr/hyprland/scripts/fuzzel-emoji.sh copy'
end, { desc = 'Emoji >> clipboard' })
-- OCR
bind(mm .. '+Shift+A', function()
  qs_dsp 'regionSearch'
  exec 'exec, qs -c ii ipc call TEST_ALIVE || pidof slurp || ~/.config/hypr/hyprland/scripts/snip_to_search.sh'
end, { desc = 'Google Lens' })
bind(mm .. '+Shift+X', function()
  qs_dsp 'regionOcr'
  exec [[qs -c ii ipc call TEST_ALIVE || pidof slurp || grim -g "$(slurp $SLURP_ARGS)" "/tmp/ocr_image.png" && tesseract "/tmp/ocr_image.png" stdout -l $(tesseract --list-langs | awk 'NR>1{print $1}' | tr '\\n' '+' | sed 's/\\+$/\\n/') | wl-copy && rm "/tmp/ocr_image.png"]]
end, { desc = 'OCR >> clipboard' })
-- Color picker
bind(mm .. '+Ctrl+P', exec 'hyprpicker -a', { desc = 'Color picker' })
-- Screenshot
bind('Print', exec 'grim - | wl-copy', { desc = 'Screenshot >> clipboard', locked = true })
bind(mm .. '+Shift+S', function()
  qs_dsp 'regionScreenshot'
  exec 'qs -c ii ipc call TEST_ALIVE || pidof slurp || hyprshot --freeze --clipboard-only --mode region --silent'
end, { desc = 'Screen snip' })
bind('Ctrl+Print', function()
  exec [[mkdir -p $(xdg-user-dir PICTURES)/Screenshots && grim $(xdg-user-dir PICTURES)/Screenshots/Screenshot_"$(date '+%Y-%m-%d_%H.%M.%S')".png]]
  exec 'grim - | wl-copy'
end, { desc = 'Screenshot >> clipboard & file', locked = true, non_consuming = true })
-- Recording stuff
bind(mm .. '+Shift+R', function()
  qs_dsp 'regionRecord'
  exec 'qs -c ii ipc call TEST_ALIVE || ~/.config/quickshell/ii/scripts/videos/record.sh'
end, { desc = 'Record region (no sound)', locked = true })
bind(mm .. '+Alt+R', function()
  qs_dsp 'regionRecord'
  exec 'qs -c ii ipc call TEST_ALIVE || ~/.config/quickshell/ii/scripts/videos/record.sh'
end, { locked = true })
bind('Ctrl+Alt+R', exec '~/.config/quickshell/ii/scripts/videos/record.sh --fullscreen', { desc = 'Record fullscreen (no sound)', locked = true })
bind(mm .. '+Shift+Alt+R', exec '~/.config/quickshell/ii/scripts/videos/record.sh --fullscreen --sound', { desc = 'Record fullscreen', locked = true })
bind(mm .. '+Shift+Alt+mouse:273',
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
bind(mm .. '+Shift+Q', dsp.window.kill(), { desc = 'Forcefully zap a window' })

-- split ratio
bind(mm .. '+Apostrophe', dsp.layout 'splitratio +0.1', { desc = 'Adjust split +x/+y', repeating = true })
bind(mm .. '+Semicolon', dsp.layout 'splitratio -0.1', { desc = 'Adjust split -x/-y', repeating = true })
bind(mm .. '+Alt+Space', dsp.window.float { action = 'toggle' }, { desc = 'Float' })
bind(mm .. '+X', dsp.window.fullscreen { action = 'toggle', mode = 'maximized' }, { desc = 'Maximize' })
bind('Alt+Return', dsp.window.fullscreen { action = 'toggle', mode = 'fullscreen' }, { desc = 'Fullscreen' })

for n = 10, 19 do
  bind(mm .. '+Alt+code:' .. n, exec(Hypr.hypr_scripts .. '~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent ' .. (n - 9)))
end

bind(mm .. '+Alt+S', dsp.window.move { workspace = 'special:scratchpad' }, { desc = 'Send to scratchpad' })
bind(mm .. '+S', dsp.workspace.toggle_special 'scratchpad', { desc = 'Toggle scratchpad' })

-- WORKSPACE
-- Switching
for n = 10, 19 do
  bind(mm .. '+code:' .. n, exec(Hypr.hypr_scripts .. '/workspace_action.sh workspace' .. (n - 9)))
end

-- VM
bind(mm .. '+Alt+F1', function()
  exec [[notify-send 'Entered Virtual Machine submap' 'Keybinds disabled. Hit Super+Alt+F1 to escape' -a 'Hyprland']]
  dsp.submap 'virtual-machine'
end, { desc = 'Disable keybinds' })
hl.define_submap('virtual-machine', function()
  bind(mm .. '+Alt+F1', function()
    exec [[notify-send 'Exited Virtual Machine submap' 'Keybinds re-enabled' -a 'Hyprland']]
    dsp.submap 'reset'
  end)
end)

-- Session
bind(mm .. '+Shift+L', exec 'loginctl lock-session', { desc = 'Lock' })
bind(mm .. '+Alt+L', exec 'systemctl suspend || loginctl suspend', { desc = 'Sleep', locked = true })
bind(mm .. '+Ctrl+Shift+Alt+Delete', exec 'systemctl poweroff || loginctl poweroff', { desc = 'Power off' })

-- SCREEN
-- Zoom
bind(mm .. '+Minus', exec '~/.config/hypr/hyprland/scripts/zoom.sh decrease 0.3', { desc = 'Zoom out', repeating = true })
bind(mm .. '+code:82', exec '~/.config/hypr/hyprland/scripts/zoom.sh decrease 0.3', { repeating = true })
bind(mm .. '+Plus', exec '~/.config/hypr/hyprland/scripts/zoom.sh increase 0.3', { desc = 'Zoom in', repeating = true })
bind(mm .. '+code:86', exec '~/.config/hypr/hyprland/scripts/zoom.sh increase 0.3', { repeating = true })

-- MEDIA
bind(mm .. '+Shift+N',
  exec [[playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`]],
  { desc = 'Next track', locked = true })
bind('XF86AudioNext',
  exec [[playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`]],
  { locked = true })
bind(mm .. '+Shift+P', exec 'playerctl previous', { desc = 'Previous track', locked = true })
bind('XF86AudioPrev', exec 'playerctl previous', { locked = true })
bind(mm .. '+Shift+Space', exec 'playerctl play-pause', { desc = 'Play/pause', locked = true })
bind('XF86AudioPlay', exec 'playerctl play-pause', { locked = true })
bind('XF86AudioPause', exec 'playerctl play-pause', { locked = true })

-- APPS
bind('Ctrl+Alt+T', exec 'kitty')
bind(mm .. '+T', exec(Hypr.terminal), { desc = 'Terminal' })
bind(mm .. '+E', exec(Hypr.hypr_scripts .. [[/launch_first_available.sh "dolphin" "nautilus" "nemo" "thunar" "kitty"]]), { desc = 'File manager' })
bind(mm .. '+Ctrl+V', exec(Hypr.hypr_scripts .. [[/launch_first_available.sh "pavucontrol-qt" "pavucontrol"]]), { desc = 'Volume mixer' })
bind('Ctrl+Shift+Escape', exec(Hypr.hypr_scripts .. '/scripts/launch_first_available.sh'
    .. [["gnome-system-monitor" "plasma-systemmonitor --page-name Processes" "command -v btop && wezterm start btop"]]),
  { desc = 'System monitor' })

-- MISC
bind(mm .. '+Ctrl+Backslash', dsp.window.resize { 640, 480 })
