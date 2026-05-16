local wr = hl.window_rule
local lr = hl.layer_rule

-- tag
wr { match = { tag = 'center_float', }, center = true, float = true }

-- opacity
local op = {
  { match = { class = 'firefox' },                                      opacity = '0.90 override 0.90 override' },
  { match = { class = 'zen' },                                          opacity = '0.80 override 0.80 override' },
  { match = { class = 'Brave-browser' },                                opacity = '0.90 override 0.90 override' },
  { match = { class = '[Ss]team' },                                     opacity = '0.70 override 0.70 override' },
  { match = { class = 'steamwebhelper' },                               opacity = '0.70 override 0.70 override' },
  { match = { class = 'org.qbittorrent.qBittorrent' },                  opacity = '0.70 override 0.70 override' },
  { match = { class = 'org.pulseaudio.pavucontrol' },                   opacity = '0.80 override 0.70 override' },
  { match = { class = 'blueman-manager' },                              opacity = '0.80 override 0.70 override' },
  { match = { class = 'nm-applet' },                                    opacity = '0.80 override 0.70 override' },
  { match = { class = 'nm-connection-editor' },                         opacity = '0.80 override 0.70 override' },
  { match = { class = 'org.kde.polkit-kde-authentication-agent-1' },    opacity = '0.80 override 0.70 override' },
  { match = { class = 'polkit-gnome-authentication-agent-1' },          opacity = '0.80 override 0.70 override' },
  { match = { class = 'org.freedesktop.impl.portal.desktop.gtk' },      opacity = '0.80 override 0.70 override' },
  { match = { class = 'org.freedesktop.impl.portal.desktop.hyprland' }, opacity = '0.80 override 0.70 override' },
  { match = { class = 'org.kde.dolphin.org' },                          opacity = '0.80 override 0.80 override' },
  { match = { class = 'org.kde.ark' },                                  opacity = '0.80 override 0.80 override' },
  { match = { class = 'nwg-look' },                                     opacity = '0.80 override 0.80 override' },
  { match = { class = 'qt5ct' },                                        opacity = '0.80 override 0.80 override' },
  { match = { class = 'qt6ct' },                                        opacity = '0.80 override 0.80 override' },
  { match = { class = 'kvantummanager' },                               opacity = '0.80 override 0.80 override' },
  { match = { class = '[Ss]potify' },                                   opacity = '0.70 override 0.70 override 0.70 override' },
  { match = { class = 'thunar' },                                       opacity = '0.70 override 0.70 override 0.70 override' },
  { match = { class = 'org.pwmt.zathura' },                             opacity = '0.75 override 0.80 override 0.70 override' },
  { match = { class = 'kitty' },                                        opacity = '0.80 override 0.80 override 0.90 override' },
  { match = { class = 'org.wezfurlong.wezterm' },                       opacity = '0.80 override 0.80 override 0.90 override' },
  { match = { class = 'com.mitchellh.ghostty' },                        opacity = '0.80 override 0.80 override 0.90 override' },
}
for _, rule in ipairs(op) do
  wr(rule)
end

-- center float
local cf = {
  { match = { class = 'kvantummanager' } },
  { match = { class = 'nwg-displays' } },
  { match = { class = 'org.kde.ark' } },
  { match = { class = 'nm-connection-editor' } },
  { match = { class = 'org.kde.polkit-kde-authentication-agent-1' } },
  { match = { class = '[Xx]dg-desktop-portal-gtk' } },
  { match = { class = 'Signal' } },
  { match = { class = 'com.github.rafostar.Clapper' } },
  { match = { class = 'app.drey.Warp' } },
  { match = { class = 'net.davidotek.pupgui2' } },
  { match = { class = 'yad' } },
  { match = { class = 'eog' } },
  { match = { class = 'io.github.alainm23.planify' } },
  { match = { class = 'io.gitlab.theevilskeleton.Upscaler' } },
  { match = { class = 'com.github.unrud.VideoDownloader' } },
  { match = { class = 'io.gitlab.adhami3310.Impression' } },
  { match = { class = 'io.missioncenter.MissionCenter' } },
  { match = { class = 'iwdgui' } },
  { match = { class = 'com.gabm.satty' } },
  { match = { class = 'nwg-look' },                                 size = '568 446' },
  { match = { class = 'org.pulseaudio.pavucontrol' },               size = '542 343' },
  { match = { class = 'blueman-manager' },                          size = '529 343' },
  { match = { class = 'nm-applet' },                                size = '529 343' },
  { match = { initial_title = '(.*)Rename(.*)$' },                  size = '750 550' },
  { match = { initial_title = '(.*)Open(.*)$' },                    size = '750 550' },
  { match = { initial_title = '(.*)Choose Files(.*)$' },            size = '750 550' },
  { match = { initial_title = '(.*)Save(.*)$' },                    size = '750 550' },
  { match = { initial_title = '(.*)File Upload(.*)$' },             size = '750 550' },
  { match = { initial_title = '(.*)Opening(.*)$' },                 size = '750 550' },
}
for _, rule in ipairs(cf) do
  rule.tag = '+center_float'
  wr(rule)
end

-- floats
local fl = {
  { match = { title = '(Progress Dialog — Dolphin)$', class = 'org.kde.dolphin' } },
  { match = { title = '(Copying — Dolphin)$', class = 'org.kde.dolphin' } },
  { match = { title = '(Picture-in-Picture)$', class = 'firefox' } },
  { match = { title = '(Library)$', class = 'firefox' } },
  { match = { title = '(About Mozilla Firefox)$' } },
  -- commmon modals
  { match = { initial_title = '(.*)(Confirm to replace files)(.*)$' } },
  { match = { initial_title = '(.*)(File Operation Progress)(.*)$' } },
}
for _, rule in ipairs(fl) do
  rule.float = true
  wr(rule)
end

-- layer rules
local blur = {
  'notifications',
  'swaync-notification-window',
  'swaync-control-center',
  'rofi',
}
for _, nm in ipairs(blur) do
  lr { match = { namespace = nm }, blur = true, ignore_alpha = 0 }
end
lr { match = { namespace = 'logout_dialog' }, blur = true }
