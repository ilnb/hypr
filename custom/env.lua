local home = os.getenv 'HOME'
local path = os.getenv 'PATH' or ''

local env = hl.env

env('QT_IM_MODULE', 'fcitx')
env('SDL_IM_MODULE', 'fcitx')
env('GLFW_IM_MODULE', 'fcitx')
env('XMODIFIERS', '@im=fcitx')
env('INPUT_METHOD', 'fcitx')

env('WLR_NO_HARDWARE_CURSORS', '1')
env('PATH',
  path
  .. ':' .. home .. '/.local/bin'
  .. ':' .. home .. '/node_modules/.bin'
)

env('EDITOR', Hypr.editor)
env('TERMINAL', Hypr.terminal)
