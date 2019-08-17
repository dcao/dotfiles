local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")

local utils = {}

-- Create rounded rectangle shape
utils.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
        --gears.shape.octogon(cr, width, height, radius)
        --gears.shape.rounded_bar(cr, width, height)
    end
end

-- Create rectangle shape
utils.rect = function()
    return function(cr, width, height)
        gears.shape.rectangle(cr, width, height)
    end
end


return utils
