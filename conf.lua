local config_path = "/home/partisani/config/conf.lua"
local config_dir = "/home/partisani/config/"

return {
    config_path = config_path,
    config_dir = config_dir,
    apps = {
        term = "ghostty",
        editor = "kak"
    },
    theme = dofile(config_dir .. "assets/themes/base16.lua")("vice"),
    font = {
        mono = "Iosevka Ultra"
    }
}
