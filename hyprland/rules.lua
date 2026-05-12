local wr = hl.window_rule
local lr = hl.layer_rule

wr { match = { class = '^()$', title = '^()$', }, no_blur = false }
wr { match = { class = '.*' }, no_blur = false }

-- Floating
local fl = {
  {
    match = { title = '^(Open File|Select a File|Choose wallpaper|Open Folder|Save As|Library|File Upload)(.*)$' },
    center = true
  },
  { match = { title = '^(.*)(wants to save|wants to open)$' },        center = true },
  { match = { class = '^(pavucontrol|org.pulseaudio.pavucontrol)$' }, size = '(monitor_w*.45) (monitor_h*.45)', center = true },
  { match = { class = '^(nm-connection-editor)$' },                   size = '(monitor_w*.45) (monitor_h*.45)', center = true },
  { match = { class = 'org.freedesktop.impl.portal.desktop.kde' },    size = '(monitor_w*.60) (monitor_h*.65)' },
  { match = { title = '^(Choose wallpaper)(.*)$' },                   size = '(monitor_w*.60) (monitor_h*.65)' },
  { match = { class = '^(Zotero)$' },                                 size = '(monitor_w*.45) (monitor_h*.45)' },
  { match = { class = '^(blueberry\\.py)$' } },
  { match = { class = '^(guifetch)$' } },
  { match = { class = '.*plasmawindowed.*' } },
  { match = { class = 'kcm_.*' } },
  { match = { class = '.*bluedevilwizard' } },
  { match = { title = '.*Welcome' } },
  { match = { title = '^(illogical-impulse Settings)$' } },
  { match = { title = '.*Shell conflicts.*' } },
}
for _, rule in ipairs(fl) do
  rule.float = true
  wr(rule)
end

-- Move
wr { match = { class = '^(plasma-changeicons)$' }, move = '999999 999999', float = true, no_initial_focus = true }
wr { match = { title = '^(Copying — Dolphin)$' }, move = '40 80' }

-- Tiling
wr { match = { class = '^dev\\.warp\\.Warp$' }, tile = true }

-- Picture-in-Picture
wr {
  match = { title = '^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$' },
  float = true,
  keep_aspect_ratio = true,
  move = '(monitor_w*.73) (monitor_h*.72)',
  size = '(monitor_w*.25) (monitor_h*.25)',
  pin = true,
}

-- Tearing
wr { match = { title = '.*\\.exe' }, immediate = true }
wr { match = { title = '.*minecraft.*' }, immediate = true }
wr { match = { class = '^(steam_app).*' }, immediate = true }

-- No shadow for tiled windows (matches windows that are not floating).
wr { match = { float = false }, no_shadow = true }

-- Workspace rules
hl.workspace_rule { workspace = 'special:scratchpad', gaps_out = 30 }

-- Layer rules
lr { match = { namespace = '.*' }, xray = true }
local no_anim = {
  -- '.*',
  'walker',
  'selection',
  'overview',
  'anyrun',
  'indicator.*',
  'osk',
  'hyprpicker',
  'noanim',
}
for _, nm in ipairs(no_anim) do
  lr { match = { namespace = nm }, no_anim = true }
end

lr { match = { namespace = 'gtk-layer-shell' }, blur = true, ignore_alpha = 0 }
lr { match = { namespace = 'launcher' }, blur = true, ignore_alpha = 0.5 }
lr { match = { namespace = 'notifications' }, blur = true, ignore_alpha = 0.69 }
-- lr { match = { namespace = 'logout_dialog' }, blur = true }

-- ags
lr { match = { namespace = 'sideleft.*' }, animation = 'slide left' }
lr { match = { namespace = 'sideright.*' }, animation = 'slide right' }
lr { match = { namespace = 'session[0-9]*' }, blur = true }
local nms = {
  'bar[0-9]*',
  'barcorner.*',
  'dock[0-9]*',
  'indicator.*',
  'overview[0-9]*',
  'cheatsheet[0-9]*',
  'sideright[0-9]*',
  'sideleft[0-9]*',
  'indicator.*',
  'osk[0-9]*',
}
for _, nm in ipairs(nms) do
  lr { match = { namespace = nm }, blur = true, ignore_alpha = 0.6 }
end

-- Quickshell
-- Quickshell: illogical-impulse
local ii = {
  { match = { namespace = 'quickshell:.*' },                  blur_popups = true,         ignore_alpha = 0.79, blur = true },
  { match = { namespace = 'quickshell:actionCenter' },        no_anim = true },
  { match = { namespace = 'quickshell:bar' },                 animation = 'slide' },
  { match = { namespace = 'quickshell:cheatsheet' },          animation = 'slide bottom' },
  { match = { namespace = 'quickshell:dock' },                animation = 'slide bottom' },
  { match = { namespace = 'quickshell:lockWindowPusher' },    no_anim = true },
  { match = { namespace = 'quickshell:mediaControls' },       ignore_alpha = 1 },
  { match = { namespace = 'quickshell:notificationPopup' },   animation = 'fade' },
  { match = { namespace = 'quickshell:osk' },                 animation = 'slide bottom', order = -1 },
  { match = { namespace = 'quickshell:overlay' },             no_anim = true,             ignore_alpha = 1 },
  { match = { namespace = 'quickshell:overview' },            no_anim = true },
  { match = { namespace = 'quickshell:polkit' },              no_anim = true },
  { match = { namespace = 'quickshell:popup' },               xray = false,               ignore_alpha = 1 },
  { match = { namespace = 'quickshell:reloadPopup' },         animation = 'slide' },
  { match = { namespace = 'quickshell:regionSelector' },      no_anim = true },
  { match = { namespace = 'quickshell:screenCorners' },       animation = 'popin 120%' },
  { match = { namespace = 'quickshell:screenshot' },          no_anim = true },
  { match = { namespace = 'quickshell:session' },             no_anim = true,             ignore_alpha = 0,    blur = true },
  { match = { namespace = 'quickshell:sidebarLeft' },         animation = 'slide left' },
  { match = { namespace = 'quickshell:sidebarRight' },        animation = 'slide right' },
  { match = { namespace = 'quickshell:verticalBar' },         animation = 'slide' },

  -- Quickshell: waffles
  { match = { namespace = 'quickshell:wallpaperSelector' },   animation = 'slide top' },
  { match = { namespace = 'quickshell:wNotificationCenter' }, no_anim = true },
  { match = { namespace = 'quickshell:wOnScreenDisplay' },    no_anim = true },
  { match = { namespace = 'quickshell:wStartMenu' },          no_anim = true },
  { match = { namespace = 'quickshell:wTaskView' },           no_anim = true,             ignore_alpha = 0 },
}
for _, rule in ipairs(ii) do
  lr(rule)
end

-- Launchers need to be FAST
lr { match = { namespace = 'gtk4-layer-shell' }, no_anim = true }
