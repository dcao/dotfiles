---------------------------
-- gruv awesome theme --
---------------------------

local theme_name = "gruv"
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local home = os.getenv("HOME");
local theme_folder = "~/.config/awesome/themes/" .. theme_name .. "/"

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font = "Iosevka 10"

local base00 = "#282828"; -- ----
local base01 = "#3c3836"; -- ---
local base02 = "#504945"; -- --
local base03 = "#665c54"; -- -
local base04 = "#bdae93"; -- +
local base05 = "#d5c4a1"; -- ++
local base06 = "#ebdbb2"; -- +++
local base07 = "#fbf1c7"; -- ++++
local base08 = "#fb4934"; -- red
local base09 = "#fe8019"; -- orange
local base0A = "#fabd2f"; -- yellow
local base0B = "#b8bb26"; -- green
local base0C = "#8ec07c"; -- aqua/cyan
local base0D = "#83a598"; -- blue
local base0E = "#d3869b"; -- purple
local base0F = "#d65d0e"; -- brown

theme.bg_normal     = base00
theme.bg_focus      = base0D
theme.bg_urgent     = base08
theme.bg_minimize   = base02
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = base04
theme.fg_focus      = base00
theme.fg_urgent     = base00
theme.fg_minimize   = base04

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.screen_margin = dpi(16)
theme.border_normal = base00
theme.border_focus  = base0D
theme.border_marked = base0C

-- There are other variable sets
-- overriding the gruv one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme_folder .. "submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = theme_folder .. "titlebar/close_normal.png"
theme.titlebar_close_button_focus  = theme_folder .. "titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = theme_folder .. "titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = theme_folder .. "titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = theme_folder .. "titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = theme_folder .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = theme_folder .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = theme_folder .. "titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = theme_folder .. "titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = theme_folder .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = theme_folder .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = theme_folder .. "titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = theme_folder .. "titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = theme_folder .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = theme_folder .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = theme_folder .. "titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = theme_folder .. "titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme_folder .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = theme_folder .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = theme_folder .. "titlebar/maximized_focus_active.png"

theme.wallpaper = "~/.world-wall.png"

-- You can use your own layout icons like this:
theme.layout_fairh = theme_folder .. "layouts/fairhw.png"
theme.layout_fairv = theme_folder .. "layouts/fairvw.png"
theme.layout_floating  = theme_folder .. "layouts/floatingw.png"
theme.layout_magnifier = theme_folder .. "layouts/magnifierw.png"
theme.layout_max = theme_folder .. "layouts/maxw.png"
theme.layout_fullscreen = theme_folder .. "layouts/fullscreenw.png"
theme.layout_tilebottom = theme_folder .. "layouts/tilebottomw.png"
theme.layout_tileleft   = theme_folder .. "layouts/tileleftw.png"
theme.layout_tile = theme_folder .. "layouts/tilew.png"
theme.layout_tiletop = theme_folder .. "layouts/tiletopw.png"
theme.layout_spiral  = theme_folder .. "layouts/spiralw.png"
theme.layout_dwindle = theme_folder .. "layouts/dwindlew.png"
theme.layout_cornernw = theme_folder .. "layouts/cornernww.png"
theme.layout_cornerne = theme_folder .. "layouts/cornernew.png"
theme.layout_cornersw = theme_folder .. "layouts/cornersww.png"
theme.layout_cornerse = theme_folder .. "layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
