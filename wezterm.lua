local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

-----------------------------------


----------------------------
local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'Catppuccin Frappe'

-- hack to force it to open in fullscreen
wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

config.window_decorations = 'RESIZE' -- disable titel bar but allow resizable border
config.hide_tab_bar_if_only_one_tab = true

config.launch_menu = launch_menu
config.pane_focus_follows_mouse = false

config.default_cursor_style = 'BlinkingBar'
config.disable_default_key_bindings = true

config.adjust_window_size_when_changing_font_size = false

config.keys = { { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' }, }
config.mouse_bindings = mouse_bindings

-- There are mouse binding to mimc Windows Terminal and let you copy
-- To copy just highlight something and right click. Simple
mouse_bindings = {
    {
        event = { Down = { streak = 3, button = 'Left' } },
        action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
        mods = 'NONE',
    },
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wezterm.action_callback(function(window, pane)
            local has_selection = window:get_selection_text_for_pane(pane) ~= ""
            if has_selection then
                window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
                window:perform_action(act.ClearSelection, pane)
            else
                window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
            end
        end),
    },
}

-- This is used to make my foreground (text, etc) brighter than my background
config.foreground_text_hsb = {
    hue = 1.0,
    saturation = 1.2,
    brightness = 1.5,
}

config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.6,
}

-- This is used to set an image as my background
config.background = {
    {
        source = { File = { path = 'C:/Users/ha185116/.config/wezterm/Space.jpg' } },
        opacity = 1,
        width = "100%",
        hsb = { brightness = 0.3 },
    }
}

-- TAB OPTIONS
config.show_tabs_in_tab_bar = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
--------------------------------------------------------------------------
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }

config.keys = {

    {
        key = 'V',
        mods = 'CTRL',
        action = act.PasteFrom 'Clipboard'
    },
    {
        key = 'F11',
        action = wezterm.action.ToggleFullScreen,
    },
    -- Ctrl +/-: font size
    { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
    { key = "+", mods = "CTRL", action = act.IncreaseFontSize },
    -- F: toggle fullscreen
    {
        key = "f",
        mods = "LEADER",
        action = wezterm.action.ToggleFullScreen,
    },
    --------------------------------------------------------------------
    -- H/V: split pane horizontally/vertically
    {
        key = "h",
        mods = "LEADER",
        action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "v",
        mods = "LEADER",
        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        -- Q: close current pane
        key = 'q',
        mods = 'LEADER',
        action = wezterm.action.CloseCurrentPane { confirm = true },
    },
    {
        -- S: swap panes
        key = 's',
        mods = 'LEADER',
        action = act.PaneSelect { mode = 'SwapWithActiveKeepFocus' }
    },
    -- M: zooM pane
    {
        key = 'm',
        mods = 'LEADER',
        action = wezterm.action.TogglePaneZoomState
    },
    -- C-S-HJKL: move around panes
    -- {
    --  key = 'h',
    --  mods = 'CTRL|SHIFT',
    --  action = act.ActivatePaneDirection 'Left',
    --  },
    --{
    --  key = 'l',
    --  mods = 'CTRL|SHIFT',
    -- action = act.ActivatePaneDirection 'Right',
    -- },
    -- {
    --   key = 'k',
    --   mods = 'CTRL|SHIFT',
    --   action = act.ActivatePaneDirection 'Up',
    -- },
    -- {
    --  key = 'j',
    --  mods = 'CTRL|SHIFT',
    --  action = act.ActivatePaneDirection 'Down',
    -- },
    -- alt-HJKL: adjust pane size
    -- { key = 'h', mods = 'ALT', action = act.AdjustPaneSize { 'Left', 2 }, },
    --  { key = 'j', mods = 'ALT', action = act.AdjustPaneSize { 'Down', 2 }, },
    -- { key = 'k', mods = 'ALT', action = act.AdjustPaneSize { 'Up', 2 } },
    --  { key = 'l', mods = 'ALT', action = act.AdjustPaneSize { 'Right', 2 }, },
    ----------------------------------------------
    -- move between split panes
    --split_nav('move', 'h'),
    --split_nav('move', 'j'),
    --split_nav('move', 'k'),
    --split_nav('move', 'l'),
    -- resize panes
    --split_nav('resize', 'h'),
    --split_nav('resize', 'j'),
    --split_nav('resize', 'k'),
    --split_nav('resize', 'l'),
    {
        -- Y: YANK: activate copy mode
        key = 'y',
        mods = 'LEADER',
        action = wezterm.action.ActivateCopyMode,
    },
    -----------------------------------------------
    {
        -- C - Create New tab (window)
        key = 'c',
        mods = 'LEADER',
        action = act.SpawnTab 'CurrentPaneDomain',
    },
    -- N/P : Next/previous tab
    {
        key = 'n',
        mods = 'LEADER',
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        key = 'p',
        mods = 'LEADER',
        action = wezterm.action.ActivateTabRelative(-1),
    },
    { key = 't', mods = 'LEADER', action = wezterm.action.ShowTabNavigator },
    { key = "1", mods = "LEADER", action = wezterm.action { ActivateTab = 0 } },
    { key = "2", mods = "LEADER", action = wezterm.action { ActivateTab = 1 } },
    { key = "3", mods = "LEADER", action = wezterm.action { ActivateTab = 2 } },
    { key = "4", mods = "LEADER", action = wezterm.action { ActivateTab = 3 } },
    { key = "5", mods = "LEADER", action = wezterm.action { ActivateTab = 4 } },
    -- REARRANGE TABS:
    -- todo why not working{ key = "m", mods = "LEADER", action = act.ActivateKeyTable { name = "move_tab", one_shot = false } },

    {
        -- R: RENAME CURRENT TAB
        key = 'r',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(
                function(window, _, line)
                    if line then
                        window:active_tab():set_title(line)
                    end
                end
            ),
        },
    },
    -- x: close tab
    {
        key = 'x',
        mods = 'LEADER',
        action = act.CloseCurrentTab { confirm = true },
    },

    --- THEME SWITCHER
    {
        key = 'a',
        mods = 'LEADER',
        action = act.InputSelector
            {
                title = "🎨 Select a colorscheme:",
                fuzzy = true,
                fuzzy_description = '🎨 Select a colorscheme:',
                choices = {
                    {
                        id = 'Builtin Solarized Dark',
                        label = 'Solarized',
                    },
                    {
                        id = 'Dracula',
                        label = 'Dracula',
                    },
                    {
                        id = 'rose-pine-moon',
                        label = 'Rose Pine Moon',
                    },
                    {
                        id = 'Zenburn',
                        label = 'Zenburn',
                    },
                    {
                        id = 'nightfox',
                        label = 'Nightfox',
                    },
                    {
                        id = 'Nightfly (Gogh)',
                        label = 'Nightfly',
                    },
                    {
                        id = 'Gruvbox Dark (Gogh)',
                        label = 'Gruvbox',
                    },
                    {
                        id = 'Catppuccin Frappe',
                        label = 'Catppuccin',
                    },

                }, -- end choices

                action = wezterm.action_callback(
                    function(inner_window, inner_pane, id, _)
                        local config_path = "C:/Users/ha185116/.config/wezterm/wezterm.lua"
                        inner_window:perform_action(
                            act.SpawnCommandInNewTab({
                                args = {
                                    "sed",
                                    "-i",
                                    "/^config.color_scheme = /c\\config.color_scheme = '" .. id .. "'",
                                    config_path,
                                }, -- end args
                            }),    -- end SpawnCommandInNewTab
                            inner_pane
                        )          -- end inner_window:perform_action
                    end            -- function
                ),                 -- end wezterm.action_callback(

            },                     -- end action = act.InputSelector
    },                             -- end key

    ---- FONT SWITCHER
    {
        key = 'b',
        mods = 'LEADER',
        action = act.InputSelector
            {
                title = "🕮 Select a font:",
                fuzzy = true,
                fuzzy_description = '🕮 Select a font:',
                choices = {
                    {
                        id = 'Fira Code',
                        label = 'Fira Code',
                    },
                    {
                        id = 'Hack',
                        label = 'Hack',
                    },
                    {
                        id = 'Roboto Mono',
                        label = 'Roboto Mono',
                    },
                    {
                        id = 'Pragmasevka Nerd Font',
                        label = 'Pragmasevka',
                    },
                    {
                        id = 'Iosevka Nerd Font',
                        label = 'Iosevka',
                    },
                    {
                        id = 'CaskaydiaMono Nerd Font',
                        label = 'CaskaydiaMono',
                    },
                    {
                        id = 'JetBrains Mono',
                        label = 'JetBrains',
                    },
                    {
                        id = 'Victor Mono',
                        label = 'Victor',
                    },
                }, -- end choices
                action = wezterm.action_callback(
                    function(inner_window, inner_pane, id, _)
                        local config_path = "C:/Users/ha185116/.config/wezterm/wezterm.lua"
                        inner_window:perform_action(
                            act.SpawnCommandInNewTab({
                                args = {
                                    "sed",
                                    "-i",
                                    --config.font = wezterm.font_with_fallback { 'Hack',
                                    "/^config.font/c\\config.font  = wezterm.font_with_fallback { '" .. id .. "',",
                                    config_path,
                                }, -- end args
                            }),    -- end SpawnCommandInNewTab
                            inner_pane
                        )          -- end inner_window:perform_action
                    end            -- function
                ),                 -- end wezterm.action_callback(

            },                     -- end action = act.InputSelector
    },                             -- end key
}


config.mouse_bindings = {
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wezterm.action_callback(function(window, pane)
            local has_selection = window:get_selection_text_for_pane(pane) ~= ""
            if has_selection then
                window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
                window:perform_action(act.ClearSelection, pane)
            else
                window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
            end
        end),
    },
    {
        event = { Down = { streak = 1, button = { WheelUp = 1 } } },
        mods = "CTRL",
        action = act.IncreaseFontSize
    },
    {
        event = { Down = { streak = 1, button = { WheelDown = 1 } } },
        mods = "CTRL",
        action = act.DecreaseFontSize
    },
}


config.font  = wezterm.font_with_fallback { 'Iosevka Nerd Font',
    'DengXian',
    'nonicons',
}
config.warn_about_missing_glyphs = false


---------------------------
local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')
smart_splits.apply_to_config(config, {
    direction_keys = { 'h', 'j', 'k', 'l' },
    modifiers = {
        move = 'META',        -- modifier to use for pane movement, e.g. CTRL+h to move left
        resize = 'CTRL|META', -- modifier to use for pane resize, e.g. META+h to resize to the left
    },
    log_level = 'info',
})
--------------------------
config.window_close_confirmation = 'NeverPrompt'

--config.default_cwd = "C:/source/ncr-eps"
--config.default_prog = { 'pwsh.exe', '-NoLogo' }
return config
