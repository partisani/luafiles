local lib = {}

lib.INFO = 1
lib.ERR  = 2
lib.TEXT = 3
lib.HIDE = 4

function lib.map(tbl, fn)
    local out = {}
    
    for k, v in pairs(tbl) do
        out[k] = fn(v, tbl, k)
    end
    
    return out
end

function lib.imap(tbl, fn)
    local out = {}
    
    for k, v in pairs(tbl) do
        local vals = { fn(v, tbl, k) }
        map(vals, function(v) table.insert(out, v) end)
    end
    
    return out
end

function lib.log(level, ...)
    local fmt = {
        "\027[32;1m[#]",
        "\027[31;1m[!]",
        "\027[2m:::",
        "\027[2m",
    }
    print(fmt[level], table.concat({...}, " "), "\027[0m")
end

function lib.dbg(val)
    print(type(val) == "table"
            and (require "inspect")(val)
            or val)
end

function lib.assert(v, message)
    if v then return v
    else
        log(ERR, message)
        os.exit(false, true) -- exit with error, close the lua state
    end
end

function lib.format(text)
    return text:gsub("::(.-)::",
        function(str)
            local val = load("return " .. str, nil, nil, _G.conf)()
            return assert(val, "'" .. str .. "' returned nil")
        end)
end

function lib.read(filename, no_formatting)
    local file = assert(io.open(filename, "r"))
    local content = file:read("a")
    
    file:close()
    
    return no_formatting and content or format(content)
end

function lib.write(filename, content)
    local file = assert(io.open(filename, "w+"))
    file:write(content)
    file:close()
end

function lib.exec(...)
    os.execute(table.concat({...}, " "))
end

function lib.sh(cmd, raw)
    -- https://stackoverflow.com/questions/132397/get-back-the-output-of-os-execute-in-lua
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    return s
end

for k, v in pairs(lib) do
    _G[k] = v
end

_G.lib = lib

function string.split(self, sep, max)
    -- http://lua-users.org/wiki/SplitJoin at splitByPatternSeparator
    sep = '^(.-)'..sep
    local t,n,p, q,r,s = {},1,1, self:find(sep)
    while q and n~=max do
        t[n],n,p = s,n+1,r+1
        q,r,s = self:find(sep,p)
    end
    t[n] = self:sub(p)
    return t
end
