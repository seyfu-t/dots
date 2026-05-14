local function require_env(name)
    local value = os.getenv(name)

    if value == nil or value == "" then
        error(name .. " is not set", 0)
    end

    return value
end

local home = require_env("HOME")

return {
    require_env = require_env,

    home = home,
    config = os.getenv("XDG_CONFIG_HOME") or home .. "/.config",
    cache = os.getenv("XDG_CACHE_HOME") or home .. "/.cache",
    data = os.getenv("XDG_DATA_HOME") or home .. "/.local/share",
    state = os.getenv("XDG_STATE_HOME") or home .. "/.local/state",
}
