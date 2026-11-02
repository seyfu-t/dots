local session_environment = table.concat({
    "WAYLAND_DISPLAY",
    "HYPRLAND_INSTANCE_SIGNATURE",
    "SSH_ASKPASS",
    "SSH_ASKPASS_REQUIRE",
    "SSH_AUTH_SOCK",
    "PATH",
    "XDG_CACHE_HOME",
    "XDG_CONFIG_HOME",
    "XDG_CURRENT_DESKTOP",
    "XDG_DATA_HOME",
    "XDG_SESSION_DESKTOP",
    "XDG_SESSION_TYPE",
    "XDG_STATE_HOME",
    "XDG_RUNTIME_DIR",
    "QT_QPA_PLATFORM",
}, " ")

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd " .. session_environment ..
        " && systemctl --user start hyprland-session.target")
end)

hl.on("hyprland.shutdown", function()
    hl.exec_cmd("systemctl --user stop graphical-session.target hyprland-session.target")
end)
