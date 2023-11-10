local wezterm = require('wezterm')
local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Mocha'
config.enable_tab_bar = false
config.audible_bell = 'Disabled'
config.check_for_updates = false

-- Font configuration
-- FiraCode
--[[
config.font = wezterm.font({
    family = 'FiraCode Nerd Font Mono',
    weight = 'Bold',
})
config.font_size = 14
config.harfbuzz_features = {
    "cv02", "cv05", "cv09", "cv14", "cv16", "cv25", "cv26", "cv27", "cv31", "cv32", "zero", "ss04", "ss05", "ss03",
    "ss07", "ss09", }
--]]

-- Monaspace
config.font = wezterm.font({
    family = 'Monaspace Neon',
    weight = 'DemiBold',
})
config.font_size = 14
config.harfbuzz_features = {
    'ss01', 'ss02', 'ss03', 'ss04', 'ss07', 'ss08'
}

-- Cursor configuration
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.cursor_blink_rate = 400

return config
