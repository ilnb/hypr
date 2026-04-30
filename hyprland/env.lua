local env = hl.env

env('ELECTRON_OZONE_PLATFORM_HINT', 'auto')

env('XDG_DATA_DIRS',
  os.getenv 'HOME' .. '/.local/share/flatpak/exports/share:'
  .. '/var/lib/flatpak/exports/share:'
  .. '/usr/local/share:/usr/share'
)

env('QT_QPA_PLATFORM', 'wayland;xcb')
env('QT_QPA_PLATFORMTHEME', 'kde')
env('XDG_MENU_PREFIX', 'plasma-')
env('ILLOGICAL_IMPULSE_VIRTUAL_ENV', '~/.local/state/quickshell/.venv')
env('TERMINAL', Hypr.terminal)
