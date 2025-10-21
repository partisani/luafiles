require "lib"
require "conf"

local ghostty = require "conf.lua.ghostty"

local scheme_str = table.concat(
    imap(conf.scheme,
         function(x, _, k)
             return k ~= "name" and "\"" .. x .. "\"" or nil
         end), " ")

return {
    files = {
        ["~/.config/kak/kakrc"]             = read "conf/kakrc",
        ["~/.config/fontconfig/fonts.conf"] = read "conf/fontconfig",
        ["~/.config/niri/config.kdl"]       = read "conf/niri",
        ["~/.rcrc"]                         = read "conf/rcrc",
        ["~/.config/user-dirs.dirs"]        = read "conf/misc/xdg-dirs",
        ["~/.rustfmt.toml"]                 = read "conf/misc/rustfmt.toml",
        ["~/.config/ghostty/config"]        = ghostty(conf.ghostty),
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
    commands = {},
}
