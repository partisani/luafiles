# version = "0.103.0"

# Misc #

# Env #

# Adding entries to path
use std "path add"
path add ~/scripts/
path add ~/.cargo/bin/
path add ~/.local/bin/
path add ~/.bin

# Changing the default apps
$env.VISUAL = "#<< apps.editor >>"
$env.EDITOR = "#<< apps.editor >>"
$env.TERMINAL = "#<< apps.term >>"

# Aliases #

alias la = ls -a
alias ll = ls -l

def luadbg [ file: string ] {
    lua -e ("require('debugger').call(function() loadfile('" + $file + "')() end)")
}

def --env jmp [ --relative (-r) ] {
    cd (fd -t d . (if $relative { "." } else { "/" }) | sk)
}

# Aesthetics #

# Changing/Fixing prompts
$env.PROMPT_COMMAND = {||
    let path = match (do -i { $env.PWD | path relative-to $env.HOME }) {
        null => $env.PWD
        '' => '~'
        $pwd => ([~ $pwd] | path join)
    }

    let path_col = (ansi lub)
    let path_sep = "/"
    
    $path | str replace -a (char path_sep) $path_sep | $"($path_col)[" + $in + "]"
}
$env.PROMPT_INDICATOR = " "
$env.PROMPT_COMMAND_RIGHT = ""

$env.TRANSIENT_PROMPT_COMMAND = $"(ansi lub)[#]"

# Table looks
$env.config.table.mode = "light"

# Remove `ls` colors
$env.LS_COLORS = ""

# Remove welcome banner
$env.config.show_banner = false

# Make hints readable in `transparent` theme
$env.config.color_config.hints = "light_gray"
