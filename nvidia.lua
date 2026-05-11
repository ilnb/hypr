local env = hl.env

local igpu = true

if not igpu then
  -- nvidia mode
  env('__GLX_VENDOR_LIBRARY_NAME', 'nvidia')
  env('__GL_VRR_ALLOWED', '1')
else
  -- igpu mode
  env('LIBVA_DRIVER_NAME', 'radeonsi')
  env('__GLX_VENDOR_LIBRARY_NAME', 'mesa')
  env('AQ_DRM_DEVICES', '/dev/dri/card0:/dev/dri/card1')
end

hl.config {
  cursor = {
    no_hardware_cursors = true,
  },
}
