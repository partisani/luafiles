;;; Helpers

(fn fmt [str ...] (string.format str ...))
(fn map [t ___fn___]
  (let [res {}]
    (each [key val (pairs t)] (tset res key (___fn___ val)))
    res))

(local usr (require :conf))
(local scheme-str
    (table.concat (collect [k v (pairs usr.scheme)]
                    (if (tonumber k)
                        (values (+ 1 k) (.. "\"" v "\"")))) " "))

;;; Tasks

{ ;; Generate a small CLUT and save as an ULTRAKILL palette.
  :gen_clut { :command
             (fmt "lutgen generate --output=$HOME/games/ultrakill/Palettes/Self.png -l 2 -- %s"
                  scheme-str)}
  
  ;; Apply a CLUT based on the current color scheme to every wallpaper
  ;; and save it to the correct subdirectory in parallel.
  :wallpapers { :commands (fmt "
                # Create sub-directories
                fd . ./ --type d --base-directory ~/config/assets/walls/
                | split row \"\\n\"
                | each {|dir|
                    let dir = $dir | str substring 2.. 
                    $\"($env.HOME)/generated/walls/($dir)\"
                } | each { ^mkdir -p $in } | print null

                lutgen generate --output=/tmp/clut.png -l 8 -- %s
                
                fd . ./ --type f --base-directory ~/config/assets/walls/
                | split row \"\\n\"
                | each {|file|
                    let file = $file | str substring 2..
                    [ $\"($env.HOME)/config/assets/walls/($file)\"
                      $\"($env.HOME)/generated/walls/($file)\" ]
                } | par-each { lutgen apply $in.0 -o=$\"($in.1)\" --hald-clut /tmp/clut.png | print } | print null
                " scheme-str)
                  :shell :nu }}
