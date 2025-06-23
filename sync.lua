local data = require "conf"

-- Stolen from stack overflow: https://stackoverflow.com/questions/1283388/how-to-merge-two-tables-overwriting-the-elements-which-are-in-both
function merge(a, b)
    if type(a) == 'table' and type(b) == 'table' then
        for k,v in pairs(b) do if type(v)=='table' and type(a[k] or false)=='table' then merge(a[k],v) else a[k]=v end end
    end
    return a
end

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
            local fn = assert(load(s, nil, nil, merge(_G, data)))
            return fn(env)
        end)

        return res, filename
    end
}
