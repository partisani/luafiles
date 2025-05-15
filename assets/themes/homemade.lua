--[[
read a file with this format as input,
and return a compatible 16 color scheme.

format:
COLOR0 anything else
COLOR1 can be typed
COLOR2 after the
COLOR3 colors are
COLOR4 declared
COLOR5
COLOR6 lorem ipsum
COLOR7 dolor sit
COLOR8 amet
COLOR9 consectetur
COLORA adipisci velit
COLORB
COLORC as you already
COLORD noticed, there
COLORE wasn't enough
COLORF space for it...

but now i have space for anything else down there >:)
]]--

return function(scheme)
    io.input("assets/themes/homemade-schemes/" .. scheme)
    local text = io.read("*all")
    local colors = {}

    for line in text:gmatch("[^\n]+") do
        local words = {}
        for word in line:gmatch("%S+") do table.insert(words, word) end

        table.insert(colors, words[1])
    end

    return {
        name = scheme,
        [0] = colors[ 1], colors[ 2], colors[ 3], colors[ 4],
              colors[ 5], colors[ 6], colors[ 7], colors[ 8],
              colors[ 9], colors[10], colors[11], colors[12],
              colors[13], colors[14], colors[15], colors[16]
    }
end
