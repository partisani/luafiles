require "lib"

local desktop = {}

local posix = require "posix"

local home = os.getenv("HOME")

local dirs = {
    "/usr/share/applications",
    "/usr/local/share/applications",
    "/var/lib/flatpak/exports/share/applications",
    home .. "/files/desktop",
    home .. "/.local/share/applications",
    home .. "/.local/share/flatpak/exports/share/applications",
}

function desktop.entries()
    local files = imap(dirs, function(path)
        if not posix.sys.stat.stat(path) then return end
        return table.unpack(
            filter(posix.dirent.dir(path), function(v)
                return v:match("desktop$"), path .. "/" .. v
            end)
        )
    end)

    return imap(files, function(v)
        return kmap(
            (require "ini").parse(v).Desktop_Entry,
            function(v, _, k)
                return k:gsub("([a-z])([A-Z])", "%1_%2"):lower(), v
            end
        )
    end)
end

function desktop.apps()
    return filter(desktop.entries(), function(v)
        -- https://github.com/kennylevinsen/dot-desktop/blob/ba8cd7337ad53d492084eec27a5e3f87f44fc60a/src/main.rs#L103
        return (not v.hidden) and (not v.no_display)
            and (v.type == "Application" or v.type == "Link")
    end)
end

function desktop.exec(entry, arg, methods)
    local methods = methods or { terminal = "ghostty -e", url = "firefox" }
    local arg = arg or ""
    local prefix = entry.terminal and methods.terminal .. " " or ""

    return prefix .. entry.exec:gsub("%%(.)",
        { f = arg, F = arg, u = arg, U = arg })
end

return desktop
