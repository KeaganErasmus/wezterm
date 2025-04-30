-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
-- This will hold the configuration.
local config = wezterm.config_builder()


config.front_end = "OpenGL"
config.max_fps = 144
-- config.default_cursor_style = "SteadyBar"
-- config.animation_fps = 1
-- config.cursor_blink_rate = 500
config.term = "xterm-256color" -- Set the terminal type

config.cell_width = 0.9

config.window_background_opacity = 0.9
config.prefer_egl = true
config.font_size = 14.0

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- tabs
-- config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- Font Thingies
local fonts = {
  { family = "Roboto Mono", weight = "Bold" },
  { family = "JetBrains Mono", weight = "Bold" },
  { family = "RandyGG", weight = "Bold" },
}
local current_font_index = 1

-- keymaps
config.keys = {
  {
    key = "h",
    mods = "CTRL|SHIFT|ALT",
    action = wezterm.action.SplitPane({
      direction = "Right",
      size = { Percent = 50 },
    }),
  },
  {
    key = "U",
    mods = "CTRL|SHIFT",
    action = act.AdjustPaneSize({ "Left", 5 }),
  },
  {
    key = "I",
    mods = "CTRL|SHIFT",
    action = act.AdjustPaneSize({ "Down", 5 }),
  },
  {
    key = "O",
    mods = "CTRL|SHIFT",
    action = act.AdjustPaneSize({ "Up", 5 }),
  },
  {
    key = "P",
    mods = "CTRL|SHIFT",
    action = act.AdjustPaneSize({ "Right", 5 }),
  },
  { key = "g", mods = "CTRL", action = act.PaneSelect },
  -- { key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
  {
    key = "O",
    mods = "CTRL|ALT",
    -- toggling opacity
    action = wezterm.action_callback(function(window, _)
      local overrides = window:get_config_overrides() or {}
      if overrides.window_background_opacity == 1.0 then
        overrides.window_background_opacity = 0.9
      else
        overrides.window_background_opacity = 1.0
      end
      window:set_config_overrides(overrides)
    end),
  },
  {
    key = "F",
    mods = "CTRL|ALT",
    action = wezterm.action_callback(function(window, _)
      local overrides = window:get_config_overrides() or {}

      -- Cycle to the next font
      current_font_index = current_font_index + 1
      if current_font_index > #fonts then
	current_font_index = 1
      end

      local font = fonts[current_font_index]
      overrides.font = wezterm.font({
	family = font.family,
	weight = font.weight,
      })

      window:set_config_overrides(overrides)
      window:toast_notification("Font Switched", font.family .. " (" .. font.weight .. ")", nil, 4000)
    end),
  },
}

-- For example, changing the color scheme:
-- config.color_scheme = "Cloud (terminal.sexy)"
config.colors = {
  background = "#181818",
  cursor_border = "#bea3c7",
  cursor_bg = "#bea3c7",

  tab_bar = {
    background = "#181818",
    active_tab = {
      bg_color = "#0c0b0f",
      fg_color = "#bea3c7",
      intensity = "Normal",
      italic = false,
    },
    inactive_tab = {
      bg_color = "#0c0b0f",
      fg_color = "#f8f2f5",
      intensity = "Normal",
      underline = "None",
      italic = true,
      strikethrough = false,
    },

    new_tab = {
      bg_color = "#0c0b0f",
      fg_color = "white",
    },
  },
}

config.window_frame = {
  active_titlebar_bg = "#0c0b0f",
}

local is_linux = function()
	return wezterm.target_triple:find("linux") ~= nil
end

config.window_decorations = "NONE | RESIZE"
if not is_linux() then
  config.default_prog = { "powershell.exe", "-NoLogo", "-ExecutionPolicy", "RemoteSigned" }
end
config.initial_cols = 80

-- and finally, return the configuration to wezterm
return config
