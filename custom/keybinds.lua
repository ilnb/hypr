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

-- WINDOW
bind(mm .. '+Backspace', qs_dsp 'sessionToggle', { desc = 'Window: Toggle session menu' })
bind(mm .. '+Delete', exec 'exit')
bind(mm .. '+W', dsp.window.float { action = 'toggle' }, { desc = 'Window: Float' })
local dirs = { H = 'l', L = 'r', K = 'u', J = 'd' }
for key, dir in pairs(dirs) do
  bind(mm .. '+' .. key, dsp.focus { direction = dir })
end
local cmd = [[grep -q "true" <<< $(hyprctl activewindow -j | jq -r .floating) && hyprctl dispatch "hl.dsp.window.move {]]
bind(mm .. '+CTRL+H', exec(cmd .. [[ -30, 0 }" || hyprctl dispatch "hl.dsp.window.move { direction = 'left' }"]]), { repeating = true })
bind(mm .. '+CTRL+L', exec(cmd .. [[ 30, 0  }" || hyprctl dispatch "hl.dsp.window.move { direction = 'right' }"]]), { repeating = true })
bind(mm .. '+CTRL+K', exec(cmd .. [[ 0, -30 }" || hyprctl dispatch "hl.dsp.window.move { direction = 'up' }"]]), { repeating = true })
bind(mm .. '+CTRL+J', exec(cmd .. [[ 0, 30  }" || hyprctl dispatch "hl.dsp.window.move{ direction = 'down' }"]]), { repeating = true })
bind(mm .. '+CTRL+ALT+L', dsp.window.move { workspace = 'r+1' }, { desc = 'Window: Move to next ws' })
bind(mm .. '+CTRL+ALT+H', dsp.window.move { workspace = 'r-1' }, { desc = 'Window: Move to prev ws' })

-- WORKSPACES
local numpad = { 87, 88, 89, 83, 84, 85, 79, 80, 81, [0] = 90 }
for n = 1, 10 do
  local i = n % 10
  bind(mm .. '+SHIFT+' .. i, dsp.window.move { workspace = n })
  bind(mm .. '+SHIFT+code:' .. numpad[i], dsp.window.move { workspace = n })
end
bind(mm .. '+ALT+N', dsp.focus { workspace = 'r+1' }, { desc = 'Workspace: Focus next' })
bind(mm .. '+ALT+P', dsp.focus { workspace = 'r-1' }, { desc = 'Workspace: Focus prev' })

-- UTILS
bind(mm .. '+comma', exec('pkill -x rofi || ' .. Hypr.custom_scripts .. '/glyph-picker.sh'), { desc = 'Utilities: Glyph picker' })
bind(mm .. '+B', exec('pkill -x rofi || ' .. Hypr.custom_scripts .. '/pdf-selector.sh'), { desc = 'Utilities: Pdf selector' })
bind(mm .. '+SHIFT+B', exec('pkill -x rofi || ' .. Hypr.custom_scripts .. '/pdf-selector.sh hidden'))
bind(mm .. '+P', function()
  run(qs_dsp 'regionScreenshot')
  run(exec 'qs -c ii ipc call TEST_ALIVE || pidof slurp || hyprshot --freeze --clipboard-only --mode region --silent')
end, { desc = 'Utilities: Screen snip' })
bind(mm .. '+SHIFT+U', exec(Hypr.custom_scripts .. '/update.sh up'), { desc = 'Utilities: System update' })

-- MEDIA
bind('XF86AudioMute', exec 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle', { locked = true })
bind('F11', exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-', { desc = 'Media: Decrease volume', locked = true, repeating = true })
bind('F12', exec 'wpctl set-volume -l 1.53 @DEFAULT_AUDIO_SINK@ 5%+', { desc = 'Media: Increase volume', locked = true, repeating = true })
bind('code:248', exec 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle', { desc = 'Media: Toggle microphone mute', locked = true })

-- APPS
bind(mm .. '+C', function()
  local term = Hypr.terminal
  if not term then
    run(exec "notify-send 'Hyprland' 'Terminal not set'")
    return
  end
  if term:find 'kitty' then
    run(exec 'kitty -1 nvim')
  elseif term:find 'wezterm' then
    run(exec(term .. ' start -- sh -c nvim'))
  else
    run(exec('notify-send "Hyprland" "Dont know "' .. term .. '"'))
  end
end, { desc = 'Apps: Code editor' })
bind(mm .. '+F', exec(Hypr.hypr_scripts .. '/launch_first_available.sh' .. [[ "zen-browser" "firefox" "brave" "librewolf"]]),
  { desc = 'Apps: Browser' })
bind(mm .. '+SHIFT+M', exec 'flatpak run com.spotify.Client', { desc = 'Apps: Spotify' })
bind(mm .. '+D', exec 'vesktop', { desc = 'Apps: Discord' })
bind(mm .. '+SHIFT+C', exec('env WC_KB=1 ' .. Hypr.custom_scripts .. '/wayclick.sh'), { desc = 'Apps: Toggle wayclick' })
