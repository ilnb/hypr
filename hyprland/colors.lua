local colors = {
  'rgba(47474777)',
  'rgba(1B1B1B33)',
  'rgba(131313ff)',
  'rgba(ffb3b5aa) rgba(ffb3b577)',
}

local lines = {}
local conf_dir = os.getenv 'HOME' .. '/.config'
local f = io.open(conf_dir .. '/hypr/hyprland/colors.conf', 'r')
if f then
  for l in f:lines() do
    table.insert(lines, l)
  end
end

if #lines > 0 then
  colors[1] = lines[2]:sub(lines[2]:find '=' + 2) or colors[1]
  colors[2] = lines[3]:sub(lines[3]:find '=' + 2) or colors[2]
  colors[3] = lines[7]:sub(lines[7]:find '=' + 2) or colors[3]
  local i = lines[#lines]:find 'rgba'
  local j = lines[#lines]:find ','
  colors[4] = lines[#lines]:sub(i, j - 1) or colors[4]
end

hl.config {
  general = {
    col = {
      active_border = colors[1],
      inactive_border = colors[2],
    }
  },
  misc = {
    background_color = colors[3],
  }
}

hl.window_rule {
  match = { pin = true },
  border_color = colors[4],
}
