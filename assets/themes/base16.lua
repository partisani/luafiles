-- stolen from stack overflow
function os.capture(cmd, raw)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    return s
end

return function(scheme, use24)
    local command = "yq -o=lua eval '... comments=\"\"' assets/themes/base16-schemes/base" ..
        (use24 and "24/" or "16/") .. scheme .. ".yaml"
    scheme = load(os.capture(command))()

    local palette = scheme.palette

    return {
        name = scheme.name,
        [0] = palette.base00, palette.base01, palette.base02, palette.base03,
              palette.base04, palette.base05, palette.base06, palette.base07,
              palette.base08, palette.base09, palette.base0A, palette.base0B,
              palette.base0C, palette.base0D, palette.base0E, palette.base0F,
              palette.base11, palette.base12, palette.base13, palette.base14, -- basically nil
              palette.base15, palette.base16, palette.base17                  -- if non existent
    }
end
