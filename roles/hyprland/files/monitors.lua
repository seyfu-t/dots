local profile = require("profile")

for _, monitor in ipairs(profile.monitors) do
    hl.monitor({
        output = monitor.output,
        mode = monitor.mode,
        position = monitor.position,
        scale = tostring(monitor.scale),
        vrr = monitor.vrr,
    })
end

for _, workspace in ipairs(profile.workspaces) do
    hl.workspace_rule({
        workspace = tostring(workspace.id),
        monitor = workspace.monitor,
        default = workspace.default or false,
    })
end
