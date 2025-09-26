#!/usr/bin/env lua
-- run inside config dir. this allows you to run apps and custom commands.

-- fennel support
local fennel = require("fennel")
table.insert(package.loaders or package.searchers, fennel.searcher)

-- utilities
require "lib"

-- the script

local conf = require "cmds"

local entries = {}
local output = {}

for _, provider in pairs(conf.providers) do
    for i, result in ipairs(provider.results) do
        local text = provider.show(result)
        entries[text] = {
            provider = provider,
            index = i
        }
        table.insert(output, text)
    end
end

local output_file = io.open("/tmp/launch_entries.txt", "w")
output_file:write(table.concat(output, "\n"))
output_file:close()

local text = sh("cat /tmp/launch_entries.txt | " .. conf.launcher)

local selected = entries[text]
if selected then
    selected.provider:exec(selected.index)
else
    local handler = {}
    
    for _, _handler in pairs(conf.handlers) do
        if _handler.match(text) then
            handler = _handler
            goto skip
        end
    end
    
    ::skip::

    if handler.exec then
        handler:exec(text)
    else
        log(ERROR, "no handler for", "`" .. text .. "`")
    end
end
