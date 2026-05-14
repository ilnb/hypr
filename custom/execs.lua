hl.on('hyprland.start', function()
  hl.exec_cmd 'fcitx5'

  -- startup sound
  local path = os.getenv 'HOME' .. '/.config/hypr/custom/oxp.wav'
  hl.exec_cmd('sleep 2; pw-play ' .. path)
end)
