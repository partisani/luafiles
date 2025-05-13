local inspect = require("inspect")

return {
    targets = {
        [0] = { target = "~/.config/" }, -- [0] is the root, directories are written to
                                         -- <target>/<dir>/<file> as in ~/.config/ghostty/config
        misc = { target = "~/.config/" },
        home = { target = "~/" },
        assets = { skip = true },
    },
    process = function(text, filename)
        local _, match_end, directives = text:find("^@ (.-) @\n")
        if directives then
            text = text:sub(match_end + 1)
            directives = load("return " .. directives)()

            filename = directives.filename
        end
    
        local res = text:gsub("@%|(.-)%|@", function(s)
            local fn = assert(load(s, nil, nil, dofile "conf.lua"))
            return fn(env)
        end)

        return res, filename
    end
}
