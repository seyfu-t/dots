local popup_size = { 1300, 760 }

local function popup(match)
    hl.window_rule({
        match = match,
        float = true,
        size = popup_size,
        center = true,
    })
end

-- Generic centered popups
popup({ class = [[org\.freedesktop\.impl\.portal\.desktop\.kde|xdg-desktop-portal-gtk]] })
popup({ class = [[io\.missioncenter\.MissionCenter]] })
popup({ class = "signal" })
popup({ class = "nm-connection-editor" })
popup({ class = [[org\.pulseaudio\.pavucontrol]] })
popup({ class = [[org\.kde\.ark]] })
popup({ class = [[org\.kde\.okular]] })

popup({ class = [[firefox|app\.zen_browser\.zen]], title = "Library", })
popup({ initial_class = [[org\.mozilla\.Thunderbird|eu\.betterbird\.Betterbird]], initial_title = "Write:.*", })
popup({ title = "Steam Settings", })

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

-- Steam friends list should stay small
hl.window_rule({
    match = {
        title = "Friends List",
    },
    float = true,
    move = { 1616, 380 },
})

-- Special case for IntelliJ IDEA
hl.window_rule({
    match = {
        class = "jetbrains-idea",
        title = "win(.*)",
    },
    no_initial_focus = true,
})


-- Annoying Browser Extension bullshittery

local function position_popup(w)
    hl.dispatch(hl.dsp.window.resize({
        x = popup_size[1],
        y = popup_size[2],
        window = w,
    }))

    hl.dispatch(hl.dsp.window.center({
        window = w,
    }))
end

hl.window_rule({
    match = {
        initial_class = "app\\.zen_browser\\.zen",
        initial_title = "Zen Browser",
    },
    suppress_event = "maximize fullscreen",
})

hl.on("window.open", function(w)
    if w.class ~= "app.zen_browser.zen" then return end
    if w.initial_title ~= "Zen Browser" then return end

    -- Don't affect the first/main Zen window.
    local zen_windows = hl.get_windows({ class = "app.zen_browser.zen" })
    if #zen_windows <= 1 then return end

    -- Float immediately, before we know what this window actually is.
    hl.dispatch(hl.dsp.window.float({
        action = "set",
        window = w,
    }))
    position_popup(w)

    local sub
    sub = hl.on("window.title", function(tw)
        if tw.address ~= w.address then return end

        -- Ignore Firefox/Zen's intermediate titles.
        if tw.title == ""
            or tw.title == "Zen Browser"
            or tw.title == "about:blank" then
            return
        end

        sub:remove()

        -- Keep extension windows floating.
        if tw.title:sub(1, #"Extension:") == "Extension:" then
            position_popup(tw)
            return
        end

        -- It turned out to be a normal Zen window.
        hl.dispatch(hl.dsp.window.float({
            action = "unset",
            window = tw,
        }))
    end)
end)
