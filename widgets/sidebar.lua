local Widget = require "astal.gtk3.widget"

return function(monitor)
    local Anchor = require "astal.gtk3" .Astal.WindowAnchor
    return Widget.Window({
        monitor = monitor,
        anchor = Anchor.TOP + Anchor.BOTTOM + Anchor.RIGHT,
        exclusivity = "EXCLUSIVE",
        Widget.CenterBox({
            Widget.Box({
                halign = "CENTER",
                valign = "START",
                -- Left/Top
                Widget.Label({ label = "21\n46" })
            }),
            Widget.Box({
                -- Center
                Widget.Label({ label = "·\n•\n·" })
            }),
            Widget.Box({
                halign = "CENTER",
                valign = "END",
                -- Right/Bottom
                Widget.Label({ label = "no" })
            }),
        }),
    })
end
