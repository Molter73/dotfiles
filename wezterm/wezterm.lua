local wezterm = require('wezterm')
local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Mocha'
config.enable_tab_bar = false
config.audible_bell = 'Disabled'
config.check_for_updates = false

-- Font configuration
local font = require('fonts').firacode

config.font = wezterm.font({
    family = font.family,
    weight = font.weight,
})
config.font_size = font.size
config.harfbuzz_features = font.harfbuzz

-- Cursor configuration
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.cursor_blink_rate = 400

return config
