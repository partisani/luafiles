local json = require "JSON"

return function(tbl)
    return json:encode(tbl) .. "\n"
end
