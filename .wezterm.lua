-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = 'Tokyo Night Storm'
config.default_domain = 'WSL:Arch'

config.font_size = 16.0
config.window_background_opacity = 0.9
config.window_decorations = "NONE"
config.enable_tab_bar = false
config.font = wezterm.font('MonoLisa', {})
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

-- and finally, return the configuration to wezterm
return config
