return function(name)
    local text = read("assets/schemes/homemade/" .. name, true)
    local words = {}

    for word in text:gmatch("[^\n]+") do
        table.insert(words, word:match("^%S+"))
    end

    return {
        base00 = words[1],  base01 = words[2],  base02 = words[3],
        base03 = words[4],  base04 = words[5],  base05 = words[6],
        base06 = words[7],  base07 = words[8],  base08 = words[9],
        base09 = words[10], base0A = words[11], base0B = words[12],
        base0C = words[13], base0D = words[14], base0E = words[15],
        base0F = words[16],
    }
end
