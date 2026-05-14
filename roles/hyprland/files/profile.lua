local function read_first_line(cmd)
    local handle = io.popen(cmd)

    if handle == nil then
        return nil
    end

    local line = handle:read("*l")
    handle:close()

    if line == nil or line == "" then
        return nil
    end

    return line
end

local function profile_from_hostname(name)
    if name == nil then
        return nil
    end

    name = name:lower()

    if name:find("laptop", 1, true) then
        return "laptop"
    end

    if name:find("pc", 1, true) then
        return "desktop"
    end

    return nil
end

local hostname = os.getenv("HOSTNAME") or read_first_line("hostname")

local selected = os.getenv("HYPR_PROFILE") or profile_from_hostname(hostname)

if selected == nil then
    error("Unknown Hyprland profile for hostname: " .. tostring(hostname), 0)
end

local profiles = {
    desktop = {
        gpu = "nvidia",

        monitors = {
            {
                output = "DP-1",
                mode = "highres@highrr",
                position = "1920x0",
                scale = 1,
                vrr = 2,
            },
            {
                output = "DP-2",
                mode = "highres@highrr",
                position = "0x0",
                scale = 1,
                vrr = 2,
            },
        },
    },

    laptop = {
        gpu = "amd",

        monitors = {
            {
                output = "eDP-1",
                mode = "preferred",
                position = "0x0",
                scale = 2,
                vrr = 0,
            },
        },

    },
}

local profile = profiles[selected]

if profile == nil then
    error("Invalid Hyprland profile: " .. selected, 0)
end

profile.name = selected
profile.hostname = hostname

return profile
