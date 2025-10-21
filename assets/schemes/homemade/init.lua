return function(name)
    local text = read("assets/schemes/homemade/" .. name, true)
    local words = {}

    for word in text:gmatch("[^\n]+") do
        table.insert(words, word:match("^%S+"))
    end

    return {
        name = name,
        [0] = words[1],  words[2],  words[3],  words[4],
              words[5],  words[6],  words[7],  words[8],
              words[9],  words[10], words[11], words[12],
              words[13], words[14], words[15], words[16]
    }
end
