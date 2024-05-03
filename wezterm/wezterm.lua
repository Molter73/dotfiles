local wezterm = require('wezterm')
local config = wezterm.config_builder()
local actions = wezterm.action

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

-- Disable wayland, since it is giving me headaches
config.enable_wayland = false

config.keys = {
    -- Paste from system clipboard
    { key = 'V', mods = 'CTRL',       action = wezterm.action.PasteFrom 'Clipboard' },
    -- Don't spawn windows on ctrl+N
    { key = 'N', mods = 'CTRL',       action = actions.DisableDefaultAssignment },
    { key = 'N', mods = 'SHIFT|CTRL', action = actions.DisableDefaultAssignment },
    -- Don't close tabs on ctrl+W
    { key = 'W', mods = 'CTRL',       action = actions.DisableDefaultAssignment },
    { key = 'W', mods = 'SHIFT|CTRL', action = actions.DisableDefaultAssignment },
}

return config
