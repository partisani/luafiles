# version = "0.103.0"

# Misc #

# Env #

# Adding entries to path
use std "path add"
path add ~/scripts/
path add ~/.cargo/bin/
path add ~/.local/bin/

# Changing the default apps
$env.VISUAL = "@|return apps.editor|@"
$env.EDITOR = "@|return apps.editor|@"
$env.TERMINAL = "@|return apps.term|@"

# Aliases #

alias la = ls -a
alias ll = ls -l

def l [...rest] {
    ls ...$rest | sort-by type | grid -cis " \\ "
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
