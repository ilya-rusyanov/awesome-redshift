--- Redshift for Awesome WM
-- Copyright (c) 2013  Ryan Young <ryan .ry. young@gmail. com> (omit spaces)
--
-- https://github.com/troglobit/awesome-redshift
--

-- standard libraries
local awful = require("awful")

local naughty = require("naughty")

-- variables
local redshift = {}
redshift.redshift = "/usr/bin/redshift"    -- binary path
redshift.method   = "randr"                -- randr or vidmode
redshift.options  = ""                     -- additional redshift command options
redshift.state    = 1                      -- 1 for screen dimming, 0 for none
redshift.timer    = timer({ timeout = 60 })

-- functions
function redshift.dim()
    if redshift.method == "randr" then
        awful.spawn.single_instance(redshift.redshift .. " -m randr -o " .. redshift.options)
    elseif redshift.method == "vidmode" then
        local screens = screen.count()
        for i = 0, screens - 1 do
            awful.spawn.single_instance(redshift.redshift .. " -m vidmode:screen=" .. i ..
                             " -o " .. redshift.options)
        end
    end
    redshift.state = 1
    redshift.timer:start()
end

redshift.timer:connect_signal("timeout", redshift.dim)
function redshift.undim()
    if redshift.method == "randr" then
        awful.spawn.single_instance(redshift.redshift .. " -m randr -x " .. redshift.options)
    elseif redshift.method == "vidmode" then
        local screens = screen.count()
        for i = 0, screens - 1 do
            awful.spawn.single_instance(redshift.redshift .. " -m vidmode:screen=" .. i ..
                             " -x " .. redshift.options)
        end
    end
    redshift.state = 0
    redshift.timer:stop()
end

function redshift.toggle()
    if redshift.state == 1 then
        redshift.undim()
        naughty.notify({ text = "redshift pause" })
    else
        redshift.dim()
        naughty.notify({ text = "redshift resume" })
    end
end

function redshift.init(state)
    if state == 1 then
        redshift.dim()
    else
        redshift.undim()
    end
end

return redshift
