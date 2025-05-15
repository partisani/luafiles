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

return function(scheme)
    local command = "yq -o=lua '.' assets/themes/base16-schemes/base16/" .. scheme .. ".yaml"
    scheme = load(os.capture(command))()

    local palette = scheme.palette

    return {
        name = scheme.name,
        [0] = palette.base00, palette.base01, palette.base02, palette.base03,
              palette.base04, palette.base05, palette.base06, palette.base07,
              palette.base08, palette.base09, palette.base0A, palette.base0B,
              palette.base0C, palette.base0D, palette.base0E, palette.base0F
    }
end
