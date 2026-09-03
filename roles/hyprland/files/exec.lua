local paths = require("paths")

local function run(cmd)
    hl.exec_cmd(cmd)
end

local function run_once(cmd)
    hl.on("hyprland.start", function()
        hl.exec_cmd(cmd)
    end)
end

-- Old `exec = ...`
-- These run when the config is loaded/reloaded.
run([[gsettings set org.gnome.desktop.interface gtk-theme "Breeze-Dark"]])
run([[gsettings set org.gnome.desktop.interface icon-theme "breeze-dark"]])
run([[gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"]])

for _, cmd in ipairs({
    -- Old `exec-once = ...`
    -- These run once on Hyprland startup.
    "mkdir -p " .. paths.data .. "/wineprefixes",
    "dbus-update-activation-environment --systemd --all",
    "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",

    "systemctl --user restart xdg-user-dirs.service",
    "systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-hyprland.service xdg-desktop-portal-gtk.service plasma-xdg-desktop-portal-kde.service",
    "systemctl --user restart hyprpolkitagent",
    "waybar",
    "dunst",
    "udiskie --no-automount --smart-tray",
    "nm-applet --indicator",
    "wl-paste --type text --watch cliphist store",
    "wl-paste --type image --watch cliphist store",
    "hypridle",
    "/usr/lib/pam_kwallet_init",
    [[bash -c 'ssh-add "$HOME"/.ssh/keys/id_* </dev/null']],
    "sleep 5 && nextcloud --background",
    "kbuildsycoca6", -- rebuild kde mime cache for dolphin's "open with" list

    -- Optional
    -- "blueman-applet", -- systray app for Bluetooth
    -- "$scrPath/swwwallpaper.sh", -- start wallpaper daemon
    -- "$scrPath/batterynotify.sh", -- battery notification
}) do
    run_once(cmd)
end
