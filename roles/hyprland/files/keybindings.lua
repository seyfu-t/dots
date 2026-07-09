local paths = require("paths")
local scripts = paths.config .. "/hypr/scripts"

local mainMod = "SUPER"

local term = "gtk-launch kitty"
local editor = "gtk-launch dev.zed.Zed"
local editor2 = "gtk-launch codium"
local file = "gtk-launch org.kde.dolphin"
local browser = "gtk-launch app.zen_browser.zen"
local colorpicker = "hyprpicker -a"
local mail = "gtk-launch eu.betterbird.Betterbird || gtk-launch thunderbird"
local sysmon = "gtk-launch io.missioncenter.MissionCenter"

local function exec(cmd)
    return hl.dsp.exec_cmd(cmd)
end

-- bindn = non-consuming
hl.bind(
    "Scroll_Lock",
    hl.dsp.pass({ window = "class:^(discord)$" }),
    { non_consuming = true }
)

-- General keybinds
hl.bind("ALT + F4", hl.dsp.window.kill())
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + Delete", hl.dsp.exit())

hl.bind(mainMod .. " + Backspace", exec("pkill -x rofi || " .. paths.config .. "/rofi/powermenu/type-5/powermenu.sh"))
hl.bind(mainMod .. " + Space", exec("pkill -x rofi || " .. paths.config .. "/rofi/launchers/type-2/launcher.sh"))

hl.bind(mainMod .. " + L", exec("hyprlock --grace 2"))
hl.bind(mainMod .. " + D", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind("ALT + Return", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind("CTRL + Escape", exec("killall waybar || waybar"))
hl.bind("CTRL + F12", exec("python " .. scripts .. "/toggle_audio_sinks.py"))

-- App shortcuts
hl.bind(mainMod .. " + T", exec(term))
hl.bind(mainMod .. " + E", exec(file))
hl.bind(mainMod .. " + Z", exec(editor))
hl.bind(mainMod .. " + C", exec(editor2))
hl.bind(mainMod .. " + F", exec(browser))
hl.bind(mainMod .. " + B", exec(mail))
hl.bind(mainMod .. " + SHIFT + C", exec(colorpicker))
hl.bind("CTRL + SHIFT + Escape", exec(sysmon))

hl.bind(mainMod .. " + V", exec("pkill -x rofi || cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

hl.bind(mainMod .. " + SHIFT + S", exec("grimblast copysave area /tmp/screenshot.png && swappy -f /tmp/screenshot.png"))
hl.bind(mainMod .. " + Print",
    exec("grimblast --freeze copysave area /tmp/screenshot.png && swappy -f /tmp/screenshot.png"))
hl.bind("Print", exec("grimblast copysave screen /tmp/screenshot.png && swappy -f /tmp/screenshot.png"))

-- Util
hl.bind("XF86AudioLowerVolume", exec(scripts .. "/volume_control.nu -d 5"), { repeating = true })
hl.bind("XF86AudioRaiseVolume", exec(scripts .. "/volume_control.nu -i 5"), { repeating = true })
hl.bind("XF86AudioMute", exec(scripts .. "/volume_control.nu -d 100"), { repeating = true })

hl.bind("XF86MonBrightnessUp", exec("brightnessctl --class backlight set +10%"), { repeating = true })
hl.bind("XF86MonBrightnessDown", exec("brightnessctl --class backlight set 10%-"), { repeating = true })
hl.bind("XF86KbdBrightnessUp", exec("brightnessctl --device :white:kbd_backlight set +10%"), { repeating = true })
hl.bind("XF86KbdBrightnessDown", exec("brightnessctl --device :white:kbd_backlight set 10%-"), { repeating = true })

hl.bind("XF86AudioPrev", exec("playerctl previous"), { repeating = true })
hl.bind("XF86AudioPlay", exec("playerctl play-pause"), { repeating = true })
hl.bind("XF86AudioNext", exec("playerctl next"), { repeating = true })

-- Navigation & Movement
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("ALT + Tab", hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special(""))
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("ALT + 1", hl.dsp.focus({ workspace = 6 }))
hl.bind("ALT + 2", hl.dsp.focus({ workspace = 7 }))
hl.bind("ALT + 3", hl.dsp.focus({ workspace = 8 }))
hl.bind("ALT + 4", hl.dsp.focus({ workspace = 9 }))
hl.bind("ALT + 5", hl.dsp.focus({ workspace = 10 }))

hl.bind(mainMod .. " + CTRL + S", hl.dsp.window.move({ workspace = "special", follow = false }))
hl.bind(mainMod .. " + CTRL + 1", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind(mainMod .. " + CTRL + 2", hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind(mainMod .. " + CTRL + 3", hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind(mainMod .. " + CTRL + 4", hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind(mainMod .. " + CTRL + 5", hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind("CTRL + ALT + 1", hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind("CTRL + ALT + 2", hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind("CTRL + ALT + 3", hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind("CTRL + ALT + 4", hl.dsp.window.move({ workspace = 9, follow = false }))
hl.bind("CTRL + ALT + 5", hl.dsp.window.move({ workspace = 10, follow = false }))
