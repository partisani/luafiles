_G.conf = {
    distro = "void",
    scheme = require "assets.schemes" "base16.16.vulcan",
    path   = "/home/partisani/config",
    font   = { mono = "OCR A BT", serif = "OCR A BT", sans_serif = "OCR A BT" },
}

conf.apps = {
    term = "ghostty",
    launcher = "wmenu -i"
        .. " -N " .. conf.scheme.rgb0
        .. " -n " .. conf.scheme.rgb5
        .. " -M " .. conf.scheme.rgb1
        .. " -n " .. conf.scheme.rgb5
        .. " -S " .. conf.scheme.rgb8
        .. " -s " .. conf.scheme.rgb0
}

conf.ghostty = {
    font_size = 10,
    font_family = conf.font.mono,
    window_padding_x = 20,
    window_padding_y = 20,
    adjust_cell_height = "20%",

    background = conf.scheme.rgb0,
    foreground = conf.scheme.rgb5,

    selection_background = conf.scheme.rgb2,
    selection_foreground = conf.scheme.rgb0,

    palette = {
        [0] = conf.scheme.rgb0,
              conf.scheme.rgb8,
              conf.scheme.rgbB,
              conf.scheme.rgbA,
              conf.scheme.rgbD,
              conf.scheme.rgbE,
              conf.scheme.rgbC,
              conf.scheme.rgb6 or conf.scheme.rgb3, -- base24
              conf.scheme.rgb2 or conf.scheme.rgb8, -- base24
              conf.scheme.rgbI or conf.scheme.rgbB, -- base24
              conf.scheme.rgbK or conf.scheme.rgbA, -- base24
              conf.scheme.rgbJ or conf.scheme.rgbD, -- base24
              conf.scheme.rgbM or conf.scheme.rgbE, -- base24
              conf.scheme.rgbN or conf.scheme.rgbC, -- base24
              conf.scheme.rgbL or conf.scheme.rgb5, -- base24
              conf.scheme.rgb7,
              conf.scheme.rgb9,
              conf.scheme.rgbF,
              conf.scheme.rgb1,
              conf.scheme.rgb2,
              conf.scheme.rgb4,
              conf.scheme.rgb6
    },

    keybind = {
        ["ctrl+q"] = "close_window",
        ["performable:ctrl+c"] = "copy_to_clipboard"
    },

    -- env = {
    --     GTK_IM_MODULE = "simple"
    -- }
}

conf.niri = {
    gaps = 30,
    
    border = {
        --width = 4,
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
