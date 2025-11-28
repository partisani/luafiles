require "lib"
require "conf"

local ghostty = require "conf.lua.ghostty"
local keyval  = require "conf.lua.keyval"
local toml    = require "conf.lua.toml"

local scheme_str = table.concat(
    imap(conf.scheme,
         function(x, _, k)
             return k ~= "name" and "\"" .. x .. "\"" or nil
         end), " ")

_G.init = {
    files = {
        ["~/.config/kak/kakrc"]             = read "conf/kakrc",
        ["~/.config/fontconfig/fonts.conf"] = read "conf/fontconfig",
        ["~/.config/niri/config.kdl"]       = read "conf/niri",
        ["~/.rcrc"]                         = read "conf/rcrc",
        ["~/.config/user-dirs.dirs"]        = read "conf/misc/xdg-dirs",
        ["~/.config/eww/"]                  = readdir "conf/eww/",
        ["~/.rustfmt.toml"]                 = toml(conf.rustfmt),
        ["~/.config/ghostty/config"]        = ghostty(conf.ghostty),
        ["~/.config/swaylock/config"]       = keyval(conf.swaylock)
    },
    tasks = {
        wallpapers = {
            run = function()
                exec("lutgen generate --output=/tmp/clut.png -l 8 --",
                     scheme_str)

                local target = os.getenv("HOME") .. "/gen/walls/"
                
                map(
                    sh("fd . -t f --base-directory assets/walls", true):split("\n"),
                    function(str)
                        exec("lutgen apply assets/walls/" .. str, "-o=" .. target .. str:gsub("/", "."), "--hald-clut /tmp/clut.png")
                    end
                )
            end,
        },
        ultrakill_palette = {
            cmd = "lutgen generate --output=/games/ultrakill/Palettes/Self.png -l 2 -- " .. scheme_str
        }
    },
    commands = {
        term = function(...)
            local args = { ... }
            exec(conf.apps.term, #args > 0 and "-e" or nil, table.unpack(args))
        end,
        wall = function(...)
            local args = { ... }

            if args[1] then
                exec("swww clear", conf.scheme["rgb" .. args[1]])
                return
            end

            local home = os.getenv("HOME")
            local walls =
                filter(
                    require "posix.dirent".dir(home .. "/gen/walls"),
                    function(file)
                        return file:sub(1,1) ~= ".", home .. "/gen/walls/" .. file
                    end
                )

            local select = require "bin.menu" (walls)

            exec("swww img", select, "-t wipe")
        end
    },
    handlers = {
        { -- Run user-defined commands
            match = function(str)
                return bool(str:match(":.+"))
            end,
            run = function(str)
                local words = map(str:split(" "), function(v)
                    return v:gsub("%+", " ") -- replace + with <space>
                end)
                
                local cmd = words[1]:sub(2)
                cmd = init.commands[cmd]

                cmd(table.unpack(words, 2))
            end
        },
    },
}

return init
