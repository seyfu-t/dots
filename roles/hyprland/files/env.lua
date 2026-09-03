local paths = require("paths")
local profile = require("profile")

local function set_all(vars)
    for name, value in pairs(vars) do
        hl.env(name, value)
    end
end

-- XDG base dirs
set_all({
    XDG_CONFIG_HOME = paths.config,
    XDG_CACHE_HOME = paths.cache,
    XDG_DATA_HOME = paths.data,
    XDG_STATE_HOME = paths.state,
})

-- Session
set_all({
    XDG_CURRENT_DESKTOP = "Hyprland",
    XDG_SESSION_TYPE = "wayland",
    XDG_SESSION_DESKTOP = "Hyprland",
    XDG_MENU_PREFIX = "arch-",

    -- Toolkit / desktop integration
    QT_QPA_PLATFORM = "wayland;xcb",
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1",
    QT_AUTO_SCREEN_SCALE_FACTOR = "1",
    QT_QPA_PLATFORMTHEME = "hyprqt6engine",
    -- GTK_THEME="Breeze-Dark",
    -- ICON_THEME="Breeze-Dark",
    MOZ_ENABLE_WAYLAND = "1",
    SDL_VIDEODRIVER = "wayland",
    GDK_SCALE = "1",
    GDK_BACKEND = "wayland,x11,*",
    CLUTTER_BACKEND = "wayland",

    -- SSH / KWallet
    SSH_AUTH_SOCK = paths.require_env("XDG_RUNTIME_DIR") .. "/ssh-agent.socket",
    SSH_ASKPASS = "/usr/bin/ksshaskpass",
    SSH_ASKPASS_REQUIRE = "prefer",
    GIT_ASKPASS = "/usr/bin/ksshaskpass",
})

-- PATH
local path = paths.require_env("PATH")

local function prepend_path(entry)
    path = entry .. ":" .. path
    hl.env("PATH", path)
end

prepend_path(paths.home .. "/.local/bin")
prepend_path(paths.data .. "/cargo/bin")
prepend_path("/usr/local/bin")

if profile.gpu == "nvidia" then
    set_all({
        -- Nvidia
        LIBVA_DRIVER_NAME = "nvidia",
        __GLX_VENDOR_LIBRARY_NAME = "nvidia",
        NVD_BACKEND = "direct",
        __GL_VRR_ALLOWED = "1", -- Could cause some issues, alternatively set to 0
        -- WLR_DRM_NO_ATOMIC="1", -- Probably deprecated since Hyprland isn't based on wlroots anymore
    })
elseif profile.gpu == "amd" then
    -- Currently nothing
else
    error("Unknown GPU profile: " .. tostring(profile.gpu), 0)
end

set_all({
    -- Electron
    ELECTRON_OZONE_PLATFORM_HINT = "auto",

    -- Other
    JAVA_HOME = "/usr/lib/jvm/default",

    -- Garbage that could clutter home dir
    ANSIBLE_HOME = paths.config .. "/ansible",
    ANSIBLE_CONFIG = paths.config .. "/ansible.cfg",
    ANSIBLE_GALAXY_CACHE_DIR = paths.cache .. "/ansible/galaxy_cache",
    WINEPREFIX = paths.data .. "/wineprefixes/default",
    GTK_RC_FILES = paths.config .. "/gtk-1.0/gtkrc",
    GTK2_RC_FILES = paths.config .. "/gtk-2.0/gtkrc:" .. paths.config .. "/gtk-2.0/gtkrc.mine",
    CUDA_CACHE_PATH = paths.cache .. "/nv",
    PARALLEL_HOME = paths.config .. "/parallel",
    KERAS_HOME = paths.state .. "/keras",

    GRADLE_USER_HOME = paths.data .. "/gradle",
    CARGO_HOME = paths.data .. "/cargo",
    RUSTUP_HOME = paths.data .. "/rustup",
    SQLITE_HISTORY = paths.state .. "/sqlite_history",
    PYENV_ROOT = paths.data .. "/pyenv",
    _JAVA_OPTIONS = '-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java',
    NPM_CONFIG_USERCONFIG = paths.data .. "/npm/npmrc",

    DVDCSS_CACHE = paths.data .. "/dvdcss",
    GNUPGHOME = paths.data .. "/gnupg",
    HISTFILE = paths.state .. "/bash/history",

    -- Other esoteric stuff
    DO_NOT_TRACK = "1",
})
