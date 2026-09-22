local env = hl.env

env('QT_IM_MODULE', 'fcitx')
env('SDL_IM_MODULE', 'fcitx')
env('GLFW_IM_MODULE', 'fcitx')
env('XMODIFIERS', '@im=fcitx')
env('INPUT_METHOD', 'fcitx')
env('WLR_NO_HARDWARE_CURSORS', '1')
-- Make Qt apps see the `kde` platform theme
-- home-manager profile (QT_QPA_PLATFORMTHEME=kde is set by end4's env.lua).
-- Additive; Qt still searches its default plugin dirs.
env('QT_PLUGIN_PATH', '/etc/profiles/per-user/sauceguy/lib/qt-6/plugins')
env('EDITOR', Hypr.editor)
