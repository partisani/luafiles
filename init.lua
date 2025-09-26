require "lib"
_G.conf = require "conf"

return {
    files = {
        ["~/.config/kak/kakrc"] = read("config/kak/kakrc"),
        ["~/.config/user-dirs.dirs"] = read("config/misc/xdg-dirs")
    },
    tasks = {},
    commands = {},
}
