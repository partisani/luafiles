return function(tbl)
    return "# auto generated\n" .. table.concat(
        imap(tbl, function(v, _, k)
            k = k:gsub("%_", "-")
            if type(v) ~= "table" then
                return k .. " = " .. v
            else
                return table.unpack(
                    imap(v, function(iv, _, ik)
                        return k .. " = " .. ik .. "=" .. iv
                    end)
                )
            end
        end),
        "\n"
    )
end
