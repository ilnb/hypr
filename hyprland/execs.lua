local exec = hl.exec_cmd

hl.on('hyprland.start', function()
  -- Bar, wallpaper
  exec(Hypr.hypr_scripts .. '/start_geoclue_agent.sh')
  exec('qs -c ii &')
  exec(Hypr.custom_scripts .. '/__restore_video_wallpaper.sh')

  -- Core components (authentication, lock screen, notification daemon)
  exec 'gnome-keyring-daemon --start --components=secrets'
  exec 'hypridle'
  exec 'dbus-update-activation-environment --all'
  exec 'sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP'

  -- Audio
  exec 'easyeffects --hide-window --service-mode'

  -- Clipboard: history
  -- exec 'wl-paste --watch cliphist store &'
  exec(
    "wl-paste --type text --watch "
    .. "bash -c 'cliphist store && "
    .. "qs -c ii ipc call cliphistService update'"
  )
  exec(
    "wl-paste --type image --watch "
    .. "bash -c 'cliphist store && "
    .. "qs -c ii ipc call cliphistService update'"
  )

  -- Cursor
  exec 'hyprctl setcursor Bibata-Modern-Classic 24'
end)
