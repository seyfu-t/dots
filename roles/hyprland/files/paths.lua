local function require_env(name)
    local value = os.getenv(name)

    if value == nil or value == "" then
        error(name .. " is not set", 0)
    end

    return value
end

local home = require_env("HOME")

local function xdg_dir(name, fallback)
    local value = os.getenv(name)
    return value ~= nil and value ~= "" and value or home .. fallback
end

return {
    require_env = require_env,
    shell_quote = function(value)
        return "'" .. value:gsub("'", "'\\''") .. "'"
    end,

    home = home,
    config = xdg_dir("XDG_CONFIG_HOME", "/.config"),
    cache = xdg_dir("XDG_CACHE_HOME", "/.cache"),
    data = xdg_dir("XDG_DATA_HOME", "/.local/share"),
    state = xdg_dir("XDG_STATE_HOME", "/.local/state"),
}
