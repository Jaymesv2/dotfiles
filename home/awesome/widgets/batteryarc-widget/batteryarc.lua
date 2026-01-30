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

local function worker(user_args)
    -- connect to the system bus

    local bus = Gio.bus_get_sync(Gio.BusType.SYSTEM)

    local batt_proxy = Gio.DBusProxy.new_sync(
      bus,
      Gio.DBusProxyFlags.NONE,
      nil,        -- GDBusInterfaceInfo (optional)
      "org.freedesktop.UPower",
      "/org/freedesktop/UPower/devices/DisplayDevice",
      "org.freedesktop.UPower.Device",
      nil         -- cancellable
    )

    local profiles_proxy = Gio.DBusProxy.new_sync(
      bus,
      Gio.DBusProxyFlags.NONE,
      nil,        -- GDBusInterfaceInfo (optional)
      "org.freedesktop.UPower.PowerProfiles",
      "/org/freedesktop/UPower/PowerProfiles",
      "org.freedesktop.UPower.PowerProfiles",
      nil         -- cancellable
    )
    
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

    battery_info_charge_state = wibox.widget {
        id = "charge_state",
        markup = "",
        align  = "center",
        widget = wibox.widget.textbox
    }
    battery_info_remaining_state = wibox.widget {
        id = "remaining_state",
        markup = "",
        align  = "center",
        widget = wibox.widget.textbox
    }

    battery_info_widget = wibox.widget {
        battery_info_charge_state,
        battery_info_remaining_state,
        layout = wibox.layout.flex.vertical
    }



    local state_tbl = {
        [0] = "Unknown",
        [1] = "Charging",
        [2] = "Discharging",
        [4] = "Fully Charged"
    }

    local update_battery_info = function()
        local state = batt_proxy:get_cached_property("State").value
        local charge = batt_proxy:get_cached_property("Percentage").value
        local tte = batt_proxy:get_cached_property("TimeToEmpty").value
        local ttf = batt_proxy:get_cached_property("TimeToFull").value

        battery_info_charge_state:set_markup( string.format("%d%%, %s", charge, state_tbl[state]))
        if state == 1  then
            if ttf == 0 then
                battery_info_remaining_state:set_markup(string.format("Estimating"))
            else 
                battery_info_remaining_state:set_markup(string.format("%02d:%02d:%02d remaining", (ttf/3600), ((ttf/60)%60), (ttf%60) ))
            end
        elseif state == 2 then
            if tte == 0 then
                battery_info_remaining_state:set_markup(string.format("Estimating"))
            else 
                battery_info_remaining_state:set_markup(string.format("%02d:%02d:%02d remaining", (tte/3600), ((tte/60)%60), (tte%60) ))
            end
        elseif state == 4 then
            battery_info_remaining_state:set_markup(string.format("Fully Charged"))
        end
    end

    update_battery_info()

    -- I hate this so much   
    -- This table maps the names of the power profiles to child ids of the profile_widget
    profile_widgets_name_map = {}

    local function initial_profile_widget() 

        -- make the profiles widget 
        local profiles = profiles_proxy:get_cached_property("Profiles")
        local profile_widget = wibox.layout.flex.vertical()
        
        for i = 0, profiles:n_children()-1 do
            local profile = profiles:get_child_value(i).value
            profile_widgets_name_map[profile["Profile"]] = i+1 

            local checkbox = wibox.widget.checkbox()

            checkbox.checked        = true
            checkbox.color          = "#ff0000"
            checkbox.paddings       = 2
            checkbox.shape          = gears.shape.circle

            checkbox:buttons(
                awful.button({}, 1, function()
                    local BUS_NAME = "org.freedesktop.UPower.PowerProfiles"
                    local OBJ_PATH = "/org/freedesktop/UPower/PowerProfiles"
                    local IFACE    = "org.freedesktop.UPower.PowerProfiles"

                    local params = GLib.Variant("(ssv)", {
                        IFACE,
                        "ActiveProfile",
                        GLib.Variant("s", profile["Profile"]),
                    })
                    -- blocking calls are cringe
                    local ok, err = pcall(function()
                        return bus:call(
                            BUS_NAME,
                            OBJ_PATH,
                            "org.freedesktop.DBus.Properties",
                            "Set",
                            params,
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
                end)
            )


            profile_widget:add( wibox.widget {
                checkbox,
                {
                    markup = profile["Profile"],
                    align = 'center',
                    valign = 'center',
                    widget = wibox.widget.textbox,
                },
                -- id = profile["Profile"],
                layout = wibox.layout.flex.horizontal
            })
        end
        return profile_widget
    end


    profile_widget = initial_profile_widget()



    local update_profiles = function() 
        local profiles = profiles_proxy:get_cached_property("Profiles")
        local active_profile = profiles_proxy:get_cached_property("ActiveProfile").value

        local num_profiles = profiles:n_children()
        for i = 0, num_profiles-1 do
            local profile = profiles:get_child_value(i).value
            local is_active = profile["Profile"] == active_profile
            profile_widget.children[profile_widgets_name_map[profile["Profile"]]].children[1].checked = is_active
        end
    end

    update_profiles()


    popup:setup { battery_info_widget, profile_widget, layout = wibox.layout.flex.vertical }

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
            awful.util.table.join(
                    -- button
                    awful.button({}, 1, function()
                        if popup.visible then
                            popup.visible = not popup.visible
                        else
                            popup:move_next_to(mouse.current_widget_geometry)
                        end
                    end)
            )
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

    local function update_arc_widget(widget)
        local charge = batt_proxy:get_cached_property("Percentage").value
        local state = batt_proxy:get_cached_property("State").value

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

    update_arc_widget(batteryarc_widget)
    
    batt_proxy.on_g_properties_changed = function(_, changed, invalidated) 
        update_arc_widget(batteryarc_widget) 
        update_battery_info()
    end
    profiles_proxy.on_g_properties_changed = function(_, changed, invalidated) 
        update_profiles()
    end

    return batteryarc_widget

end

return setmetatable(batteryarc_widget, { __call = function(_, ...)
    return worker(...)
end })
