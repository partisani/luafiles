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

local usr = dofile "conf.lua"

local theme_str = table.concat(
    map(usr.theme, function(v) return '"'..v..'"' end), " ")

return {
    wallpapers = {
        command = fmt(
            "lutgen apply assets/walls/* --output=$HOME/generated/walls -G -i=64 -- %s",
            theme_str
        ),
    },
    gen_clut = {
        command = fmt(
            "lutgen generate --output=$HOME/games/ultrakill/Palettes/Self.png -G -m=0.2 -s=40 -i=16 -- %s",
            theme_str
        ),
    },
}
