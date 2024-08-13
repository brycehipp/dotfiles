local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}
local mod = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- if platform.is_mac then
mod.SUPER = 'SUPER'
mod.SUPER_PLUS = 'SUPER|OPT'
  --  mod.SUPER_REV = 'SUPER|CTRL'
-- elseif platform.is_win or platform.is_linux then
  --  mod.SUPER = 'ALT' -- to not conflict with Windows key shortcuts
  --  mod.SUPER_REV = 'ALT|CTRL'
-- end

config.set_environment_variables = {
  PATH = '/opt/homebrew/bin:' .. os.getenv('PATH')
}

-- Colors
-- config.color_scheme = 'Squirrelsong Dark'
config.color_scheme = 'Dark+'

-- Font
config.font = wezterm.font 'Dank Mono'
config.font_size = 16
config.line_height = 1.2

-- Sets the font for the window frame (tab bar)
config.window_frame = {
  font = wezterm.font({ family = 'Verdana', weight = 'Bold' }),
  font_size = 12,
}

-- Command Palette
config.command_palette_rows = 7
config.command_palette_font_size = 14


-- Hot keys
config.keys = {
  -- Make Page up/down work
	{ key = 'PageUp', action = wezterm.action.ScrollByPage(-1) },
	{ key = 'PageDown', action = wezterm.action.ScrollByPage(1) },

  -- moving left and right between tabs
  {
    key = 'LeftArrow',
    mods = mod.SUPER_PLUS,
    action = act.ActivateTabRelative(-1),
  },
  {
    key = 'RightArrow',
    mods = mod.SUPER_PLUS,
    action = act.ActivateTabRelative(1),
  },

  -- move to start and end of line
  {
    key = 'LeftArrow',
    mods = mod.SUPER,
    action = act.SendString '\x1bOH'
  },
  {
    key = 'RightArrow',
    mods = mod.SUPER,
    action = act.SendString '\x1bOF'
  },

  -- opening settings in vs code
  {
    key = ',',
    mods = mod.SUPER,
    action = wezterm.action.SpawnCommandInNewTab {
      cwd = wezterm.home_dir,
      args = { 'code', wezterm.config_file },
    },
  },

  -- set command palaette to cmd+shift+p like vs code
  {
    key = 'P',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.ActivateCommandPalette,
  },

  -- Case-insensitive search
	{
		key = 'f',
		mods = 'CMD',
		action = wezterm.action.Search({ CaseInSensitiveString = '' }),
	},
}

-- Mouse
config.mouse_bindings = {
	-- Change the default click behavior so that it only selects
	-- text and doesn't open hyperlinks
	{
		event = { Up = { streak = 1, button = 'Left' } },
		mods = 'NONE',
		action = wezterm.action.CompleteSelection('ClipboardAndPrimarySelection'),
	},

	-- Open links on Cmd+click
	{
		event = { Up = { streak = 1, button = 'Left' } },
		mods = 'CMD',
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

-- Misc
config.adjust_window_size_when_changing_font_size = false
config.cursor_thickness = 2
config.default_cursor_style = 'BlinkingBar'
config.default_cwd = wezterm.home_dir
config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.inactive_pane_hsb = { saturation = 1.0, brightness = 0.8}
config.scrollback_lines = 10000
config.show_new_tab_button_in_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true
config.tab_max_width = 60
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = { left = 8, right = 8, top = 12, bottom = 8}
config.window_background_opacity = 0.95
config.macos_window_background_blur = 80

local function segments_for_right_status(window)
  return {
    -- window:active_workspace(),
    wezterm.strftime('%a %b %-d %H:%M'),
    -- wezterm.hostname(),
  }
end

wezterm.on("update-right-status", function(window, _)
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  local segments = segments_for_right_status(window)

  local color_scheme = window:effective_config().resolved_palette
  -- Note the use of wezterm.color.parse here, this returns
  -- a Color object, which comes with functionality for lightening
  -- or darkening the colour (amongst other things).
  local bg = wezterm.color.parse(color_scheme.background)
  local fg = color_scheme.foreground

  -- Each powerline segment is going to be coloured progressively
  -- darker/lighter depending on whether we're on a dark/light colour
  -- scheme. Let's establish the "from" and "to" bounds of our gradient.
  local gradient_to, gradient_from = bg
  gradient_from = gradient_to:lighten(0.2)

  -- Yes, WezTerm supports creating gradients, because why not?! Although
  -- they'd usually be used for setting high fidelity gradients on your terminal's
  -- background, we'll use them here to give us a sample of the powerline segment
  -- colours we need.
  local gradient = wezterm.color.gradient(
    {
      orientation = 'Horizontal',
      colors = { gradient_from, gradient_to },
    },
    #segments -- only gives us as many colours as we have segments.
  )

  -- We'll build up the elements to send to wezterm.format in this table.
  local elements = {}

  for i, seg in ipairs(segments) do
    local is_first = i == 1

    if is_first then
      table.insert(elements, { Background = { Color = 'none' } })
    end
    table.insert(elements, { Foreground = { Color = gradient[i] } })
    table.insert(elements, { Text = SOLID_LEFT_ARROW })

    table.insert(elements, { Foreground = { Color = fg } })
    table.insert(elements, { Background = { Color = gradient[i] } })
    table.insert(elements, { Text = ' ' .. seg .. ' ' })
  end

  window:set_right_status(wezterm.format(elements))
end);

-- and finally, return the configuration to wezterm
return config
