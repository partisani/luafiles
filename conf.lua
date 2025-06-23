local config_path = "/home/partisani/config/conf.lua"
local config_dir = "/home/partisani/config/"

local conf = {
    config_path = config_path,
    config_dir = config_dir,
    apps = {
        term = "ghostty",
        editor = "kak"
    },
    theme = require "assets.themes.base16"
                ("rose-pine-moon", nil), -- if second argument is non-nil, use base24
            -- require "assets.themes.homemade" "eink",
    font = {
        mono = "Iosevka Ultra"
    }
}

setmetatable(conf.theme, {
    __index = function(tbl, k)
        -- tbl.hexN should return #RRGGBB
        -- tbl.nhxN should return RRGGBB
        -- tbl.rawN should return {float R, float G, float B}
        -- tbl.rgbN should return rgb(R, G, B)

        if tonumber(k) then return end
        
        local methods = {
            hex = function(c) return c end,
            nhx = function(c) return c:sub(2) end,
            raw = function(c)
                local r = tonumber(c:sub(2,3), 16) / 256
                local g = tonumber(c:sub(4,5), 16) / 256
                local b = tonumber(c:sub(6,7), 16) / 256
                return {r, g, b}
            end
        }
        local method = k:sub(1,1) .. k:sub(2,2) .. k:sub(3,3)
        local num = tonumber(k:sub(4,4), 16)

        local color = tbl[num]

        return methods[method](color)
    end
})

return conf
