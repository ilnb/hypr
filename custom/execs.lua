hl.on('hyprland.start', function()
  hl.exec_cmd 'gsettings set org.gnome.desktop.interface icon-theme "Adwaita"'

  hl.exec_cmd 'fcitx5'

  -- startup sound
  local path = os.getenv 'HOME' .. '/.config/hypr/custom/oxp.wav'
  hl.exec_cmd('sleep 2; pw-play --volume=0.4 ' .. path)
end)
