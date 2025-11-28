local lib = {}

package.path = package.path .. ";./?"

lib.INFO = 1
lib.ERR  = 2
lib.TEXT = 3
lib.HIDE = 4

-- Iterating

function lib.map(tbl, fn)
    local out = {}
    
    for k, v in pairs(tbl) do
        out[k] = fn(v, tbl, k)
    end
    
    return out
end

function lib.kmap(tbl, fn)
    local out = {}

    for k, v in pairs(tbl) do
        local key, val = fn(v, tbl, k)
        if key then out[key] = val end
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

function lib.filter(tbl, fn)
    local out = {}

    for k, v in pairs(tbl) do
        local keep, val = fn(v, tbl, k)
        if keep then
            table.insert(out, val or v)
        end
    end

    return out
end

-- Types

function bool(v)
    return not not v
end

-- Debuggers

function lib.log(level, ...)
    local fmt = {
        "\027[32;1m[#]",
        "\027[31;1m[!]",
        "\027[2m:::",
        "\027[2m",
    }
    print(fmt[level] or level, table.concat({...}, " "), "\027[0m")
end

function lib.dbg(val)
    print(type(val) == "table"
            and (require "inspect")(val)
            or val)
    return val
end

function lib.assert(v, message)
    if v then return v
    else
        log(ERR, message)
        os.exit(false, true) -- exit with error, close the lua state
    end
end

-- Filesystem

function lib.format(text, tbl)
    return text:gsub("::(.-)::",
        function(str)
            local val = load("return " .. str, nil, nil, tbl)()
            return assert(val, "'" .. str .. "' returned nil")
        end)
end

function lib.read(filename, no_format)
    local file = assert(io.open(filename, "r"))
    local content = file:read("a")
    
    file:close()

    local tbl = {}

    if not no_format then
        tbl = table.shallow(_G.conf)
        setmetatable(tbl, { __index = _G })
    end
    
    return no_format and content or format(content, tbl)
end

function lib.readdir(path, no_format)
    local files = require "posix.dirent".dir(path)

    return kmap(files, function(f)
        if f:sub(1,1) == "." then return end
        return f, lib.read(path .. f, no_format)
    end)
end

function lib.write(filename, content)
    local file = assert(io.open(filename, "w+"))
    file:write(content)
    file:close()
end

-- Commands

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

-- Extensions

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

function table.shallow(self)
    local out = {}

    for k, v in pairs(self) do
        out[k] = v
    end

    return out
end
