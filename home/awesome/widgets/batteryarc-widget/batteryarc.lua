-------------------------------------------------
-- Battery Arc Widget for Awesome Window Manager
-- Shows the battery level of the laptop
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/batteryarc-widget

-- @author Pavel Makhov
-- @copyright 2020 Pavel Makhov
-------------------------------------------------
-- modified by me 2026


local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")
local gears = require("gears")
local watch = require("awful.widget.watch")

local lgi = require 'lgi'
local Gio = lgi.require 'Gio'
local GLib = lgi.require 'GLib'

local HOME = os.getenv("HOME")
local WIDGET_DIR = HOME .. '/.config/awesome/widgets/batteryarc-widget'



local batteryarc_widget = {}
-- inside the dropdown
local profile_widget= {}
local battery_info_widget = {} 

local function set_power_profile(bus, profile_name)
    -- blocking calls are cringe
    local ok, err = pcall(function()
        return bus:call(
            "org.freedesktop.UPower.PowerProfiles",
            "/org/freedesktop/UPower/PowerProfiles",
            "org.freedesktop.DBus.Properties",
            "Set",
            GLib.Variant("(ssv)", {
                "org.freedesktop.UPower.PowerProfiles",
                "ActiveProfile",
                GLib.Variant("s", profile_name)
            }),
            nil, -- reply type
            Gio.DBusCallFlags.NONE,
            -1,
            nil,
            nil
        )
    end)
    if not ok then
        -- error handling
    end
end


local function worker(user_args)
    -- connect to the system bus
    local enable_profiles = true

    
    local args = user_args or {}

    local font = args.font or 'Play 6'
    local arc_thickness = args.arc_thickness or 2
    local show_current_level = args.show_current_level or false
    local size = args.size or 18
    local timeout = args.timeout or 10
    local show_notification_mode = args.show_notification_mode or 'on_hover' -- on_hover / on_click
    local notification_position = args.notification_position or 'top_right' -- see naughty.notify position argument

    local main_color = args.main_color or beautiful.fg_color
    local bg_color = args.bg_color or '#ffffff11'
    local low_level_color = args.low_level_color or '#e53935'
    local medium_level_color = args.medium_level_color or '#c0ca33'
    local charging_color = args.charging_color or '#43a047'

    local warning_msg_title = args.warning_msg_title or 'Houston, we have a problem'
    local warning_msg_text = args.warning_msg_text or 'Battery is dying'
    local warning_msg_position = args.warning_msg_position or 'bottom_right'
    local warning_msg_icon = args.warning_msg_icon or WIDGET_DIR .. '/spaceman.jpg'
    local enable_battery_warning = args.enable_battery_warning


    if enable_battery_warning == nil then
        enable_battery_warning = true
    end

    local popup = awful.popup{
        ontop = true,
        visible = false,
        -- shape = gears.shape.rounded_rect,
        border_width = 1,
        border_color = beautiful.bg_normal,
        maximum_width = 300,
        offset = { y = 5 },
        widget = { }
    }

    local popup_layout = { 
        {
            {
                markup = "...",
                align  = "center",
                widget = wibox.widget.textbox
            },
            {
                markup = "...",
                align  = "center",
                widget = wibox.widget.textbox
            },
            layout = wibox.layout.flex.vertical
        },
        -- profile_widget, 
        layout = wibox.layout.flex.vertical 
    }

    if enable_profiles then
        table.insert(popup_layout, {
            id = "profiles",
            layout = wibox.layout.flex.vertical
        })
    end

    popup:setup(popup_layout)

    -- Do not update process rows when mouse cursor is over the widget
    -- popup:connect_signal("mouse::enter", function() is_update = false end)
    -- popup:connect_signal("mouse::leave", function() is_update = true end)

    local text = wibox.widget {
        font = font,
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    }

    local text_with_background = wibox.container.background(text)

    batteryarc_widget = wibox.widget {
        text_with_background,
        max_value = 100,
        rounded_edge = true,
        thickness = arc_thickness,
        start_angle = 4.71238898, -- 2pi*3/4
        forced_height = size,
        forced_width = size,
        bg = bg_color,
        paddings = 2,
        widget = wibox.container.arcchart
    }

    batteryarc_widget:buttons(
        awful.button({}, 1, function()
            if popup.visible then
                popup.visible = not popup.visible
            else
                popup:move_next_to(mouse.current_widget_geometry)
            end
        end)
    )

    local last_battery_check = os.time()

    --[[ Show warning notification ]]
    local function show_battery_warning()
        naughty.notify {
            icon = warning_msg_icon,
            icon_size = 100,
            text = warning_msg_text,
            title = warning_msg_title,
            timeout = 25, -- show the warning for a longer time
            hover_timeout = 0.5,
            position = warning_msg_position,
            bg = "#F06060",
            fg = "#EEE9EF",
            width = 300,
        }
    end


    local function update_battery_popup(battery_info_widget, charge, state, tte, ttf)
        local state_tbl = {
            [0] = "Unknown",
            [1] = "Charging",
            [2] = "Discharging",
            [4] = "Fully Charged"
        }

        local battery_info_charge_state = battery_info_widget.children[1]
        local battery_info_remaining_state = battery_info_widget.children[2]

        battery_info_charge_state:set_markup( string.format("%d%%, %s", charge, state_tbl[state]))
        local time_est
        if state == 1 then
            time_est = ttf
        else 
            time_est = tte
        end

        if state == 1  or state == 2 then
            if time_est == 0 then
                battery_info_remaining_state:set_markup(string.format("Estimating"))
            else 
                battery_info_remaining_state:set_markup(string.format("%02d:%02d:%02d remaining", (time_est/3600), ((time_est/60)%60), (time_est%60) ))
            end
        else
            battery_info_remaining_state:set_markup(string.format("Fully Charged"))
        end
    end



    local function update_profile_widget(profile_widget, set_profile, profiles, active_profile) 
        profile_widget:reset()

        for _, profile_name in ipairs(profiles) do
            profile_widget:add( wibox.widget {
                {
                    checked = profile_name == active_profile,
                    color = "#ff0000",
                    paddings = 2,
                    shape = gears.shape.circle,
                    widget = wibox.widget.checkbox, 
                    buttons = gears.table.join(
                        awful.button({}, 1, function()
                            set_profile(profile_name)
                        end)
                    )
                },
                {
                    markup = profile_name,
                    align = 'center',
                    valign = 'center',
                    widget = wibox.widget.textbox,
                },
                -- id = profile["Profile"],
                layout = wibox.layout.flex.horizontal
            })
        end
    end

    local function update_arc_widget(widget, charge, state)

        local isCharging = state == 1 or state == 4
        -- state 4 is fully charged
        if state == 4 then
            chage = 100
        end
        -- update the value
        widget.value = charge

        if isCharging == true then
            text_with_background.bg = charging_color
            text_with_background.fg = '#000000'
        else
            text_with_background.bg = '#00000000'
            text_with_background.fg = main_color
        end

        if show_current_level == true then
            --- if battery is fully charged (100) there is not enough place for three digits, so we don't show any text
            text.text = charge == 100
                    and ''
                    or string.format('%d', charge)
        else
            text.text = ''
        end

        if charge < 15 and charge > 0 then
            widget.colors = { low_level_color }
            if enable_battery_warning and isCharging == false and os.difftime(os.time(), last_battery_check) > 300 then
                -- if 5 minutes have elapsed since the last warning
                last_battery_check = os.time()

                show_battery_warning()
            end
        elseif charge > 15 and charge < 40 then
            widget.colors = { medium_level_color }
        else
            widget.colors = { main_color }
        end
    end


    local function conv_profiles_gobject(profiles)    
        local lst = {}
        for i = 0, profiles:n_children()-1 do
            lst[#lst+1] = profiles:get_child_value(i).value["Profile"]
        end
        return lst
    end
    
    local function dbus_setup()
        Gio.bus_get(Gio.BusType.SYSTEM, nil, function(_,res)
            local ok, bus = pcall(Gio.bus_get_finish, res)
            if not ok then
                naughty.notify{text = "failed to connect to system bus"}
            end

            bus_setup_cancel = Gio.Cancellable.new()
            
            Gio.DBusProxy.new(
                bus,
                Gio.DBusProxyFlags.NONE,
                nil,        -- GDBusInterfaceInfo (optional)
                "org.freedesktop.UPower",
                "/org/freedesktop/UPower/devices/DisplayDevice",
                "org.freedesktop.UPower.Device",
                bus_cancel_setup,         -- cancellable
                function(_, res)
                    local ok, batt_proxy =  pcall(function() return Gio.DBusProxy.new_finish(res) end)
                    if not ok then
                        naughty.notify{text = "Failed to connect to UPower display device with error: " .. tostring(batt_proxy)}
                    end
                    -- batteryarc_widget.batt_proxy = batt_proxy
                    -- initial setup
                    local percentage = batt_proxy:get_cached_property("Percentage").value
                    local state = batt_proxy:get_cached_property("State").value

                    update_arc_widget(batteryarc_widget, percentage, state)
                    update_battery_popup(popup.widget.children[1], percentage, state, batt_proxy:get_cached_property("TimeToEmpty").value, batt_proxy:get_cached_property("TimeToFull").value)
                    
                    -- naughty.notify{text = "connected to display device"}
                    -- on change handler
                    batt_proxy.on_g_properties_changed = function(_, changed, invalidated) 
                        local charge = batt_proxy:get_cached_property("Percentage").value
                        local state = batt_proxy:get_cached_property("State").value
                        local tte = batt_proxy:get_cached_property("TimeToEmpty").value
                        local ttf = batt_proxy:get_cached_property("TimeToFull").value
                        update_arc_widget(batteryarc_widget, charge, state) 
                        update_battery_popup(popup.widget.children[1], charge, state, tte, ttf)
                        -- naughty.notify{text = "batt_state_update"}
                    end
                    -- naughty.notify{text = "batt_state_update end"}
                end,
                nil
            )

            if enable_profiles then
                Gio.DBusProxy.new(
                    bus,
                    Gio.DBusProxyFlags.NONE,
                    nil,        -- GDBusInterfaceInfo (optional)
                    "org.freedesktop.UPower.PowerProfiles",
                    "/org/freedesktop/UPower/PowerProfiles",
                    "org.freedesktop.UPower.PowerProfiles",
                    bus_cancel_setup,        -- cancellable
                    function(_, res) 
                        local ok, profiles_proxy =  pcall(function() return Gio.DBusProxy.new_finish(res) end)
                        if not ok then
                            naughty.notify {text = "failed to connect to profiles proxy with error: " .. tostring(profiles_proxy)}
                        end

                        local function set_profile(name)
                            set_power_profile(bus, name)
                        end

                        local active_profile = profiles_proxy:get_cached_property("ActiveProfile").value
                        local profiles = conv_profiles_gobject(profiles_proxy:get_cached_property("Profiles"))
                        update_profile_widget(popup.widget.children[2], set_profile, profiles, active_profile)
                        
                        profiles_proxy.on_g_properties_changed = function(_, changed, invalidated) 
                            local active_profile = profiles_proxy:get_cached_property("ActiveProfile").value
                            local profiles = conv_profiles_gobject(profiles_proxy:get_cached_property("Profiles"))
                            update_profile_widget(popup.widget.children[2], set_profile, profiles, active_profile)
                            -- naughty.notify{text = "profile_state_update"}
                        end
                        -- naughty.notify{text = "profile_state_update end"}
                    end,
                    nil
                )
            end
        end)
    end
    dbus_setup()

    return batteryarc_widget
end

return setmetatable(batteryarc_widget, { __call = function(_, ...)
    return worker(...)
end })
