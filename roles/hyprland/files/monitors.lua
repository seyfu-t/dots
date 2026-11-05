local profile = require("profile")

if profile.dynamic_monitors then
    local internal = profile.monitors[1]

    -- Sensible fallback for arbitrary external displays.
    hl.monitor({
        output = "",
        mode = "preferred",
        position = "auto",
        scale = "auto",
    })

    local function read_lid_closed()
        -- Only needed so config reloads while the lid is already closed
        -- retain the correct state. No subprocess involved.
        local paths = {
            "/proc/acpi/button/lid/LID/state",
            "/proc/acpi/button/lid/LID0/state",
            "/proc/acpi/button/lid/LID1/state",
        }

        for _, path in ipairs(paths) do
            local file = io.open(path, "r")

            if file ~= nil then
                local state = file:read("*a")
                file:close()

                return state ~= nil and state:match("closed") ~= nil
            end
        end

        return false
    end

    local lid_closed = read_lid_closed()

    local function enable_internal()
        hl.monitor({
            output = internal.output,
            mode = internal.mode,
            position = internal.position,
            scale = internal.scale,
            vrr = internal.vrr,
            disabled = false,
        })
    end

    local function disable_internal()
        hl.monitor({
            output = internal.output,
            disabled = true,
        })
    end

    local function get_state()
        local internal_monitor = nil
        local external_active = false

        -- This is the crucial 0.57 feature.
        for _, monitor in ipairs(hl.get_monitors({ all = true })) do
            if monitor.name == internal.output then
                internal_monitor = monitor
            elseif monitor.enabled then
                external_active = true
            end
        end

        return internal_monitor, external_active
    end

    local function reconcile(force)
        local internal_monitor, external_active = get_state()

        -- Only disable the laptop panel when BOTH conditions are true:
        --
        --   lid closed
        --   usable external display exists
        --
        -- Thus unplugging the external monitor always brings eDP back,
        -- even if the lid is still closed.
        local should_enable = not (lid_closed and external_active)

        if should_enable then
            if force or internal_monitor == nil or not internal_monitor.enabled then
                enable_internal()
            end
        else
            if force or internal_monitor == nil or internal_monitor.enabled then
                disable_internal()
            end
        end
    end

    -- Establish the correct rule immediately, including on config reload.
    reconcile(true)

    hl.on("hyprland.start", function()
        reconcile(false)
    end)

    hl.on("monitor.added", function()
        reconcile(false)
    end)

    hl.on("monitor.removed", function()
        reconcile(false)
    end)

    hl.bind("switch:on:Lid Switch", function()
        lid_closed = true
        reconcile(false)
    end, { locked = true })

    hl.bind("switch:off:Lid Switch", function()
        lid_closed = false
        reconcile(false)
    end, { locked = true })
else
    for _, monitor in ipairs(profile.monitors) do
        hl.monitor({
            output = monitor.output,
            mode = monitor.mode,
            position = monitor.position,
            scale = monitor.scale,
            vrr = monitor.vrr,
        })
    end
end
