local wezterm = require 'wezterm'

local config = wezterm.config_builder()
config.automatically_reload_config = true

config.font = wezterm.font 'JetBrains Mono'
config.color_scheme = 'Afterglow (Gogh)'
config.font_size = 12
config.use_ime = true
config.window_background_opacity = 0.75
config.macos_window_background_blur = 20
config.window_decorations = 'RESIZE' 

config.hide_tab_bar_if_only_one_tab = true
config.window_frame = {
    inactive_titlebar_bg = 'none',
    active_titlebar_bg = 'none',
}
config.window_background_gradient = {
    colors = { '#000000' },
}
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.colors = {
    tab_bar = {
        inactive_tab_edge = 'none',
    },
}
-- タブに色をつける
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local title = ' ' .. wezterm.truncate_right(tab.active_pane.title, max_width - 2) .. ' '
    
    local active_bg = '#d4843e'
    local active_fg = '#151515'
    local inactive_bg = '#2c2c2c'
    local inactive_fg = '#888888'
    
    local LEFT_DIVIDER = utf8.char(0xe0b6) -- 
    local RIGHT_DIVIDER = utf8.char(0xe0b4) -- 

    -- タブの「外側」の余白の定義
    local gap = { { Background = { Color = 'none' } }, { Text = ' ' } }

    if tab.is_active then
        return {
            gap[1], gap[2], -- 左に隙間
            { Foreground = { Color = active_bg } },
            { Text = LEFT_DIVIDER },
            { Background = { Color = active_bg } },
            { Foreground = { Color = active_fg } },
            { Attribute = { Intensity = 'Bold' } },
            { Text = title },
            { Background = { Color = 'none' } }, 
            { Foreground = { Color = active_bg } },
            { Text = RIGHT_DIVIDER },
            gap[1], gap[2], -- 右に隙間
        }
    end
    
    return {
        gap[1], gap[2],
        { Foreground = { Color = inactive_bg } },
        { Text = LEFT_DIVIDER },
        { Background = { Color = inactive_bg } },
        { Foreground = { Color = inactive_fg } },
        { Text = title },
        { Background = { Color = 'none' } },
        { Foreground = { Color = inactive_bg } },
        { Text = RIGHT_DIVIDER },
        gap[1], gap[2],
    }
end)

--------------------------------------
-- keybinds
--------------------------------------
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.disable_default_key_bindings = true
config.leader = { key = "g", mods = "CTRL", timeout_milliseconds = 2000 }

return config
