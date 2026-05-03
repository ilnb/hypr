local mm = Hypr.mainMod

local bind = hl.bind
local dsp = hl.dsp
local exec = dsp.exec_cmd
---@param str string
local qs_dsp = function(str)
  return dsp.global('quickshell:' .. str)
end

local dirs = { H = 'l', L = 'r', K = 'u', J = 'd' }

-- WINDOW
bind(mm .. '+Backspace', qs_dsp 'sessionToggle', { desc = 'Toggle session menu' })
bind(mm .. '+Delete', exec 'exit')
bind(mm .. '+W', dsp.window.float { action = 'toggle' }, { desc = 'Float' })
for key, dir in pairs(dirs) do
  bind(mm .. '+' .. key, dsp.focus { direction = dir })
end
local cmd = [[grep -q "true" <<< $(hyprctl activewindow -j | jq -r .floating) && hyprctl dispatch moveactive]]
bind(mm .. '+CTRL+H', exec(cmd .. ' -30 0 || hyprctl dispatch movewindow l'), { repeating = true })
bind(mm .. '+CTRL+L', exec(cmd .. ' 30 0  || hyprctl dispatch movewindow r'), { repeating = true })
bind(mm .. '+CTRL+K', exec(cmd .. ' 0 -30 || hyprctl dispatch movewindow u'), { repeating = true })
bind(mm .. '+CTRL+J', exec(cmd .. ' 0 30  || hyprctl dispatch movewindow d'), { repeating = true })

-- WORKSPACES
for n = 1, 10 do
  local k = n == 10 and 0 or n
  bind(mm .. '+' .. k, dsp.focus { workspace = k })
  bind(mm .. '+SHIFT+' .. k, dsp.window.move { workspace = k })
end
bind(mm .. '+ALT+N', dsp.focus { workspace = 'r+1' })
bind(mm .. '+ALT+P', dsp.focus { workspace = 'r-1' })
bind(mm .. '+CTRL+ALT+L', dsp.window.move { workspace = 'r+1' })
bind(mm .. '+CTRL+ALT+H', dsp.window.move { workspace = 'r-1' })

-- UTILS
bind(mm .. '+comma', exec('pkill -x rofi || ' .. Hypr.custom_scripts .. '/glyph-picker.sh'), { desc = 'Glyph picker' })
bind(mm .. '+B', exec('pkill -x rofi || ' .. Hypr.custom_scripts .. '/pdf-selector.sh'), { desc = 'Pdf selector' })
bind(mm .. '+SHIFT+B', exec('pkill -x rofi || ' .. Hypr.custom_scripts .. '/pdf-selector.sh hidden'))
bind(mm .. '+P', qs_dsp 'regionScreenshot', { desc = 'Screen snip' })
bind(mm .. '+SHIFT+U', exec(Hypr.custom_scripts .. '/update.sh up'), { desc = 'Run system update' })

-- MEDIA
bind('XF86AudioMute', exec 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle', { locked = true })
bind('F11', exec 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-', { desc = 'Decrease volume', locked = true, repeating = true })
bind('F12', exec 'wpctl set-volume -l 1.53 @DEFAULT_AUDIO_SINK@ 5%+', { desc = 'Increase volume', locked = true, repeating = true })
-- bind('code:248', exec 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle', { desc = 'Toggle microphone mute', locked = true })

-- APPS
bind(mm .. '+C', exec(Hypr.hypr_scripts .. '/launch_first_available.sh'
    .. string.format(' "%s start -- sh -c nvim"', Hypr.terminal)
    .. [[ "kitty -1 nvim"]]),
  { desc = 'Code editor' })
bind(mm .. '+F', exec(Hypr.hypr_scripts .. '/launch_first_available.sh' .. [[ "zen-browser" "firefox" "brave" "librewolf"]]), { desc = 'Browser' })
bind(mm .. '+SHIFT+M', exec 'flatpak run com.spotify.Client', { desc = 'Spotify' })
bind(mm .. '+D', exec 'vesktop', { desc = 'Discord' })
bind(mm .. '+SHIFT+C', exec('env WC_KB=1 ' .. Hypr.custom_scripts .. '/wayclick.sh'), { desc = 'Toggle wayclick' })
