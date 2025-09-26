#!/usr/bin/env lua
-- run inside config dir. this runs all defined tasks.

-- fennel support
local fennel = require("fennel")
table.insert(package.loaders or package.searchers, fennel.searcher)

-- utilities
require "lib"

-- the script

local conf = require "task"

for name, task in pairs(conf) do
    log(INFO, "running task", name)
    if task.command then
        log(HIDE, "running command `" .. task.command .. "`")
        os.execute(task.command)
    end

    if task.commands then
        log(TEXT, "running commands...")
        local tmp = io.open("/tmp/cmds", "w")
        tmp:write(task.commands)
        tmp:close()
        os.execute((task.shell or "bash") .. " /tmp/cmds")
    end
end
