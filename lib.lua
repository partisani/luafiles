_G.INFO = 1
_G.ERR  = 2
_G.TEXT = 3
_G.HIDE = 4

function _G.log(level, ...)
    local fmt = {
        "\027[32;1m[#]",
        "\027[31;1m[!]",
        "\027[2m:::",
        "\027[2m",
    }
    print(fmt[level], table.concat({...}, " "), "\027[0m")
end

function _G.assert(v, message)
    if v then return v
    else
        log(ERR, message)
        os.exit(false, true) -- exit with error, close the lua state
    end
end

function _G.format(text)
    return text:gsub("::(.-)::", function(s) return load(s)() end)
end

function _G.read(filename, no_formatting)
    local file = assert(io.open(filename, "r"))
    local content = file:read("a")
    
    file:close()
    
    return no_formatting and content or format(content)
end

function _G.write(filename, content)
    local file = assert(io.open(filename, "w+"))
    file:write(content)
    file:close()
end
