#!/usr/bin/env lua
-- run inside config dir. this syncs all config to .config directory

-- fennel support
local fennel = require("fennel")
table.insert(package.loaders or package.searchers, fennel.searcher)

-- utilites
require "lib"

-- the script

local conf = require "sync"

local dirs = sh("ls -d */"):split(" ") -- List directories

for _, dir in ipairs(dirs) do
    dir = dir:sub(1, -2) -- Remove trailing slash

    local dir_conf = conf.targets[dir] or conf.targets[0]
    dir_conf.target = (dir_conf.target or ""):gsub("~", os.getenv("HOME"))
    local should_omit_prefix = conf.targets[dir] and true

    log(INFO, "found dir", dir)

    if dir_conf.skip then
        log(TEXT, "skipping", dir)
        goto skip
    end

    local files = sh("find " .. dir .. " -type f -print0 | tr '\\0' '\t'"):split("\t") -- Magic to support filenames with spaces
    log(TEXT, "found " .. table.concat(files, ", "))

    for _, file in ipairs(files) do
        local original_filename = file
        if should_omit_prefix then file = file:match("^" .. dir .. "/(.*)") or str end

        log(HIDE, "processing " .. file)

        io.input(original_filename)

        local text, filename = conf.process(io.read("*all"), file)
        file = file:gsub(".*/?(.+)", filename)

        if pcall(function() io.output(dir_conf.target .. file) end) then
            io.write(text)
            log(HIDE, "wrote " .. file)
        else
            log(ERROR, "couldn't open \"" .. dir_conf.target .. file .. "\" for writing, skipping...")
        end
    end

    ::skip::
end
