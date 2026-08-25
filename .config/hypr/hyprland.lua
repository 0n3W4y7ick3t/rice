-- Hyprland config, ported from dwm (binds mirror the old dwm config.h).
-- Lua port of hyprland.conf (hyprlang support ends at Hyprland 0.57).
-- Machine-specific bits (monitors, env, input quirks) live in machine.lua,
-- selected per machine by yadm class alternates.

-- MOD is a global on purpose: machine.lua binds keys too (hyprexpo on the
-- desktop), and require() shares globals but not locals -- a local here
-- would be nil over there and the bind would never fire.
MOD = "SUPER"
local term = "kitty"

-- Define the browser here rather than leaning on $BROWSER from the
-- environment: the config is evaluated at (re)load, so a value read from the
-- environment freezes to whatever it was when the compositor started --
-- editing shell/profile afterwards has no effect until a full restart, and a
-- stale name makes the bind silently launch a binary that does not exist.
-- That is exactly what happened: mod+W was baked to "firefox", not installed.
local browser = "google-chrome-stable"

-- Anything that is true of one machine only -- monitors, GPU env, input
-- quirks, distro-specific autostarts and plugins -- lives here, picked by
-- yadm class. Nothing below this line may assume a distro.
require("machine")

-- Cursor theme, fleet-wide (the package comes from the system layer:
-- @hyprland set on Gentoo, AUR list on Arch). XCURSOR_* covers Hyprland and
-- XWayland; GTK apps read gtk-cursor-theme-name from gtk-3.0/settings.ini.
hl.env("XCURSOR_THEME", "macOS")
-- nominal size is doubled by the scale-2 monitors; 20 renders at 40px
hl.env("XCURSOR_SIZE", "20")

hl.config({
    general = {
        layout = "master",
        border_size = 2,
        gaps_in = { top = 4, right = 3, bottom = 4, left = 3 },
        gaps_out = { top = 10, right = 8, bottom = 10, left = 8 },
        col = {
            active_border = "rgb(7AA2F7)",
            inactive_border = "rgb(1A1B26)",
        },
    },

    master = {
        mfact = 0.55,
        new_status = "master",
        new_on_top = true,
        slave_count_for_center_master = 0,
    },

    decoration = {
        rounding = 0,
        blur = {
            enabled = true,
            -- picom used gaussian size=40 deviation=20 ("frosted glass"). size 8 +
            -- passes 3 smeared the backdrop flat, so with kitty at 0.8 opacity there
            -- was nothing recognisable behind the text. Smaller radius keeps some
            -- structure; brightness/vibrancy stop the result washing out to grey.
            size = 6,
            passes = 3,
            brightness = 0.8,
            vibrancy = 0.35,
            contrast = 1.0,
            noise = 0.02,
        },
    },

    misc = {
        enable_swallow = true,
        -- class regex, not a command; kitty's class is its binary name so term fits
        swallow_regex = "^(" .. term .. ")$",
        vrr = 0,
        -- let apps raise themselves (dunst click -> slack focuses its window)
        focus_on_activate = true,
        -- yadm alt unlinks machine.lua for an instant; an autoreload landing in
        -- that gap fails the require() and drops every monitor rule to the
        -- generic one. Reloads are explicit only (MOD+F5, and the yadm hooks
        -- after alt).
        disable_autoreload = true,
    },

    input = {
        repeat_rate = 50,
        repeat_delay = 300,
    },

    cursor = {
        inactive_timeout = 3,
    },
})

-- No persistent=true on 1-9 so the bar lists only occupied workspaces.

-- Scratchpads (dwm's spterm/spcalc)
hl.workspace_rule({ workspace = "special:spterm", on_created_empty = term .. " --class spterm" })
hl.workspace_rule({ workspace = "special:spcalc", on_created_empty = term .. " --class spcalc -e bc -lq" })
hl.window_rule({ match = { class = "^(spterm)$" }, float = true, center = true, size = { 1150, 720 } })
hl.window_rule({ match = { class = "^(spcalc)$" }, float = true, center = true, size = { 480, 420 } })
hl.window_rule({ match = { class = "^(floatterm)$" }, float = true })
hl.window_rule({ match = { class = "^(clipimg)$" }, float = true, center = true, size = { 1000, 760 } })
-- telegram requests activation on every incoming message; don't follow it,
-- just flag urgent (misc focus_on_activate stays on for notification clicks)
hl.window_rule({ match = { class = "^(org\\.telegram\\.desktop|TelegramDesktop)$" }, focus_on_activate = false })

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("sleep 1 && setbg")
    hl.exec_cmd("dunst")
    hl.exec_cmd("fcitx5 -d")
    -- per-chat IM hints for the autolang addon (no-op without a chatlang-map)
    hl.exec_cmd("fcitx5-chatlang")
    hl.exec_cmd("gammastep")
    hl.exec_cmd("mpd")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    -- daily passphrase-rehearsal nudge; no-op unless the machine configures it
    hl.exec_cmd("passdrill check")
    -- polkitd answers on D-Bus but never draws anything: without an agent every
    -- GUI privilege prompt fails with no visible reason at all. Path differs by
    -- distro: /usr/libexec (Gentoo) vs /usr/lib (Arch).
    hl.exec_cmd("exec /usr/libexec/hyprpolkitagent 2>/dev/null || exec /usr/lib/hyprpolkitagent")
    -- Session restore (.scripts/hypr-session): reopen last session's windows on
    -- their workspaces, then keep snapshotting every 60s. sysact saves exactly
    -- before leave/reboot/shutdown. Kill switch: touch ~/.local/state/hypr-session/disabled
    hl.exec_cmd("sleep 2 && hypr-session restore")
    hl.exec_cmd("hypr-session daemon")
end)

-- Window/stack management
hl.bind(MOD .. " + J", hl.dsp.window.cycle_next())
hl.bind(MOD .. " + K", hl.dsp.window.cycle_next({ next = false }))
hl.bind(MOD .. " + SHIFT + J", hl.dsp.window.swap({ next = true }))
hl.bind(MOD .. " + SHIFT + K", hl.dsp.window.swap({ prev = true }))
hl.bind(MOD .. " + CTRL + space", hl.dsp.layout("focusmaster"))
hl.bind(MOD .. " + space", hl.dsp.layout("swapwithmaster"))
hl.bind(MOD .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(MOD .. " + Q", hl.dsp.window.close())
hl.bind(MOD .. " + SHIFT + Q", hl.dsp.exec_cmd("hypr-quit")) -- really quit the app; tray apps only hide on mod+Q
hl.bind(MOD .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(MOD .. " + H", hl.dsp.layout("mfact -0.05"))
hl.bind(MOD .. " + L", hl.dsp.layout("mfact +0.05"))
hl.bind(MOD .. " + O", hl.dsp.layout("addmaster"))
hl.bind(MOD .. " + SHIFT + O", hl.dsp.layout("removemaster"))
hl.bind(MOD .. " + S", hl.dsp.window.pin())
hl.bind(MOD .. " + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))

-- Layouts (dwm-style glyphs published by hypr-layout)
hl.bind(MOD .. " + T", hl.dsp.exec_cmd("hypr-layout tile"))
hl.bind(MOD .. " + SHIFT + T", hl.dsp.exec_cmd("hypr-layout bstack"))
hl.bind(MOD .. " + Y", hl.dsp.exec_cmd("hypr-layout spiral"))
hl.bind(MOD .. " + SHIFT + Y", hl.dsp.exec_cmd("hypr-layout dwindle"))
hl.bind(MOD .. " + U", hl.dsp.exec_cmd("hypr-layout deck"))
hl.bind(MOD .. " + SHIFT + U", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(MOD .. " + I", hl.dsp.exec_cmd("hypr-layout centered"))
hl.bind(MOD .. " + SHIFT + I", hl.dsp.exec_cmd("hypr-layout centered"))

-- Gaps
hl.bind(MOD .. " + A", hl.dsp.exec_cmd("hypr-gaps toggle"))
hl.bind(MOD .. " + SHIFT + A", hl.dsp.exec_cmd("hypr-gaps default"))
hl.bind(MOD .. " + Z", hl.dsp.exec_cmd("hypr-gaps dec"))
hl.bind(MOD .. " + X", hl.dsp.exec_cmd("hypr-gaps inc"))
hl.bind(MOD .. " + SHIFT + Z", hl.dsp.exec_cmd("hypr-gaps smart"))

-- Workspaces 1-9 (+Shift silent move)
hl.bind(MOD .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(MOD .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(MOD .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(MOD .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(MOD .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(MOD .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(MOD .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(MOD .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(MOD .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(MOD .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind(MOD .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind(MOD .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind(MOD .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind(MOD .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind(MOD .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind(MOD .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind(MOD .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind(MOD .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9, follow = false }))
hl.bind(MOD .. " + 0", hl.dsp.exec_cmd("hypr-windows"))
-- hyprexpo overview. The plugin itself is loaded per machine (machine.lua:
-- portage .so path on the desktop, hyprpm on the laptop); the guard makes
-- this a dead key anywhere it is missing. Plugin lua functions act
-- immediately when called (unlike hl.dsp.*) -- no hl.dispatch here.
hl.bind(MOD .. " + SHIFT + 0", function() if hl.plugin.hyprexpo then hl.plugin.hyprexpo.expo("toggle") end end) -- hyprexpo:expo toggle
-- Plugin config keys exist only once a .so registers them; the config is
-- re-evaluated on plugin load, so this block is skipped on the first pass
-- and applied on the second (wiki Using-Plugins pattern).
if hl.plugin.hyprexpo then
    -- no gap_size: the sandwichfarm fork registers gaps_in/gaps_out instead,
    -- and the old hyprlang config's gap_size=8 was silently ignored for the
    -- same reason -- the look everyone knows is the fork's defaults.
    hl.config({
        plugin = {
            hyprexpo = {
                columns = 3,
                bg_col = "rgb(1A1B26)",
                workspace_method = "center current",
            },
        },
    })
end
hl.bind(MOD .. " + Tab", hl.dsp.focus({ workspace = "previous" }))
hl.bind(MOD .. " + G", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(MOD .. " + semicolon", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(MOD .. " + SHIFT + G", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind(MOD .. " + SHIFT + semicolon", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(MOD .. " + Prior", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(MOD .. " + Next", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(MOD .. " + SHIFT + Prior", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind(MOD .. " + SHIFT + Next", hl.dsp.window.move({ workspace = "r+1" }))

-- plain = focus the other monitor, shift = throw the whole workspace there,
-- ctrl = carry just the active window (all no-ops on a single monitor, so
-- these live in the shared config; 2026-08-21 rework of the old
-- focus/movewindow pair that shadowed the desktop's workspace throw)

-- Monitors
hl.bind(MOD .. " + left", hl.dsp.focus({ monitor = "-1" }))
hl.bind(MOD .. " + right", hl.dsp.focus({ monitor = "+1" }))
hl.bind(MOD .. " + SHIFT + left", hl.dsp.workspace.move({ monitor = "-1" }))
hl.bind(MOD .. " + SHIFT + right", hl.dsp.workspace.move({ monitor = "+1" }))
hl.bind(MOD .. " + CTRL + left", hl.dsp.window.move({ monitor = "-1" }))
hl.bind(MOD .. " + CTRL + right", hl.dsp.window.move({ monitor = "+1" }))

-- Terminals and scratchpads
hl.bind(MOD .. " + Return", hl.dsp.exec_cmd(term))
hl.bind("ALT + SHIFT + Return", hl.dsp.exec_cmd("samedir"))
hl.bind(MOD .. " + SHIFT + Return", hl.dsp.workspace.toggle_special("spterm"))
hl.bind(MOD .. " + apostrophe", hl.dsp.workspace.toggle_special("spcalc"))

-- Launchers and apps
hl.bind(MOD .. " + D", hl.dsp.exec_cmd("wmenuapps favs")) -- favorites only
hl.bind(MOD .. " + backslash", hl.dsp.exec_cmd("wmenuapps")) -- favorites + PATH by usage
hl.bind(MOD .. " + SHIFT + D", hl.dsp.exec_cmd("passmenu"))
hl.bind(MOD .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(MOD .. " + E", hl.dsp.exec_cmd(term .. " -e lf"))
hl.bind(MOD .. " + SHIFT + E", hl.dsp.exec_cmd(term .. " -e neomutt")) -- email client
hl.bind(MOD .. " + R", hl.dsp.exec_cmd(term .. " -e htop"))
hl.bind(MOD .. " + SHIFT + R", hl.dsp.exec_cmd("ranbg"))
hl.bind(MOD .. " + C", hl.dsp.exec_cmd("code"))
hl.bind(MOD .. " + N", hl.dsp.exec_cmd(term .. " -e nvim -c VimwikiIndex"))
hl.bind(MOD .. " + SHIFT + N", hl.dsp.exec_cmd(term .. " -e nvim -c VimwikiDiaryIndex"))
hl.bind(MOD .. " + M", hl.dsp.exec_cmd(term .. " -e ncmpcpp"))
hl.bind(MOD .. " + SHIFT + B", hl.dsp.exec_cmd("wmenubooks"))

-- Media
hl.bind(MOD .. " + P", hl.dsp.exec_cmd("playback-control toggle"))
hl.bind(MOD .. " + comma", hl.dsp.exec_cmd("playback-control prev"))
hl.bind(MOD .. " + period", hl.dsp.exec_cmd("playback-control next"))
hl.bind(MOD .. " + bracketleft", hl.dsp.exec_cmd("mpc seek -10"))
hl.bind(MOD .. " + bracketright", hl.dsp.exec_cmd("mpc seek +10"))

-- Volume
hl.bind(MOD .. " + SHIFT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && barsig 10"))
hl.bind(MOD .. " + minus", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3%- && barsig 10"))
hl.bind(MOD .. " + SHIFT + minus", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 10%- && barsig 10"))
hl.bind(MOD .. " + equal", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3%+ && barsig 10"))
hl.bind(MOD .. " + SHIFT + equal", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 10%+ && barsig 10"))

-- System
hl.bind(MOD .. " + BackSpace", hl.dsp.exec_cmd("sysact"))
hl.bind(MOD .. " + SHIFT + BackSpace", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(MOD .. " + SHIFT + L", hl.dsp.exec_cmd("blurlock"))
hl.bind(MOD .. " + grave", hl.dsp.exec_cmd("wmenuunicode"))
hl.bind(MOD .. " + Insert", hl.dsp.exec_cmd("snippets-type"))
hl.bind(MOD .. " + V", hl.dsp.exec_cmd("clippick"))
hl.bind(MOD .. " + SHIFT + V", hl.dsp.exec_cmd("clippick-img")) -- image clipboard history with preview
hl.bind(MOD .. " + F1", hl.dsp.exec_cmd("zathura ~/.local/share/KEYBINDINGS.pdf")) -- keybindings cheatsheet
hl.bind(MOD .. " + F2", hl.dsp.exec_cmd(term .. " --class floatterm -o remember_window_size=no -o initial_window_width=126c -o initial_window_height=41c -e less -Srf ~/.local/share/weatherreport"))
hl.bind(MOD .. " + F3", hl.dsp.exec_cmd("wmenuvm")) -- libvirt VM start/shutdown/destroy
hl.bind(MOD .. " + F4", hl.dsp.exec_cmd(term .. " -e pulsemixer"))
hl.bind(MOD .. " + F5", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(MOD .. " + F6", hl.dsp.exec_cmd("wmenubluetooth"))
hl.bind(MOD .. " + F8", hl.dsp.exec_cmd("mw -Y"))
hl.bind(MOD .. " + F9", hl.dsp.exec_cmd("wmenumount"))
hl.bind(MOD .. " + F10", hl.dsp.exec_cmd("wmenuumount"))
hl.bind(MOD .. " + F11", hl.dsp.exec_cmd("mpv --untimed --no-cache --no-osc --no-input-default-bindings --profile=low-latency --input-conf=/dev/null --title=webcam $(ls /dev/video[0,2,4,6,8] | tail -n 1)"))

-- Screenshots and recording
hl.bind("Print", hl.dsp.exec_cmd("screenshot region"))
hl.bind(MOD .. " + SHIFT + S", hl.dsp.exec_cmd("screenshot region"))
hl.bind(MOD .. " + SHIFT + Print", hl.dsp.exec_cmd("wmenuscreenshots"))
hl.bind(MOD .. " + SHIFT + P", hl.dsp.exec_cmd("wmenuscreenshots")) -- NJ81 has no Print key
hl.bind(MOD .. " + Print", hl.dsp.exec_cmd("wmenurecord"))
hl.bind(MOD .. " + Delete", hl.dsp.exec_cmd("wmenurecord kill"))

-- XF86 keys
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && barsig 10"), { locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3%+ && barsig 10"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3%- && barsig 10"), { locked = true, repeating = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playback-control prev"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playback-control next"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("mpc play"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("mpc pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("mpc stop"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +15% && barsig 3"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 15%- && barsig 3"), { locked = true, repeating = true })

-- Mouse
hl.bind(MOD .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(MOD .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(MOD .. " + mouse_up", hl.dsp.exec_cmd("hypr-gaps inc"))
hl.bind(MOD .. " + mouse_down", hl.dsp.exec_cmd("hypr-gaps dec"))
