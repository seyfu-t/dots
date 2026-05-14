local popup_size = { 1300, 760 }

local function popup(match)
    hl.window_rule({
        match = match,
        float = true,
        size = popup_size,
        center = true,
    })
end

-- Picture-in-Picture
hl.window_rule({
    match = {
        class = [[firefox|app\.zen_browser\.zen]],
        title = "Picture-in-Picture",
    },
    float = true,
    pin = true,
    size = popup_size,
})

-- Generic centered popups
popup({ class = [[org\.freedesktop\.impl\.portal\.desktop\.kde|xdg-desktop-portal-gtk]] })
popup({ class = [[io\.missioncenter\.MissionCenter]] })
popup({ class = "signal" })
popup({ class = "nm-connection-editor" })
popup({ class = [[org\.pulseaudio\.pavucontrol]] })
popup({ class = [[org\.kde\.ark]] })
popup({ class = [[org\.kde\.okular]] })

-- Steam popups
hl.window_rule({
    match = {
        title = "Friends List",
    },
    float = true,
    move = { 1616, 380 },
})

hl.window_rule({
    match = {
        title = "Steam Settings",
    },
    float = true,
    center = true,
})

-- Browser library popup
hl.window_rule({
    match = {
        class = [[firefox|app\.zen_browser\.zen]],
        title = "Library",
    },
    float = true,
})

-- Mail compose window
hl.window_rule({
    match = {
        initial_class = [[org\.mozilla\.Thunderbird|eu\.betterbird\.Betterbird]],
        initial_title = "Write:.*",
    },
    float = true,
})

-- Special case for IntelliJ IDEA
hl.window_rule({
    match = {
        class = "jetbrains-idea",
        title = "win(.*)",
    },
    no_initial_focus = true,
})
