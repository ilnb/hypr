local home = os.getenv 'HOME'

_G.Hypr = {}
Hypr.mainMod = 'SUPER'
Hypr.editor = 'nvim'
Hypr.explorer = 'thunar'
Hypr.browser = 'zen-browser'
Hypr.hypr_scripts = home .. '/.config/hypr/hyprland/scripts'
Hypr.custom_scripts = home .. '/.config/hypr/custom/scripts'
Hypr.terminal = Hypr.custom_scripts .. '/wezterm.sh'

require 'hyprland.env'
require 'custom.env'

require 'hyprland.execs'
require 'hyprland.general'
require 'hyprland.rules'
require 'hyprland.colors'
require 'hyprland.keybinds'

require 'custom.execs'
require 'custom.general'
require 'custom.rules'
require 'custom.keybinds'

require 'workspaces'
require 'monitors'
require 'nvidia'
