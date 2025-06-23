-- helper
function fmt(str, ...)
    return string.format(str, ...)
end

-- helper
function map(t, fn)
    local res = {}
    for key, val in pairs(t) do
        res[key] = fn(val)
    end
    return res
end

local usr = require "conf"

local theme_str = table.concat(
    map(usr.theme, function(v) return '"'..v..'"' end), " ")

return {
    wallpapers = {
        commands = fmt(
            [[
            # Create sub-directories
            fd . ./ --type d --base-directory ~/config/assets/walls/
            | split row "\n"
            | each {|dir|
                let dir = $dir | str substring 2.. 
                $"($env.HOME)/generated/walls/($dir)"
            } | each { ^mkdir -p $in } | print null

            lutgen generate --output=/tmp/clut.png -G -i=128 -m=2.0 -s=80.0 -- %s
            
            fd . ./ --type f --base-directory ~/config/assets/walls/
            | split row "\n"
            | each {|file|
                let file = $file | str substring 2..
                [ $"($env.HOME)/config/assets/walls/($file)"
                  $"($env.HOME)/generated/walls/($file)" ]
            } | par-each { lutgen apply $in.0 -o=$"($in.1)" --hald-clut /tmp/clut.png | print } | print null
            ]],
            theme_str
        ),
        shell = "nu"
    },
    gen_clut = {
        command = fmt(
            "lutgen generate --output=$HOME/games/ultrakill/Palettes/Self.png -l 2 -- %s",
            theme_str
        ),
    },
}
