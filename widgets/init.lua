local astal = require "astal"
local App = require "astal.gtk3.app"

astal.exec(string.format("sass %s %s", "./style.scss", "/tmp/astal.css"))

-- local Textbar = require "textbar"
local Sidebar = require "sidebar"

App:start({
    main = function()
        local Bar = Sidebar
        Bar(0)
        Bar(1)
    end,
    css = "/tmp/astal.css"
})
