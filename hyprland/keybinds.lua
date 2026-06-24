local mm = Hypr.mainMod

local bind = hl.bind
local dsp = hl.dsp
local exec = dsp.exec_cmd
---@param str string
local qs_dsp = function(str)
  return dsp.global('quickshell:' .. str)
end
---@param d HL.Dispatcher
local run = function(d)
  hl.dispatch(d)
end

-- SHELL
bind(mm .. '+Super_L', function()
  run(qs_dsp 'searchToggleRelease')
  run(exec 'qs -c ii ipc call TEST_ALIVE || pkill fuzzel || fuzzel')
end, { desc = 'Shell: Toggle search' })
bind(mm .. '+Super_R', function()
  run(qs_dsp 'searchToggleRelease')
  run(exec 'qs -c ii ipc call TEST_ALIVE || pkill fuzzel || fuzzel')
end)
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

bind('Super_L', qs_dsp 'workspaceNumber', { transparent = true, ignore_mods = true })
bind('Super_R', qs_dsp 'workspaceNumber', { transparent = true, ignore_mods = true })
bind('Super_L', qs_dsp 'workspaceNumber', { transparent = true, ignore_mods = true, release = true })
bind('Super_R', qs_dsp 'workspaceNumber', { transparent = true, ignore_mods = true, release = true })
bind(mm .. '+Tab', qs_dsp 'overviewWorkspacesToggle', { desc = 'Shell: Toggle overview' })
bind(mm .. '+A', qs_dsp 'sidebarLeftToggle', { desc = 'Shell: Toggle left sidebar' })
bind(mm .. '+ALT+A', qs_dsp 'sidebarLeftToggleDetach')
bind(mm .. '+N', qs_dsp 'sidebarRightToggle', { desc = 'Shell: Toggle right sidebar' })
bind(mm .. '+slash', qs_dsp 'cheatsheetToggle', { desc = 'Shell: Toggle cheatsheet' })
bind(mm .. '+SHIFT+K', qs_dsp 'oskToggle', { desc = 'Shell: Toggle on-screen keyboard' })
bind(mm .. '+M', qs_dsp 'mediaControlsToggle', { desc = 'Shell: Toggle media controls' })
bind(mm .. '+G', qs_dsp 'overlayToggle')
bind(mm .. '+SHIFT+J', qs_dsp 'barToggle', { desc = 'Shell: Toggle bar' })
bind('CTRL+ALT+Delete', function()
  run(qs_dsp 'sessionToggle')
  run(exec 'qs -c ii ipc call TEST_ALIVE || pkill wlogout || wlogout -p layer-shell')
end, { desc = 'Shell: Toggle session menu' })
bind('SHIFT+SUPER+ALT+Slash', exec 'qs -p ~/.config/quickshell/ii/welcome.qml')

bind('XF86MonBrightnessUp', exec 'qs -c ii ipc call brightness increment || brightnessctl s 5%+', { locked = true, repeating = true })
bind('XF86MonBrightnessDown', exec 'qs -c ii ipc call brightness decrement || brightnessctl s 5%-', { locked = true, repeating = true })
bind('XF86AudioRaiseVolume', exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1.5', { locked = true, repeating = true })
bind('XF86AudioLowerVolume', exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-', { locked = true, repeating = true })

bind('F10', exec 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle', { desc = 'Shell: Toggle audio mute', locked = true })
bind('ALT+XF86AudioMute', exec 'wpctl set-mute @DEFAULT_SOURCE@ toggle', { locked = true })
bind(mm .. '+ALT+M', exec 'wpctl set-mute @DEFAULT_SOURCE@ toggle', { desc = 'Shell: Toggle mic', locked = true })
bind(mm .. '+CTRL+T', function()
  run(qs_dsp 'wallpaperSelectorToggle')
  run(exec 'qs -c ii ipc call TEST_ALIVE || ~/.config/quickshell/ii/scripts/colors/switchwall.sh')
end, { desc = 'Shell: Toggle wallpaper selector' })
bind(mm .. '+CTRL+ALT+T', qs_dsp 'wallpaperSelectorRandom', { desc = 'Shell: Select random wallpaper' })
bind(mm .. '+CTRL+R', exec 'killall ags qgsv1 gjs ydotool qs quickshell; qs -c ii', { desc = 'Shell: Restart Widgets' })

-- WORKSPACE
-- Switching
local numpad = { 87, 88, 89, 83, 84, 85, 79, 80, 81, [0] = 90 }
for n = 1, 10 do
  local i = n % 10
  bind(mm .. '+' .. i, dsp.focus { workspace = n })
  bind(mm .. '+code:' .. numpad[i], dsp.focus { workspace = n })
end

-- VM
hl.define_submap('virtual-machine', function()
  bind(mm .. '+ALT+F1', function()
    local curr = hl.get_current_submap()
    if curr == 'virtual-machine' then
      run(exec "notify-send 'Exited Virtual Machine submap' 'Keybinds re-enabled' -a 'Hyprland'")
      run(dsp.submap 'reset')
    elseif curr == '' then
      run(exec "notify-send 'Entered Virtual Machine submap' 'Keybinds disabled. Hit SUPER+ALT+F1 to escape' -a 'Hyprland'")
      run(dsp.submap 'virtual-machine')
    end
  end, { submap_universal = true, desc = 'Workspace: Enter VM' })
end)

-- Session
bind(mm .. '+SHIFT+L', exec 'loginctl lock-session', { desc = 'Session: Lock' })
bind(mm .. '+ALT+L', exec 'systemctl suspend || loginctl suspend', { desc = 'Session: Sleep', locked = true })
bind(mm .. '+CTRL+SHIFT+ALT+Delete', exec 'systemctl poweroff || loginctl poweroff', { desc = 'Session: Power off' })

-- UTILS
bind(mm .. '+V', function()
  run(qs_dsp 'overviewClipboardToggle')
  run(exec 'qs -c ii ipc call TEST_ALIVE || pkill fuzzel || cliphist list | fuzzel --match-mode fzf --dmenu | cliphist decode | wl-copy')
end, { desc = 'Utilities: Clipboard history >> clipboard' })
bind(mm .. '+Period', function()
  run(qs_dsp 'overviewEmojiToggle')
  run(exec 'qs -c ii ipc call TEST_ALIVE || pkill fuzzel || ~/.config/hypr/hyprland/scripts/fuzzel-emoji.sh copy')
end, { desc = 'Utilities: Emoji >> clipboard' })
-- OCR
bind(mm .. '+SHIFT+A', function()
  run(qs_dsp 'regionSearch')
  run(exec 'qs -c ii ipc call TEST_ALIVE || pidof slurp || ~/.config/hypr/hyprland/scripts/snip_to_search.sh')
end, { desc = 'Utilities: Google Lens' })
bind(mm .. '+SHIFT+X', function()
  run(qs_dsp 'regionOcr')
  run(exec [[qs -c ii ipc call TEST_ALIVE || pidof slurp || grim -g "$(slurp $SLURP_ARGS)]])
end, { desc = 'Utilities: OCR >> clipboard' })
-- Color picker
bind(mm .. '+CTRL+P', exec 'hyprpicker -a', { desc = 'Utilities: Color picker' })
-- Screenshot
bind('Print', exec 'grim - | wl-copy', { desc = 'Utilities: Screenshot >> clipboard', locked = true })
bind(mm .. '+SHIFT+S', function()
  run(qs_dsp 'regionScreenshot')
  run(exec 'qs -c ii ipc call TEST_ALIVE || pidof slurp || hyprshot --freeze --clipboard-only --mode region --silent')
end, { desc = 'Utilities: Screen snip' })
bind('CTRL+Print', function()
  run(exec [[mkdir -p $(xdg-user-dir PICTURES)/Screenshots && grim $(xdg-user-dir PICTURES)/Screenshots/Screenshot_"$(date '+%Y-%m-%d_%H.%M.%S')".png]])
  run(exec 'grim - | wl-copy')
end, { desc = 'Utilities: Screenshot >> clipboard & file', locked = true, non_consuming = true })
-- Recording stuff
bind(mm .. '+SHIFT+R', function()
  run(qs_dsp 'regionRecord')
  run(exec 'qs -c ii ipc call TEST_ALIVE || ~/.config/quickshell/ii/scripts/videos/record.sh')
end, { desc = 'Utilities: Record region (no sound)', locked = true })
bind(mm .. '+ALT+R', function()
  run(qs_dsp 'regionRecord')
  run(exec 'qs -c ii ipc call TEST_ALIVE || ~/.config/quickshell/ii/scripts/videos/record.sh')
end, { locked = true })
bind(mm .. '+R', exec '~/.config/quickshell/ii/scripts/videos/record.sh --fullscreen',
  { desc = 'Utilities: Record fullscreen (no sound)', locked = true })
bind(mm .. '+SHIFT+ALT+R', exec '~/.config/quickshell/ii/scripts/videos/record.sh --fullscreen --sound',
  { desc = 'Utilities: Record fullscreen', locked = true })
bind(mm .. '+SHIFT+ALT+mouse:273', exec(Hypr.hypr_scripts .. '/ai/primary-buffer-query.sh'), { desc = 'Utilities: Generate AI summary' })

-- MEDIA
bind(mm .. '+SHIFT+N',
  exec [[playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`]],
  { desc = 'Media: Next track', locked = true })
bind('XF86AudioNext',
  exec [[playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`]],
  { locked = true })
bind(mm .. '+SHIFT+P', exec 'playerctl previous', { desc = 'Media: Previous track', locked = true })
bind('XF86AudioPrev', exec 'playerctl previous', { locked = true })
bind(mm .. '+SHIFT+Space', exec 'playerctl play-pause', { desc = 'Media: Play/pause', locked = true })
bind('XF86AudioPlay', exec 'playerctl play-pause', { locked = true })
bind('XF86AudioPause', exec 'playerctl play-pause', { locked = true })

-- WINDOW
-- Focusing
bind(mm .. '+mouse:272', dsp.window.drag(), { desc = 'Window: Drag window', mouse = true })
bind(mm .. '+mouse:274', dsp.window.drag(), { mouse = true })
bind(mm .. '+mouse:273', dsp.window.resize(), { desc = 'Window: Resize window', mouse = true })
for _, key in ipairs { 'left', 'right', 'up', 'down' } do
  bind(mm .. '+' .. key, dsp.focus { direction = key })
end
bind(mm .. '+Q', dsp.window.close(), { desc = 'Window: Close' })
bind(mm .. '+SHIFT+Q', dsp.window.kill(), { desc = 'Window: Forcefully zap a window' })

-- Split ratio
bind(mm .. '+Apostrophe', dsp.layout 'splitratio +0.1', { desc = 'Window: Adjust split +x/+y', repeating = true })
bind(mm .. '+Semicolon', dsp.layout 'splitratio -0.1', { desc = 'Window: Adjust split -x/-y', repeating = true })
bind(mm .. '+ALT+Space', dsp.window.float { action = 'toggle' }, { desc = 'Window: Float' })
bind(mm .. '+X', dsp.window.fullscreen { action = 'toggle', mode = 'maximized' }, { desc = 'Window: Maximize' })
bind('ALT+Return', dsp.window.fullscreen { action = 'toggle', mode = 'fullscreen' }, { desc = 'Window: Fullscreen' })

for n = 1, 10 do
  local i = n % 10
  bind(mm .. '+ALT+' .. i, dsp.window.move { workspace = n, follow = false })
  bind(mm .. '+ALT+code:' .. numpad[i], dsp.window.move { workspace = n, follow = false })
end

bind(mm .. '+ALT+S', dsp.window.move { workspace = 'special:scratchpad', follow = false }, { desc = 'Window: Send to scratchpad' })
bind(mm .. '+CTRL+S', dsp.window.move { workspace = 'special:scratchpad', follow = true }, { desc = 'Window: Send to scratchpad (follow)' })
bind(mm .. '+S', dsp.workspace.toggle_special 'scratchpad', { desc = 'Window: Toggle scratchpad' })

-- SCREEN
---@param factor number
---@param inc boolean?
local function zoom(factor, inc)
  inc = inc and true
  local new = hl.get_config 'cursor.zoom_factor'
  if inc then
    new = new + factor
  else
    new = new - factor
  end
  if new < 1 then
    new = 1
  elseif new > 3 then
    new = 3
  end
  hl.config { cursor = { zoom_factor = new } }
end
bind(mm .. '+Minus', function() zoom(0.3) end, { desc = 'Screen: Zoom out', repeating = true })
bind(mm .. '+code:82', function() zoom(0.3) end, { repeating = true })
bind(mm .. '+Equal', function() zoom(0.3, true) end, { desc = 'Screen: Zoom in', repeating = true })
bind(mm .. '+code:86', function() zoom(0.3, true) end, { repeating = true })

-- APPS
bind('CTRL+ALT+T', exec 'kitty')
bind(mm .. '+T', exec(Hypr.terminal), { desc = 'Apps: Terminal' })
bind(mm .. '+E', exec(Hypr.hypr_scripts .. [[/launch_first_available.sh "dolphin" "nautilus" "nemo" "thunar" "kitty"]]),
  { desc = 'Apps: File manager' })
bind(mm .. '+CTRL+V', exec(Hypr.hypr_scripts .. [[/launch_first_available.sh "pavucontrol-qt" "pavucontrol"]]), { desc = 'Apps: Volume mixer' })
bind(mm .. '+I',
  exec('XDG_CURRENT_DESKTOP=gnome ' .. Hypr.hypr_scripts ..
    [[/launch_first_available.sh "qs -p ~/.config/quickshell/ii/settings.qml" "systemsettings" "gnome-control-center" "better-control"]]),
  { desc = 'Apps: Settings' })
bind('CTRL+SHIFT+Escape', exec(Hypr.hypr_scripts .. '/launch_first_available.sh '
    ..
    [["gnome-system-monitor" "plasma-systemmonitor --page-name Processes" "command -v btop && ghostty --command=btop" "command -v btop && wezterm start btop"]]),
  { desc = 'Apps: System monitor' })

-- MISC
bind(mm .. '+CTRL+Backslash', dsp.window.resize { x = 640, y = 480 })
