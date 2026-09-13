local env = hl.env
local home_dir = os.getenv("HOME")

env('ELECTRON_OZONE_PLATFORM_HINT', 'auto')

env('QT_QPA_PLATFORM', 'wayland;xcb')
env('QT_QPA_PLATFORMTHEME', 'kde')
env('XDG_MENU_PREFIX', 'plasma-')
env('TERMINAL', Hypr.terminal)

-- for KDE QML modules
-- Home-manager links these under the per-user profile's qt-6 qml tree.
env('QML2_IMPORT_PATH', '/etc/profiles/per-user/' .. os.getenv('USER') .. '/lib/qt-6/qml')
-- NOTE: keep in sync with home.nix
env('ILLOGICAL_IMPULSE_VIRTUAL_ENV', home_dir .. '/.local/state/quickshell/.venv')
