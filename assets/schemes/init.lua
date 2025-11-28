local schemes = {}

local function scheme_metatable(scheme)
    setmetatable(scheme, {
        __index = function(tbl, k)
            -- tbl.hexN should return #RRGGBB
            -- tbl.rgbN should return RRGGBB
            -- tbl.rawN should return {float R, float G, float B}

            if tonumber(k) then return end

            local methods = {
                hex = function(c) return c end,
                rgb = function(c) return c:sub(2) end,
                raw = function(c)
                    local r = tonumber(c:sub(2,3), 16) / 256
                    local g = tonumber(c:sub(4,5), 16) / 256
                    local b = tonumber(c:sub(6,7), 16) / 256
                    return {r, g, b}
                end
            }

            local method = k:sub(1,1) .. k:sub(2,2) .. k:sub(3,3)
            local num = tonumber(k:sub(4,4), 24)

            local color = tbl[num]

            if not color then return nil end

            return methods[method](color)
        end
    })

    return scheme
end

setmetatable(schemes, {
    __index = function(_, path)
        local mod, scheme = path:match("([^.]+)%.(.+)")

        mod = require("assets.schemes." .. mod)
        scheme = mod(scheme)

        return scheme_metatable(scheme)
    end,
    __call = function(self, path)
        return self[path]
    end
})

return schemes
