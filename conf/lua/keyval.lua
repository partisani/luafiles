return function(tbl)
    return "# auto generated\n" .. table.concat(
        imap(tbl, function(v, _, k)
            return k .. "=" .. v
        end),
        "\n"
    )
end
