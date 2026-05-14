hl.config({
    general = {
        layout = "dwindle",
        resize_on_border = false,
    },

    input = {
        kb_layout = "de",
        follow_mouse = 1,
        sensitivity = -0.5,
        numlock_by_default = true,

        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
            scroll_factor = 0.2,
        },
    },

    cursor = {
        no_hardware_cursors = 1,
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        vrr = 1,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        enable_anr_dialog = false,
    },

    master = {
        new_status = "master",
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    scale = 2,
    action = "workspace",
})

hl.device({
    name = "apple-inc.-apple-internal-keyboard-/-trackpad-1",
    sensitivity = 0,
})

hl.device({
    name = "bcm5974",
    sensitivity = 0.15,
})

hl.device({
    name = "epic mouse V1",
    sensitivity = -0.5,
})
