_G.conf = {
    distro = "void",
    -- scheme = require "assets.schemes" "homemade.teto",
    scheme = require "assets.schemes" "base16.16.heetch",
    path   = "/home/partisani/config",
    font   = { mono = "NanumGothicCoding", serif = "NanumGothicCoding", sans_serif = "NanumGothicCoding" },
}

conf.apps = {
    term = "alacritty",
    launcher = "wmenu -i"
        .. " -N " .. conf.scheme.rgb0
        .. " -n " .. conf.scheme.rgb5
        .. " -M " .. conf.scheme.rgb1
        .. " -n " .. conf.scheme.rgb5
        .. " -S " .. conf.scheme.rgb8
        .. " -s " .. conf.scheme.rgb0
}

conf.alacritty = {
    font = {
        size = 10,
        normal = { family = conf.font.mono },
        offset = { x = 0, y = 3 },
    },

    window = {
        padding = { x = 15, y = 15 },
    },

    keyboard = {
        bindings = {
            { mods = "Control", key = "Return", action = "SpawnNewInstance" }
        },
    },

    colors = {
        draw_bold_text_with_bright_colors = false,

        primary = {
            foreground = conf.scheme.hex5,
            background = conf.scheme.hex0
        },
        normal = {
            black   = conf.scheme.hex0,
            red     = conf.scheme.hex8,
            green   = conf.scheme.hexB,
            yellow  = conf.scheme.hexA,
            blue    = conf.scheme.hexD,
            magenta = conf.scheme.hexE,
            cyan    = conf.scheme.hexC,
            white   = conf.scheme.hex5
        },
        bright = {
            black   = conf.scheme.hex3,
            red     = conf.scheme.hex9,
            green   = conf.scheme.hex1,
            yellow  = conf.scheme.hex2,
            blue    = conf.scheme.hex4,
            magenta = conf.scheme.hex6,
            cyan    = conf.scheme.hexF,
            white   = conf.scheme.hex7
        },
    },
}

conf.niri = {
    gaps = 20,

    border = {
        false,
        width = 4,
        color_active = conf.scheme.hex5,
        color_inactive = conf.scheme.hex5 .. "77",
        radius = 0,
    },

    shadow = {
        false,
        softness = 0,
        spread = 0,
        offset = { x = 0, y = 20 },
        color_active = conf.scheme.hex5,
        color_inactive = conf.scheme.hex5 .. "77",
    },

    tab_indicator = {
        width = 4,
        len = 1.0,
        gap = 10
    },

    startup = {
        "eww daemon; eww open-many status:main status:snd --arg main:mon=0 --arg snd:mon=1",
        "swww-daemon",
        "pipewire",
    },
}

conf.rustfmt = {
    imports_layout = "Vertical",
    imports_granularity = "One",
    group_imports = "StdExternalCrate",
    max_width = 79
}

conf.swaylock = {
    color = conf.scheme.rgbG or conf.scheme.rgb1
}
