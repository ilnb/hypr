local env = hl.env

env('QT_IM_MODULE', 'fcitx')
env('GTK_IM_MODULE', '')
env('SDL_IM_MODULE', 'fcitx')
env('GLFW_IM_MODULE', 'fcitx')
env('XMODIFIERS', '@im=fcitx')
env('INPUT_METHOD', 'fcitx')
env('WLR_NO_HARDWARE_CURSORS', '1')

env('EDITOR', Hypr.editor)
