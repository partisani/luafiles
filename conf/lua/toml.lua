local toml = require "toml"

return function(tbl)
    return toml.encode(tbl) .. "\n"
end
