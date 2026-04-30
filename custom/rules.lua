local wr = hl.window_rule
local lr = hl.layer_rule

-- tag
wr {
  match = {
    tag = 'center_float',
  },
  center = true,
  float = true,
}

-- opacity
wr { match = { class = '(firefox)$' }, opacity = '0.90 override 0.90 override' }
wr { match = { class = '(zen)' }, opacity = '0.80 override 0.80 override' }
wr { match = { class = '(org.pwmt.zathura)' }, opacity = '0.75 override 0.80 override 0.70 override' }
wr { match = { class = '(Brave-browser)$' }, opacity = '0.90 override 0.90 override' }
wr { match = { class = '(kitty)$' }, opacity = '0.80 override 0.80 override 0.90 override' }
wr { match = { class = '(org.wezfurlong.wezterm)$' }, opacity = '0.80 override 0.80 override 0.90 override' }
wr { match = { class = '(com.mitchellh.ghostty)$' }, opacity = '0.80 override 0.80 override 0.90 override' }
wr { match = { class = '(thunar)$' }, opacity = '0.70 override 0.70 override 0.70 override' }

wr {
  match = { class = '(org.kde.dolphin|org.kde.ark|nwg-look|qt5ct|qt6ct|kvantummanager)' },
  opacity = '0.80 override 0.80 override',
}

wr {
  match = {
    class = '(org.pulseaudio.pavucontrol|blueman-manager|nm-applet|nm-connection-editor|org.kde.polkit-kde-authentication-agent-1|polkit-gnome-authentication-agent-1|org.freedesktop.impl.portal.desktop.gtk|org.freedesktop.impl.portal.desktop.hyprland)'
  },
  opacity = '0.80 override 0.70 override',
}

wr { match = { class = '([Ss]team)' }, opacity = '0.70 override 0.70 override' }
wr { match = { class = '(steamwebhelper)' }, opacity = '0.70 override 0.70 override', fullscreen = false }
wr { match = { class = '(org.qbittorrent.qBittorrent)' }, opacity = '0.70 override 0.70 override', fullscreen = false }

wr { match = { class = '([Ss]potify)' }, opacity = '0.70 override 0.70 override 0.70 override' }
wr { match = { initial_title = '(Spotify Free)$' }, opacity = '0.70 override 0.70 override 0.70 override' }
wr { match = { initial_title = '(Spotify Premium)$' }, opacity = '0.70 override 0.70 override 0.70 override' }

-- center float
wr { match = { class = '(com.gabm.satty)$' }, tag = '+center_float' }

wr {
  match = {
    class = '(kvantummanager|nwg-displays|org.kde.ark|nm-connection-editor|org.kde.polkit-kde-authentication-agent-1|[Xx]dg-desktop-portal-gtk|Signal|com.github.rafostar.Clapper|app.drey.Warp|net.davidotek.pupgui2|yad|eog|io.github.alainm23.planify|io.gitlab.theevilskeleton.Upscaler|com.github.unrud.VideoDownloader|io.gitlab.adhami3310.Impression|io.missioncenter.MissionCenter|iwdgui)'
  },
  tag = '+center_float',
}

wr {
  match = { class = '(nwg-look)' },
  size = '568 446',
  tag = '+center_float',
}

wr {
  match = { class = '(org.pulseaudio.pavucontrol)' },
  size = '542 343',
  tag = '+center_float',
}

wr {
  match = { class = '(blueman-manager|nm-applet)' },
  size = '529 343',
  tag = '+center_float',
}

-- floats
wr {
  match = { title = '(Progress Dialog — Dolphin)$', class = '(org.kde.dolphin)$' },
  float = true,
}

wr {
  match = { title = '(Copying — Dolphin)$', class = '(org.kde.dolphin)$' },
  float = true,
}

wr { match = { title = '(About Mozilla Firefox)$' }, float = true }
wr { match = { title = '(Picture-in-Picture)$', class = '(firefox)$' }, float = true }
wr { match = { title = '(Library)$', class = '(firefox)$' }, float = true }

wr {
  match = { title = '(top|btop|htop)$', class = '(kitty|com.mitchellh.ghostty)$' },
  float = true,
}

wr {
  match = { initial_title = '(.*)(top|btop|htop)(.*)$' },
  float = true,
}

-- commmon modals
wr {
  match = { initial_title = '(.*)(Confirm to replace files)(.*)$' },
  float = true,
}

wr {
  match = { initial_title = '(.*)(File Operation Progress)(.*)$' },
  float = true,
}

wr {
  match = {
    initial_title = '(.*)(Rename|Open|Choose Files|Save|File Upload|Opening)(.*)$',
  },
  size = '450 250',
  tag = '+center_float',
}

-- layer rules
lr {
  name = 'blurry',
  match = {
    namespace = '(rofi|notifications|swaync-notification-window|swaync-control-center|logout_dialog)',
  },
  blur = true,
}

lr {
  name = 'noalpha',
  match = {
    namespace = '(rofi|notifications|swaync-notification-window|swaync-control-center)',
  },
  ignore_alpha = 0,
}
