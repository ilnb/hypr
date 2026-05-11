hl.monitor {
  output = '',
  mode = 'preferred',
  position = 'auto',
  scale = '1.00',
}

hl.gesture {
  fingers = 3,
  direction = 'horizontal',
  action = 'workspace',
}

hl.gesture {
  fingers = 4,
  direction = 'up',
  action = function()
    hl.dispatch(hl.dsp.global 'quickshell:overviewWorkspacesToggle')
  end,
}

hl.gesture {
  fingers = 4,
  direction = 'down',
  action = function()
    hl.dispatch(hl.dsp.global 'quickshell:overviewWorkspacesClose')
  end,
}

hl.config {
  gestures   = {
    workspace_swipe_distance = 700,
    workspace_swipe_cancel_ratio = 0.2,
    workspace_swipe_min_speed_to_force = 5,
    workspace_swipe_direction_lock = true,
    workspace_swipe_direction_lock_threshold = 10,
    workspace_swipe_create_new = true,
  },

  general    = {
    -- Gaps and border
    gaps_in           = 4,
    gaps_out          = 5,
    gaps_workspaces   = 50,
    border_size       = 1,
    resize_on_border  = true,
    no_focus_fallback = true,
    allow_tearing     = true, -- This just allows the `immediate` window rule to work
    snap              = {
      enabled = true,
      window_gap = 4,
      monitor_gap = 5,
      respect_gaps = true,
    },
  },

  dwindle    = {
    preserve_split = true,
    smart_split = true,
    smart_resizing = false,
    -- precise_mouse_move = true,
  },

  decoration = {
    rounding_power = 2,
    rounding = 18,

    blur = {
      enabled = true,
      xray = true,
      special = false,
      new_optimizations = true,
      size = 10,
      passes = 3,
      brightness = 1,
      noise = 0.05,
      contrast = 0.89,
      vibrancy = 0.5,
      vibrancy_darkness = 0.5,
      popups = false,
      popups_ignorealpha = 0.6,
      input_methods = true,
      input_methods_ignorealpha = 0.8,
    },

    shadow = {
      enabled = true,
      range = 50,
      offset = { 0, 4 },
      render_power = 10,
      color = 'rgba(00000027)',
    },

    dim_inactive = true,
    dim_strength = 0.05,
    dim_special = 0.2
  },

  input      = {
    kb_layout = 'us',
    numlock_by_default = true,
    repeat_delay = 250,
    repeat_rate = 35,

    follow_mouse = 1,
    off_window_axis_events = 2,

    touchpad = {
      natural_scroll = true,
      disable_while_typing = true,
      clickfinger_behavior = true,
      scroll_factor = 0.7,
    },
  },

  misc       = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    vrr = 1,
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
    animate_manual_resizes = false,
    animate_mouse_windowdragging = false,
    enable_swallow = false,
    swallow_regex = '(foot|kitty|allacritty|Alacritty)',
    on_focus_under_fullscreen = 2,
    allow_session_lock_restore = true,
    session_lock_xray = true,
    initial_workspace_tracking = false,
    focus_on_activate = true,
  },

  binds      = {
    scroll_event_delay = 0,
    hide_special_on_workspace_change = true,
  },

  cursor     = {
    zoom_factor = 1,
    zoom_rigid = false,
    zoom_disable_aa = true,
    hotspot_padding = true,
  }
}

local curves = {
  { 'expressiveFastSpatial',    { type = 'bezier', points = { { 0.42, 1.67 }, { 0.21, 0.90 } } } },
  { 'expressiveSlowSpatial',    { type = 'bezier', points = { { 0.39, 1.29 }, { 0.35, 0.98 } } } },
  { 'expressiveDefaultSpatial', { type = 'bezier', points = { { 0.38, 1.21 }, { 0.22, 1.00 } } } },
  { 'emphasizedDecel',          { type = 'bezier', points = { { 0.05, 0.7 }, { 0.1, 1 } } } },
  { 'emphasizedAccel',          { type = 'bezier', points = { { 0.3, 0 }, { 0.8, 0.15 } } } },
  { 'standardDecel',            { type = 'bezier', points = { { 0, 0 }, { 0, 1 } } } },
  { 'menu_decel',               { type = 'bezier', points = { { 0.1, 1 }, { 0, 1 } } } },
  { 'menu_accel',               { type = 'bezier', points = { { 0.52, 0.03 }, { 0.72, 0.08 } } } },
  { 'stall',                    { type = 'bezier', points = { { 1, -0.1 }, { 0.7, 0.85 } } } }
}
for _, curve in ipairs(curves) do
  hl.curve(table.unpack(curve))
end

local anims = {
  { leaf = 'windowsIn',           speed = 3,   bezier = 'emphasizedDecel', style = 'popin 80%' },
  { leaf = 'fadeIn',              speed = 3,   bezier = 'emphasizedDecel' },
  { leaf = 'windowsOut',          speed = 2,   bezier = 'emphasizedDecel', style = 'popin 90%' },
  { leaf = 'fadeOut',             speed = 2,   bezier = 'emphasizedDecel' },
  { leaf = 'windowsMove',         speed = 3,   bezier = 'emphasizedDecel', style = 'slide' },
  { leaf = 'border',              speed = 10,  bezier = 'emphasizedDecel' },
  { leaf = 'layersIn',            speed = 2.7, bezier = 'emphasizedDecel', style = 'popin 93%' },
  { leaf = 'layersOut',           speed = 2.4, bezier = 'menu_accel',      style = 'popin 94%' },
  { leaf = 'fadeLayersIn',        speed = 0.5, bezier = 'menu_decel' },
  { leaf = 'fadeLayersOut',       speed = 2.7, bezier = 'stall' },
  { leaf = 'workspaces',          speed = 7,   bezier = 'menu_decel',      style = 'slide' },
  { leaf = 'specialWorkspaceIn',  speed = 2.8, bezier = 'emphasizedDecel', slide = 'slidevert' },
  { leaf = 'specialWorkspaceOut', speed = 1.2, bezier = 'emphasizedAccel', slide = 'slidevert' },
  { leaf = 'zoomFactor',          speed = 3,   bezier = 'standardDecel' },
}
for _, anim in ipairs(anims) do
  if anim.enabled == nil then
    anim.enabled = true
  end
  hl.animation(anim)
end
