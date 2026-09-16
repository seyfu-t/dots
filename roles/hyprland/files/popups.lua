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

hl.on("window.open", function(w)
    if w.class ~= "app.zen_browser.zen" then return end
    if w.initial_title ~= "Zen Browser" then return end

    local zen_windows = hl.get_windows({ class = "app.zen_browser.zen" })
    if #zen_windows <= 1 then return end

    -- Make it look like a popup immediately.
    hl.dispatch(hl.dsp.window.float({
        action = "set",
        window = w,
    }))
    position_popup(w)

    local sub
    sub = hl.on("window.title", function(tw)
        if tw.address ~= w.address then return end

        if tw.title == ""
            or tw.title == "Zen Browser"
            or tw.title == "about:blank" then
            return
        end

        sub:remove()

        if tw.title:sub(1, #"Extension:") == "Extension:" then
            -- Repair Firefox's pre-title positioning.
            position_popup(tw)

            -- Firefox/Zen then does:
            -- normal -> maximized -> normal.
            -- Wait for that cycle to finish before applying the final position.
            local saw_maximize = false
            local fs_sub

            fs_sub = hl.on("window.fullscreen", function(fw)
                if fw.address ~= tw.address then return end

                if fw.fullscreen == 1 then
                    saw_maximize = true
                    return
                end

                if saw_maximize and fw.fullscreen == 0 then
                    fs_sub:remove()
                    fs_sub = nil

                    position_popup(fw)
                end
            end)

            return
        end

        -- It was just another ordinary Zen window.
        hl.dispatch(hl.dsp.window.float({
            action = "unset",
            window = tw,
        }))
    end)
end)
