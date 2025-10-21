_G.conf = {
    distro = "void",
    scheme = require "assets.schemes" "base16.16.nebula",
    
    apps = { term = "ghostty", launcher = "wmenu-run" },
    font = { mono = "nanumgothiccoding", serif = "nanumgothiccoding", sans_serif = "nanumgothiccoding" },
}

conf.ghostty = {
    font_size = 10,
    font_family = conf.font.mono,
    window_padding_x = 30,
    window_padding_y = 30,
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
              conf.scheme.rgb5,
              conf.scheme.rgb3,
              conf.scheme.rgb8,
              conf.scheme.rgbB,
              conf.scheme.rgbA,
              conf.scheme.rgbD,
              conf.scheme.rgbE,
              conf.scheme.rgbC,
              conf.scheme.rgb7,
              conf.scheme.rgb9,
              conf.scheme.rgbF,
              conf.scheme.rgb1,
              conf.scheme.rgb2,
              conf.scheme.rgb4,
              conf.scheme.rgb6
    }
}
