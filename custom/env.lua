local env = hl.env

env('QT_IM_MODULE', 'fcitx')
env('SDL_IM_MODULE', 'fcitx')
env('GLFW_IM_MODULE', 'fcitx')
env('XMODIFIERS', '@im=fcitx')
env('INPUT_METHOD', 'fcitx')
env('WLR_NO_HARDWARE_CURSORS', '1')
-- Make Qt apps see the `kde` platform theme
env('QT_PLUGIN_PATH', '/etc/profiles/per-user/sauceguy/lib/qt-6/plugins')
env('XCURSOR_THEME', Hypr.cursor)
env('XCURSOR_SIZE', '24')
env('EDITOR', Hypr.editor)
